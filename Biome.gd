@tool
extends Resource

class_name Biome

static func generateBiomeTexture(shellWorldData: ShellWorldData) -> ImageTexture:
	var imageTexture : ImageTexture
	
	var height = shellWorldData.biomes.size()
	if (height > 0):
		var width = shellWorldData.biomes[0].gradient.width
		var data : PackedByteArray
		
		for biome in shellWorldData.biomes:
			var biomeData = biome.gradient.get_image().get_data()
			data.append_array(biomeData)
		
		var newImage = Image.create_from_data(width, height, false, Image.FORMAT_RGBA8, data)
		newImage.clear_mipmaps()
		imageTexture = ImageTexture.create_from_image(newImage)
		imageTexture.resource_name = "Biome Texture"
	return imageTexture

static func biome_percent_from_point(pointOnUnitSphere: Vector3, shellWorldData: ShellWorldData) -> float:
	var distanceFromEquator = abs(pointOnUnitSphere.y)
	var noise = shellWorldData.biomeNoise.get_noise_3dv(pointOnUnitSphere)
	distanceFromEquator += noise * shellWorldData.biomeAmplitude
	
	if (shellWorldData.biomes.size() <= 1):
		return 0.0
	
	# Find the highest biome whose startHeight is less than or equal to distanceFromEquator
	var biomeIndex : float = 0.0
	for i in range(shellWorldData.biomes.size()):
		if shellWorldData.biomes[i].startHeight <= distanceFromEquator:
			biomeIndex = i
		else:
			break
			
	return biomeIndex/(shellWorldData.biomes.size() - 1)
	# Explicitly map distances to biome indices
	#if distanceFromEquator < 0.125:  # Near equator
		#return 0.0  # Biome 0 (blue)
	#elif distanceFromEquator < 0.375:  # Mid-latitudes
		#return 0.5  # Biome 1 (red)
	#else:  # Near poles
		#return 1.0  # Biome 2 (green)
	
