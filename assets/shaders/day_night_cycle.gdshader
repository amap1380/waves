shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;


uniform vec4 blend_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // RGB color; A used as extra multiplier
uniform float strength : hint_range(0.0, 1.0) = 1.0;              // 0 = no effect, 1 = full multiply

void fragment() {
    // Sample the already-rendered screen at this fragment
    vec2 uv = SCREEN_UV;
    vec4 screen_col = texture(SCREEN_TEXTURE, uv);

    // Multiply blend (screen * color)
    vec3 multiplied = screen_col.rgb * blend_color.rgb;

    // Combine original and multiplied result by strength.
    // Use blend_color.a as an additional multiplier if you want
    // the color's alpha to reduce the effect.
    float effective = strength * blend_color.a;
    vec3 out_rgb = mix(screen_col.rgb, multiplied, effective);

    // Preserve the original screen alpha
    COLOR = vec4(out_rgb, screen_col.a);
}