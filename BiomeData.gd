@tool
extends Resource

class_name BiomeData

@export var gradient : GradientTexture1D:
	set(value):
		gradient = value
		emit_changed()
		if gradient != null && not gradient.is_connected("changed", emit_changed):
			gradient.connect("changed", emit_changed)

@export var startHeight : float:
	set(value):
		startHeight = value
		emit_changed()
