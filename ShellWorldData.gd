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

@export var minHeight : float = 1.0:
	set(value):
		minHeight = value
		emit_changed()

@export var amplitude : float = 1.0:
	set(value):
		amplitude = value
		emit_changed()

@export var frequency : float = 1.0:
	set(value):
		frequency = value
		emit_changed()

@export var removeZeroTriangles : bool = true:
	set(value):
		removeZeroTriangles = value
		emit_changed()

@export var noiseMap : FastNoiseLite:
	set(value):
		noiseMap = value
		emit_changed()
		if noiseMap != null && not noiseMap.is_connected("changed", emit_changed):
			noiseMap.connect("changed", emit_changed)
