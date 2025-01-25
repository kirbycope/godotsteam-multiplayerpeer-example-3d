shader_type spatial;

uniform sampler2D water_texture; // Base water texture
uniform sampler2D screen_texture : hint_screen_texture; // Screen texture
uniform float speed = 1.0; // Wave speed
uniform float wave_strength = 0.1; // Wave height
uniform vec2 wave_scale = vec2(4.0, 4.0); // Wave density
uniform float shininess = 64.0; // Shiny reflection intensity
uniform vec3 light_direction = vec3(-0.5, 1.0, -0.5); // Direction of the "sunlight"
uniform float transparency = 0.5; // Base transparency (0 = opaque, 1 = fully transparent)
uniform float refraction_strength = 0.05; // Refraction distortion strength
uniform float min_opacity = 0.3; // Minimum opacity value (prevents complete transparency)
uniform float ambient_light = 0.2; // Ambient light intensity

void fragment() {
    vec2 uv = UV;

    // Time-based wave animation using the TIME variable
    float wave = sin(uv.x * wave_scale.x + TIME * speed) * cos(uv.y * wave_scale.y + TIME * speed);
    vec3 wave_normal = normalize(vec3(wave * wave_strength, wave * wave_strength, 1.0));

    // Adjust UVs for texture sampling (distorted by waves)
    vec2 distorted_uv = uv + wave_normal.xy * wave_strength;

    // Sample the water texture
    vec4 tex_color = texture(water_texture, distorted_uv);

    // Refraction effect: use SCREEN_UV for screen texture sampling
    vec2 refracted_uv = SCREEN_UV + wave_normal.xy * refraction_strength;
    refracted_uv = clamp(refracted_uv, vec2(0.0), vec2(1.0));

    vec4 background_color = texture(screen_texture, refracted_uv);

    // Lighting calculations
    vec3 normal = normalize(NORMAL + wave_normal * wave_strength);
    vec3 light_dir = normalize(light_direction);
    vec3 view_dir = normalize(VIEW);

    // Calculate Fresnel effect
    float fresnel = pow(1.0 - clamp(dot(normal, view_dir), 0.0, 1.0), 5.0);

    // Limit the transparency based on view angle
    float view_transparency = clamp(transparency + fresnel * 0.5, min_opacity, 1.0);

    // Improved diffuse lighting
    float diffuse = max(dot(normal, light_dir), 0.0) * (1.0 - fresnel * 0.5);

    // Improved specular calculation using Blinn-Phong
    vec3 half_dir = normalize(light_dir + view_dir);
    float spec_angle = max(dot(normal, half_dir), 0.0);
    float specular = pow(spec_angle, shininess) * 0.3; // Reduced specular intensity

    // Combine water texture and refraction with improved lighting
    vec4 water_color = mix(tex_color, background_color, view_transparency);

    // Final output with ambient light
    ALBEDO = water_color.rgb * (diffuse + ambient_light);
    SPECULAR = specular;
    METALLIC = 0.0;
    ROUGHNESS = 1.0 - (specular * 0.5);
    ALPHA = 1.0 - view_transparency;
}