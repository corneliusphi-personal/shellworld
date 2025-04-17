@tool
extends Resource

class_name NoiseFilter

var layers: Array[NoiseFilterLayer] = []

func _init(shellWorldData: ShellWorldData) -> void:
	for layer in layers:
		layer.free()
	layers = []
	for layer in shellWorldData.noiseLayers:
		if layer.type == NoiseLayerData.LayerType.SIMPLE:
			layers.append(SimpleNoiseFilterLayer.new())
		if layer.type == NoiseLayerData.LayerType.RIDGED:
			layers.append(RidgedNoiseFilterLayer.new())

func evaluate(point : Vector3, shellWorldData: ShellWorldData) -> Array:
	if (shellWorldData.noiseLayers == null or shellWorldData.noiseLayers.size() == 0):
		return [point, 0]
	var elevation = 0
	var mask = 1
	var firstLayer =  shellWorldData.noiseLayers[0]
	if (firstLayer != null and firstLayer.enabled):
		elevation += layers[0].evaluateLayer(point, shellWorldData, firstLayer)
		mask = elevation
	for i in range(1, shellWorldData.noiseLayers.size()):
		var noiseLayerData = shellWorldData.noiseLayers[i]
		if (noiseLayerData != null and noiseLayerData.enabled):
			var layerElevation = layers[i].evaluateLayer(point, shellWorldData, noiseLayerData)
			var layerMask = 1
			if (noiseLayerData.useFirstLayerAsMask):
				layerMask = mask
			elevation += layerElevation * layerMask
	var pointWithElevation = point * (elevation + 1)
	return [pointWithElevation, elevation]
