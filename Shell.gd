@tool
extends Node3D

class_name Shell

var up : ShellMeshFace
var down : ShellMeshFace
var left : ShellMeshFace
var right : ShellMeshFace
var forward : ShellMeshFace
var back : ShellMeshFace

var material: ShaderMaterial
var shellData: ShellData

func _init(noiseFilter : NoiseFilter, _shellData) -> void:
	shellData = _shellData
	shellData.maxHeight = -999999.0
	shellData.minHeight = 9999999.0
	if (material == null):
		print("Setting Material")
		material = ShaderMaterial.new()
	if (material.shader == null):
		print("Setting Material Shader")
		var HeightShader := load("res://heightShader.gdshader")
		print("Shader will be: ", HeightShader)
		material.shader = HeightShader
	up = ShellMeshFace.new(Vector3.UP, noiseFilter, material, shellData)
	down = ShellMeshFace.new(Vector3.DOWN, noiseFilter, material, shellData)
	left = ShellMeshFace.new(Vector3.LEFT, noiseFilter, material, shellData)
	right = ShellMeshFace.new(Vector3.RIGHT, noiseFilter, material, shellData)
	forward = ShellMeshFace.new(Vector3.FORWARD, noiseFilter, material, shellData)
	back = ShellMeshFace.new(Vector3.BACK, noiseFilter, material, shellData)
	add_child(up)
	add_child(down)
	add_child(left)
	add_child(right)
	add_child(forward)
	add_child(back)

func regenerate_mesh(shellWorldData: ShellWorldData, shellNum: int) -> void:
	shellData.minHeight = 9999999.0
	shellData.maxHeight = -99999999.0
	print("Shell: regenerate_mesh")
	up.regenerate_mesh(shellWorldData, shellNum)
	if (!shellWorldData.renderTopOnly):
		down.regenerate_mesh(shellWorldData, shellNum)
		left.regenerate_mesh(shellWorldData, shellNum)
		right.regenerate_mesh(shellWorldData, shellNum)
		forward.regenerate_mesh(shellWorldData, shellNum)
		back.regenerate_mesh(shellWorldData, shellNum)
