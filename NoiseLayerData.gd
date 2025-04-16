@tool
extends Resource

class_name NoiseLayerData

@export var enabled : bool = true:
	set(value):
		enabled = value
		emit_changed()

@export var amplitude : float = 3.0:
	set(value):
		amplitude = value
		emit_changed()

@export var numLayers : int = 3:
	set(value):
		numLayers = value
		emit_changed()

@export var baseRoughness : float = 1.0:
	set(value):
		baseRoughness = value
		emit_changed()

@export var roughness : float = 2.0:
	set(value):
		roughness = value
		emit_changed()

@export var persistence : float = 0.5:
	set(value):
		persistence = value
		emit_changed()
