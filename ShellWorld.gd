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

@export var material: ShaderMaterial

func _ready() -> void:
	print("ShellWorld: _ready called")
	on_data_changed()

func create_shells():
	if (material == null):
		print("Setting Material")
		material = ShaderMaterial.new()
	if (material.shader == null):
		print("Setting Material Shader")
		var HeightShader := load("res://heightShader.gdshader")
		print("Shader will be: ", HeightShader)
		material.shader = HeightShader
	if (shellWorldData == null):
		return
	for shell in shellArray:
		if (shell != null):
			print("ShellWorld: freeing shell")
			shell.queue_free()
	noiseFilter = NoiseFilter.new(shellWorldData)
	print("ShellWorld: creating Shell")
	shellArray.resize(shellWorldData.shellCount)
	for i in range(shellWorldData.shellCount):
		var shell = Shell.new(noiseFilter, material)
		shellArray[i] = shell
		add_child(shell)
	

func on_data_changed() -> void:
	print("ShellWorld: on_data_changed")
	create_shells()
	if (shellWorldData == null):
		print("ShellWorld: shellWorldData is null in on_data_changed")
		return
	for i in range(shellArray.size()):
		shellArray[i].regenerate_mesh(shellWorldData, i + 1)
	
