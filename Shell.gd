@tool
extends Node3D

class_name Shell

var up : ShellMeshFace
var down : ShellMeshFace
var left : ShellMeshFace
var right : ShellMeshFace
var forward : ShellMeshFace
var back : ShellMeshFace

func _init(noiseFilter : NoiseFilter) -> void:
	up = ShellMeshFace.new(Vector3.UP, noiseFilter)
	down = ShellMeshFace.new(Vector3.DOWN, noiseFilter)
	left = ShellMeshFace.new(Vector3.LEFT, noiseFilter)
	right = ShellMeshFace.new(Vector3.RIGHT, noiseFilter)
	forward = ShellMeshFace.new(Vector3.FORWARD, noiseFilter)
	back = ShellMeshFace.new(Vector3.BACK, noiseFilter)
	add_child(up)
	add_child(down)
	add_child(left)
	add_child(right)
	add_child(forward)
	add_child(back)

func regenerate_mesh(shellWorldData: ShellWorldData, shellNum: int) -> void:
	print("Shell: regenerate_mesh")
	up.regenerate_mesh(shellWorldData, shellNum)
	down.regenerate_mesh(shellWorldData, shellNum)
	left.regenerate_mesh(shellWorldData, shellNum)
	right.regenerate_mesh(shellWorldData, shellNum)
	forward.regenerate_mesh(shellWorldData, shellNum)
	back.regenerate_mesh(shellWorldData, shellNum)
