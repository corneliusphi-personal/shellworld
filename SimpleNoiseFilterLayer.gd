@tool
extends "NoiseFilterLayer.gd"

class_name SimpleNoiseFilterLayer

func evaluateLayer(
	point : Vector3,
	shellWorldData: ShellWorldData,
	noiseLayerData: NoiseLayerData
) -> float:
	var noiseValue: float = 0.0
	var frequency : float = noiseLayerData.baseRoughness
	var amplitude: float = 1.0
	var maxAmplitude: float = 1.0
	for i in range(noiseLayerData.numLayers):
		maxAmplitude += amplitude
		# Between -1 and 1
		var rawNoise = noiseLayerData.noiseMap.get_noise_3dv(point * frequency)
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
