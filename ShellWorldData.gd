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
		for i in range(noiseLayers.size()):
			if noiseLayers[i] != null && not noiseLayers[i].is_connected("changed", emit_changed):
				noiseLayers[i].connect("changed", emit_changed)

@export var shellData : Array[ShellData] = []:
	set(value):
		shellData = value
		emit_changed()
		for i in range(shellData.size()):
			if shellData[i] != null && not shellData[i].is_connected("changed", emit_changed):
				shellData[i].connect("changed", emit_changed)

@export var biomes : Array[BiomeData] = []:
	set(value):
		biomes = value
		emit_changed()
		for i in range(biomes.size()):
			if biomes[i] != null && not biomes[i].is_connected("changed", emit_changed):
				biomes[i].connect("changed", emit_changed)

@export var heightColor : GradientTexture1D:
	set(value):
		heightColor = value
		emit_changed()

@export var biomeNoise : FastNoiseLite:
	set(value):
		biomeNoise = value
		emit_changed()

@export var biomeAmplitude : float = 1.0:
		set(value):
			biomeAmplitude = value
			emit_changed()
