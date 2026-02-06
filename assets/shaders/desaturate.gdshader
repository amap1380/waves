shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 col = texture(TEXTURE, UV);

	// Luminance (true grayscale)
	float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

	// Mix grayscale with original color
	col.rgb = mix(vec3(gray), col.rgb, saturation);

	COLOR = col;
}
