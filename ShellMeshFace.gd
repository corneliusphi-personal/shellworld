@tool
extends MeshInstance3D

class_name ShellMeshFace

@export var normal : Vector3
var noiseFilter : NoiseFilter
var material: ShaderMaterial
var shellData: ShellData

func _init(_normal : Vector3, _noiseFilter : NoiseFilter, _material: ShaderMaterial, _shellData: ShellData) -> void:
	normal = _normal
	noiseFilter = _noiseFilter
	material = _material
	shellData = _shellData

func regenerate_mesh(shellWorldData : ShellWorldData, shellNum : int):
	print("ShellMeshFace: regenerate_mesh")
	if shellWorldData == null:
		print("ShellMeshFace: ERROR - shellWorldData is null")
		return
	var radius = shellWorldData.radius * shellNum
	var resolution = int(shellWorldData.globalResolution * radius)
	var axisA = Vector3(normal.z, normal.x, normal.y)
	var axisB = normal.cross(axisA)
	
	# each vertex on the face
	var vertex_array := PackedVector3Array()
	var elevation_array := PackedFloat32Array()
	# flattened tripples of each triangle on the face
	var triangles := PackedInt32Array()
	var normal_array := PackedVector3Array()
	var uv_array := PackedVector2Array()
	
	var num_vertices = resolution * resolution * 2
	var num_triangle_indices = (resolution - 1) * (resolution - 1) * 6 * 2
	
	vertex_array.resize(num_vertices)
	elevation_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	normal_array.resize(num_vertices)
	triangles.resize(num_triangle_indices)
	
	var i : int = 0
	var j : int = resolution * resolution
	
	# generate sphere points
	for y in range(resolution):
		for x in range(resolution):
			# Calculate vertex position
			var percent = Vector2(x, y) / (resolution - 1)
			var axisAOffset = (percent.x - 0.5) * 2.0 * axisA
			var axisBOffset = (percent.y - 0.5) * 2.0 * axisB
			var pointOnUnitCube = normal + axisAOffset + axisBOffset
			var pointOnUnitSphere = pointOnUnitCube.normalized() * radius
			var result = noiseFilter.evaluate(pointOnUnitSphere, shellWorldData)
			var pointWithElevation = result[0]
			var pointBelowElevation = result[1]
			var elevation = result[2]
			var height = pointWithElevation.length()
			if height > shellData.maxHeight:
				shellData.maxHeight = height
			var depth = pointBelowElevation.length()
			if depth < shellData.minHeight:
				shellData.minHeight = depth
			vertex_array[i] = pointWithElevation
			vertex_array[j] = pointBelowElevation
			elevation_array[i] = elevation
			elevation_array[j] = -elevation
			normal_array[i] = normal
			normal_array[j] = -normal
			uv_array[i] = percent
			uv_array[j] = percent
						
			i += 1
			j += 1
	
	var tri_index : int = 0
	# generate triangles
	for y in range(resolution - 1):
		for x in range(resolution - 1):
			var base_index = y * resolution + x
			if (elevation_array[base_index] > 0 or elevation_array[base_index + resolution] > 0 or elevation_array[base_index + 1] > 0 or !shellWorldData.removeZeroTriangles):
				triangles[tri_index] = base_index
				triangles[tri_index + 1] = base_index + resolution
				triangles[tri_index + 2] = base_index + 1
				tri_index += 3
			if (elevation_array[base_index] > 0 or elevation_array[base_index + resolution] > 0 or elevation_array[base_index + 1] > 0 or !shellWorldData.removeZeroTriangles):
				triangles[tri_index] = base_index + 1
				triangles[tri_index + 1] = base_index + resolution
				triangles[tri_index + 2] = base_index + resolution + 1
				tri_index += 3
			var bottom_base_index = y * resolution + x + resolution * resolution
			if (elevation_array[bottom_base_index] < 0 or elevation_array[bottom_base_index + resolution] < 0 or elevation_array[bottom_base_index + 1] < 0 or !shellWorldData.removeZeroTriangles):
				triangles[tri_index] = bottom_base_index
				triangles[tri_index + 1] = bottom_base_index + 1
				triangles[tri_index + 2] = bottom_base_index + resolution
				tri_index += 3
			if (elevation_array[bottom_base_index] < 0 or elevation_array[bottom_base_index + resolution] < 0 or elevation_array[bottom_base_index + 1] < 0 or !shellWorldData.removeZeroTriangles):
				triangles[tri_index] = bottom_base_index + 1
				triangles[tri_index + 1] = bottom_base_index + resolution + 1
				triangles[tri_index + 2] = bottom_base_index + resolution
				tri_index += 3

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_INDEX] = triangles
	#call_deferred("_update_mesh", arrays, shellWorldData)
	
	#func _update_mesh(arrays: Array, shellWorldData: ShellWOrldData):
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	_mesh.surface_set_material(0, material)
	self.mesh = _mesh
	self.material.set_shader_parameter("min_height", shellData.minHeight)
	self.material.set_shader_parameter("max_height", shellData.maxHeight)
	self.material.set_shader_parameter("height_color", shellWorldData.heightColor)
