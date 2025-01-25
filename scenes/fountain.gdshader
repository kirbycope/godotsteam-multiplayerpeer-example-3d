shader_type spatial;

uniform sampler2D water_texture; // The texture to scroll
uniform float scroll_speed = 1.0; // How fast the texture scrolls

void fragment() {
    // Get UV and add scrolling offset
    vec2 uv = UV;
    uv.y += TIME * scroll_speed;
    
    // Sample texture with scrolled UV
    vec4 tex = texture(water_texture, uv);
    
    // Apply to shader
    ALBEDO = tex.rgb;
    ALPHA = 0.5; // 50% transparency
}