@tool
extends Resource

class_name ShellWorldData

@export_range(1, 10, 1) var globalResolution : int = 1:
		set(value):
				globalResolution = value
				emit_changed()
