@tool
extends Resource

class_name NoiseFilter

func evaluate(point : Vector3, shellWorldData: ShellWorldData) -> Array:
	return [point, 0]
