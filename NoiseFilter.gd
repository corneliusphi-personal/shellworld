@tool
extends Resource

class_name NoiseFilter

func evaluate(point : Vector3, shellWorldData: ShellWorldData) -> Array:
	if (shellWorldData.noiseLayers == null or shellWorldData.noiseLayers.size() == 0):
		return [point, 0]
	var elevation = 0
	var mask = 1
	var firstLayer =  shellWorldData.noiseLayers[0]
	if (firstLayer != null and firstLayer.enabled):
		elevation += _evaluateLayer(point, shellWorldData, firstLayer)
		mask = elevation
	for i in range(1, shellWorldData.noiseLayers.size()):
		var noiseLayerData = shellWorldData.noiseLayers[i]
		if (noiseLayerData != null and noiseLayerData.enabled):
			var layerElevation = _evaluateLayer(point, shellWorldData, noiseLayerData)
			var layerMask = 1
			if (noiseLayerData.useFirstLayerAsMask):
				layerMask = mask
			elevation += layerElevation * layerMask
	var pointWithElevation = point * (elevation + 1)
	return [pointWithElevation, elevation]

func _evaluateLayer(
	point : Vector3,
	shellWorldData: ShellWorldData,
	noiseLayerData: NoiseLayerData
) -> float:
	var noiseValue: float = 1.0
	var frequency : float = noiseLayerData.baseRoughness
	var amplitude: float = 1.0
	var maxAmplitude: float = 1.0
	for i in range(noiseLayerData.numLayers):
		maxAmplitude += amplitude
		# Between -1 and 1
		var rawNoise = shellWorldData.noiseMap.get_noise_3dv(point * frequency)
		# Between 0 and 1
		var value = (rawNoise + 1) * 0.5
		# Between 0 and Amplitude
		var valueWithAmplitude = value * amplitude
		noiseValue += valueWithAmplitude
		frequency *= noiseLayerData.roughness
		amplitude *= noiseLayerData.persistence
	#peg noiseValue between 0 and 1
	var limitedNoise = noiseValue / maxAmplitude
	var elevation = max(0.0, limitedNoise - noiseLayerData.minHeight)
	return elevation * noiseLayerData.strength
