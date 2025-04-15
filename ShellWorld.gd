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

var shell : Shell


func _ready() -> void:
	print("ShellWorld: _ready called")
	on_data_changed()

func create_shell():
	if (shell != null):
		print("ShellWorld: freeing shell")
		shell.queue_free()
	print("ShellWorld: creating Shell")
	shell = Shell.new()
	add_child(shell)
	

func on_data_changed() -> void:
	print("ShellWorld: on_data_changed")
	create_shell()
	if (shellWorldData == null):
		print("ShellWorld: shellWorldData is null in on_data_changed")
		return
	if (shell == null):
		print("ShellWorld: shell is null on_data_changed")
		return
	shell.regenerate_mesh(shellWorldData)
	
