@tool
extends Resource

class_name NoiseLayerData

enum LayerType {
	SIMPLE,
	RIDGED,
}

@export var type: LayerType = LayerType.SIMPLE:
	set(value):
		type = value
		emit_changed()

@export var enabled : bool = true:
	set(value):
		enabled = value
		emit_changed()

@export var useFirstLayerAsMask : bool = true:
	set(value):
		useFirstLayerAsMask = value
		emit_changed()

@export var strength : float = 3.0:
	set(value):
		strength = value
		emit_changed()

@export var numLayers : int = 3:
	set(value):
		numLayers = value
		emit_changed()

@export var baseRoughness : float = 1.0:
	set(value):
		baseRoughness = value
		emit_changed()

@export var roughness : float = 3.0:
	set(value):
		roughness = value
		emit_changed()

@export var persistence : float = 0.25:
	set(value):
		persistence = value
		emit_changed()

@export var minHeight : float = 0.5:
	set(value):
		minHeight = value
		emit_changed()
