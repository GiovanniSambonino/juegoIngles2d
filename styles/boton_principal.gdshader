shader_type canvas_item;

uniform vec4 normal_color : source_color = vec4(1.1, 0, 0, 0);
uniform vec4 hover_color : source_color = vec4(1.1, 0, 0, 0);

void fragment() {
	
    vec4 tex_color = texture(TEXTURE, FRAGCOORD.xy / TEXTURE_PIXEL_SIZE);
    if (SCREEN_UV.x < 0.0) {
        COLOR = tex_color * hover_color;
    } else {
        COLOR = tex_color * normal_color;
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
