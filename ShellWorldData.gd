@tool
extends Resource

class_name ShellWorldData

@export var renderTopOnly : bool = false:
	set(value):
		renderTopOnly = value
		emit_changed()

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

@export var noiseLayers : Array[NoiseLayerData] = []:
	set(value):
		noiseLayers = value
		emit_changed()

@export var shellData : Array[ShellData] = []:
	set(value):
		shellData = value
		emit_changed()
		
@export var heightColor : GradientTexture1D:
	set(value):
		heightColor = value
		emit_changed()
