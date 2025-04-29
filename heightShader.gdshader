shader_type spatial;

uniform float min_height;
uniform float max_height;
uniform sampler2D height_color;

varying float height;

void fragment() {
	float t = (height - min_height) / (max_height - min_height);
	
	//if (UV.y<0.0) {
		//ALBEDO = vec3(1.0, 0.0, 0.0);  // low
	//} else if (UV.y > 1.0) {
		//ALBEDO = vec3(0.0, 1.0, 0.0);  // high
	//} else {
		// Sample from the exact center of each biome row and clamp the coordinates
		vec2 uv = vec2(0.5, clamp(UV.y, 0.0, 1.0));
		vec4 tex_color = texture(height_color, vec2(t, 0.0));
		ALBEDO = tex_color.rgb;
	//}
	//// Sample from the exact center of each biome row and clamp the coordinates
	//vec2 uv = vec2(0.5, clamp(UV.y, 0.0, 1.0));
	//vec4 tex_color = texture(height_color, uv);
	//
	//// Debug: Show biome index as color
	//if (UV.y < 0.33) {
		////ALBEDO = vec3(1.0, 0.0, 0.0);  // Red for biome 0
	//} else if (UV.y < 0.66) {
		////ALBEDO = vec3(0.0, 1.0, 0.0);  // Green for biome 1
	//} else {
		////ALBEDO = vec3(0.0, 0.0, 1.0);  // Blue for biome 2
	//}
	//
	//ALBEDO = tex_color.rgb;
	////ALBEDO = texture(height_color, vec2(t, 1)).rgb;
}

void vertex() {
	// Calculate height from vertex position
	height = length(VERTEX);
}
