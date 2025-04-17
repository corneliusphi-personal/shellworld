@tool
extends Resource

class_name ShellWorldData

@export_range(1, 10, 1) var globalResolution : int = 1:
		set(value):
			globalResolution = value
			emit_changed()

@export var radius : int = 1:
		set(value):
			radius = value
			emit_changed()

@export var shellCount : int = 1:
		set(value):
			shellCount = value
			emit_changed()

@export var removeZeroTriangles : bool = true:
	set(value):
		removeZeroTriangles = value
		emit_changed()

@export var noiseLayers : Array[NoiseLayerData]:
	set(value):
		noiseLayers = value
		emit_changed()
