@tool
extends Resource

class_name NoiseFilter

func evaluate(point : Vector3, shellWorldData: ShellWorldData) -> Array:
	var value = shellWorldData.noiseMap.get_noise_3dv(point * 10 * shellWorldData.frequency)
	value = (value + 1) * 0.5
	var elevation = max(0.0, value - shellWorldData.minHeight)
	var elevationVector = point.normalized() * (elevation + 1) * shellWorldData.amplitude
	var pointWithElevation = point + elevationVector
	return [pointWithElevation, elevation]
