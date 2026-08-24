shader_type canvas_item;
uniform sampler2D noise: repeat_enable;
uniform sampler2D noisesub: repeat_enable;
uniform float speed: hint_range(0.0, 100.0, 1.0);
uniform float opacity: hint_range(0.0, 1.0, 0.01);
uniform float detail: hint_range(0.0, 1.5, 0.01);
uniform float speedsub: hint_range(0.0, 100.0, 1.0);
uniform float opacitysub: hint_range(0.0, 1.0, 0.01);
uniform float detailsub: hint_range(0.0, 1.0, 0.01);
void fragment() {
	float t = TIME/1000.0 * speed;
	float tsub = TIME/1000.0 * speedsub;
	vec2 texture_size=vec2(textureSize(TEXTURE,0));
	vec2 texture_coords= UV * texture_size;
	vec2 rounded_coords= floor(texture_coords);
	vec2 proper_texture= rounded_coords / texture_size;
	vec4 noise_color = texture (noise,proper_texture+t);
	vec4 noise_color_sub = texture (noisesub,proper_texture-tsub)*opacitysub;

	if (COLOR.b>0.4)
		{
		COLOR.rgb += COLOR.g * smoothstep((1.0-detail+detailsub),1.0,(noise_color-noise_color_sub).r)*opacity;
		COLOR.rgb += COLOR.b * smoothstep((1.0-detail+detailsub),1.0,(noise_color-noise_color_sub).r)*opacity/4.0;
		}
	// Called for every pixel the material is visible on.
}
