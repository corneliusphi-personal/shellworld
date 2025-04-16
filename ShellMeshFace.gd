@tool
extends MeshInstance3D

class_name ShellMeshFace

@export var normal : Vector3
var noiseFilter : NoiseFilter

func _init(_normal : Vector3, _noiseFilter : NoiseFilter) -> void:
	normal = _normal
	noiseFilter = _noiseFilter

func regenerate_mesh(shellWorldData : ShellWorldData):
	print("ShellMeshFace: regenerate_mesh")
	if shellWorldData == null:
		print("ShellMeshFace: ERROR - shellWorldData is null")
		return
	var resolution = int(shellWorldData.globalResolution * shellWorldData.radius)
	var axisA = Vector3(normal.z, normal.x, normal.y)
	var axisB = normal.cross(axisA)
	
	# each vertex on the face
	var vertex_array := PackedVector3Array()
	var elevation_array := PackedFloat32Array()
	# flattened tripples of each triangle on the face
	var triangles := PackedInt32Array()
	var normal_array := PackedVector3Array()
	var uv_array := PackedVector2Array()
	
	var num_vertices = resolution * resolution
	var num_triangle_indices = (resolution - 1) * (resolution - 1) * 6
	
	vertex_array.resize(num_vertices)
	elevation_array.resize(num_vertices)
	uv_array.resize(num_vertices)
	normal_array.resize(num_vertices)
	triangles.resize(num_triangle_indices)
	
	var i : int = 0
	
	# generate sphere points
	for y in range(resolution):
		for x in range(resolution):
			# Calculate vertex position
			var percent = Vector2(x, y) / (resolution - 1)
			var axisAOffset = (percent.x - 0.5) * 2.0 * axisA
			var axisBOffset = (percent.y - 0.5) * 2.0 * axisB
			var pointOnUnitCube = normal + axisAOffset + axisBOffset
			var pointOnUnitSphere = pointOnUnitCube.normalized() * shellWorldData.radius
			var result = noiseFilter.evaluate(pointOnUnitSphere, shellWorldData)
			var pointWithElevation = result[0]
			var elevation = result[1]
			vertex_array[i] = pointWithElevation
			elevation_array[i] = elevation
			normal_array[i] = normal
			uv_array[i] = percent
						
			i += 1
	print("ShellMeshFace: vertex count", i)
	
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
	print("ShellMeshFace: triindex", tri_index)
	
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_INDEX] = triangles
	var _mesh := ArrayMesh.new()
	_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	self.mesh = _mesh
