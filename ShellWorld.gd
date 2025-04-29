@tool
extends Node3D

class_name ShellWorld

@export var shellWorldData : ShellWorldData:
		set(value):
				print("ShellWorld: Setting shellWorldData")
				shellWorldData = value
				if shellWorldData != null && not shellWorldData.is_connected("changed", on_data_changed):
						print("ShellWorld: Connecting to shellWorldData changed signal")
						shellWorldData.connect("changed", on_data_changed)

var shellArray : Array[Shell] = []
var noiseFilter : NoiseFilter

func _ready() -> void:
	print("ShellWorld: _ready called")
	on_data_changed()

func create_shells():
	if (shellWorldData == null):
		return
	for shell in shellArray:
		if (shell != null):
			print("ShellWorld: freeing shell")
			shell.queue_free()
	
	generate_shell_data()
	
	noiseFilter = NoiseFilter.new(shellWorldData)
	
	if (shellWorldData.biomeNoise == null):
		shellWorldData.biomeNoise = FastNoiseLite.new()
	var biomeTexture = Biome.generateBiomeTexture(shellWorldData)
	print("Generated biome texture: ", biomeTexture)
	if biomeTexture != null:
		print("Generated texture size: ", biomeTexture.get_size())
		print("Generated texture format: ", biomeTexture.get_format())
		print("Generated texture data: ", biomeTexture.get_image().get_data().slice(0, 16))
	
	print("ShellWorld: creating Shell")
	shellArray.resize(shellWorldData.shellCount)
	for i in range(shellWorldData.shellCount):
		shellWorldData.shellData[i].biomeTexture = biomeTexture
		var shell = Shell.new(noiseFilter, shellWorldData.shellData[i])
		shellArray[i] = shell
		add_child(shell)

func generate_shell_data() -> void:
	if (shellWorldData.shellData.size() < shellWorldData.shellCount):
		var extraShells =  shellWorldData.shellCount - shellWorldData.shellData.size()
		print("Need more ShellData: ", extraShells)
		for i in range(extraShells):
			print("creating shell")
			shellWorldData.shellData.append(ShellData.new())
	for i in range(shellWorldData.shellCount):
		print("checking ShellData: ", i)
		if (shellWorldData.shellData[i].noiseMaps.size() < shellWorldData.noiseLayers.size()):
			var extraNoiseMaps = shellWorldData.noiseLayers.size() - shellWorldData.shellData[i].noiseMaps.size()
			print("insufficient noiseMaps at: ", i, extraNoiseMaps)
			for j in range(extraNoiseMaps):
				print("creating FastNoiseLite")
				shellWorldData.shellData[i].noiseMaps.append(FastNoiseLite.new())
		for j in range(shellWorldData.noiseLayers.size()):
			if shellWorldData.noiseLayers[j].type == NoiseLayerData.LayerType.SIMPLE:
				print("setting simplex")
				shellWorldData.shellData[i].noiseMaps[j].noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
				shellWorldData.shellData[i].noiseMaps[j].fractal_octaves = 5
			if shellWorldData.noiseLayers[j].type == NoiseLayerData.LayerType.RIDGED:
				print("setting perlin")
				shellWorldData.shellData[i].noiseMaps[j].noise_type = FastNoiseLite.NoiseType.TYPE_PERLIN
				shellWorldData.shellData[i].noiseMaps[j].fractal_octaves = 1

func on_data_changed() -> void:
	print("ShellWorld: on_data_changed")
	create_shells()
	if (shellWorldData == null):
		print("ShellWorld: shellWorldData is null in on_data_changed")
		return
	for i in range(shellArray.size()):
		shellArray[i].regenerate_mesh(shellWorldData, i + 1)
	
