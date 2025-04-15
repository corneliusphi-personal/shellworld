@tool
extends Node3D

class_name Shell

var up : ShellMeshFace
var down : ShellMeshFace
var left : ShellMeshFace
var right : ShellMeshFace
var forward : ShellMeshFace
var back : ShellMeshFace

func _init() -> void:
	up = ShellMeshFace.new(Vector3.UP)
	down = ShellMeshFace.new(Vector3.DOWN)
	left = ShellMeshFace.new(Vector3.LEFT)
	right = ShellMeshFace.new(Vector3.RIGHT)
	forward = ShellMeshFace.new(Vector3.FORWARD)
	back = ShellMeshFace.new(Vector3.BACK)
	add_child(up)
	add_child(down)
	add_child(left)
	add_child(right)
	add_child(forward)
	add_child(back)

func regenerate_mesh(shellWorldData: ShellWorldData) -> void:
	print("Shell: regenerate_mesh")
	up.regenerate_mesh(shellWorldData)
	down.regenerate_mesh(shellWorldData)
	left.regenerate_mesh(shellWorldData)
	right.regenerate_mesh(shellWorldData)
	forward.regenerate_mesh(shellWorldData)
	back.regenerate_mesh(shellWorldData)
