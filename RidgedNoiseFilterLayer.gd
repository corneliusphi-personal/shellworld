@tool
extends "NoiseFilterLayer.gd"

class_name RidgedNoiseFilterLayer

func evaluateLayer(
	point : Vector3,
	shellWorldData: ShellWorldData,
	noiseLayerData: NoiseLayerData
) -> float:
	var noiseValue: float = 0.0
	var frequency : float = noiseLayerData.baseRoughness
	var amplitude: float = 1.0
	var maxAmplitude: float = 1.0
	var weight: float = 1.0
	for i in range(noiseLayerData.numLayers):
		maxAmplitude += amplitude
		# Between 0 and 1
		var rawNoise = 1 - abs(noiseLayerData.noiseMap.get_noise_3dv(point * frequency))
		# Between 0 and Amplitude
		var value = rawNoise * rawNoise
		value = value * weight
		weight = value
		var valueWithAmplitude = value * amplitude
		noiseValue += valueWithAmplitude
		frequency *= noiseLayerData.roughness
		amplitude *= noiseLayerData.persistence
	var elevation = max(0.0, noiseValue - noiseLayerData.minHeight)
	return elevation * noiseLayerData.strength
