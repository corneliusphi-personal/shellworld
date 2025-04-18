@tool
extends Resource

class_name ShellData

# Calculated Variables
var minHeight: float = 99999.0
var maxHeight: float = -999999.0

@export var noiseMaps : Array[FastNoiseLite]:
	set(value):
		noiseMaps = value
		emit_changed()
