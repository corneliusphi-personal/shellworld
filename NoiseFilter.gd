@tool
extends Resource

class_name NoiseFilter

func evaluate(point : Vector3, shellWorldData: ShellWorldData) -> Array:
	var elevation = _evaluateLayer(point, shellWorldData, shellWorldData.noiseLayerData)
	var pointWithElevation = point * (elevation + 1)
	return [pointWithElevation, elevation]

func _evaluateLayer(
	point : Vector3,
	shellWorldData: ShellWorldData,
	noiseLayerData: NoiseLayerData
) -> float:
	if(!noiseLayerData.enabled):
		return 0
	var noiseValue: float = 1.0
	var frequency : float = noiseLayerData.baseRoughness
	var amplitude: float = noiseLayerData.amplitude
	for i in range(noiseLayerData.numLayers):
		# Between -1 and 1
		var rawNoise = shellWorldData.noiseMap.get_noise_3dv(point * frequency)
		# Between 0 and 1
		var value = (rawNoise + 1) + 0.5
		# Between 0 and Amplitude
		var valueWithAmplitude = value * amplitude
		noiseValue += valueWithAmplitude
		frequency *= noiseLayerData.roughness
		amplitude *= noiseLayerData.persistence
	var elevation = max(0.0, noiseValue - shellWorldData.minHeight)
	return elevation
