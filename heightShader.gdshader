shader_type spatial;

uniform float min_height;
uniform float max_height;
uniform sampler2D height_color;

varying float height;

void fragment() {
	// Scale down the height values to a more reasonable range
	//float scaled_height = height * 0.1; // Scale down by a factor of 10
	float t = (height - min_height) / (max_height - min_height);

	// Debug: Show the height value directly
	//ALBEDO = vec3(t);

	// Uncomment this line to use the color gradient
	vec3 color = texture(height_color, vec2(t, 0.0)).rgb;
	ALBEDO = color;
}

void vertex() {
	// Calculate height from vertex position
	height = length(VERTEX);
}
