@tool
extends Node3D

class_name Shell

var up : ShellMeshFace
var down : ShellMeshFace
var left : ShellMeshFace
var right : ShellMeshFace
var forward : ShellMeshFace
var back : ShellMeshFace

func _init(noiseFilter : NoiseFilter, material: ShaderMaterial) -> void:
	up = ShellMeshFace.new(Vector3.UP, noiseFilter, material)
	down = ShellMeshFace.new(Vector3.DOWN, noiseFilter, material)
	left = ShellMeshFace.new(Vector3.LEFT, noiseFilter, material)
	right = ShellMeshFace.new(Vector3.RIGHT, noiseFilter, material)
	forward = ShellMeshFace.new(Vector3.FORWARD, noiseFilter, material)
	back = ShellMeshFace.new(Vector3.BACK, noiseFilter, material)
	add_child(up)
	add_child(down)
	add_child(left)
	add_child(right)
	add_child(forward)
	add_child(back)

func regenerate_mesh(shellWorldData: ShellWorldData, shellNum: int) -> void:
	shellWorldData.minHeight = 9999999.0
	shellWorldData.maxHeight = -99999999.0
	print("Shell: regenerate_mesh")
	up.regenerate_mesh(shellWorldData, shellNum)
	if (!shellWorldData.renderTopOnly):
		down.regenerate_mesh(shellWorldData, shellNum)
		left.regenerate_mesh(shellWorldData, shellNum)
		right.regenerate_mesh(shellWorldData, shellNum)
		forward.regenerate_mesh(shellWorldData, shellNum)
		back.regenerate_mesh(shellWorldData, shellNum)
