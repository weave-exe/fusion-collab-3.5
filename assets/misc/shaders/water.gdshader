shader_type canvas_item;
uniform sampler2D noise: repeat_enable;
uniform sampler2D noisesub: repeat_enable;
uniform sampler2D noisedeep: repeat_enable;
uniform float speed: hint_range(0.0, 100.0, 1.0);
uniform float opacity: hint_range(0.0, 1.0, 0.01);
uniform float detail: hint_range(0.0, 1.5, 0.01);
uniform float speedsub: hint_range(0.0, 100.0, 1.0);
uniform float opacitysub: hint_range(0.0, 1.0, 0.01);
uniform float detailsub: hint_range(0.0, 1.0, 0.01);
uniform float speeddeep: hint_range(0.0, 100.0, 1.0);
uniform float opacitydeep: hint_range(0.0, 1.0, 0.01);
uniform float detaildeep: hint_range(0.0, 1.0, 0.01);
void fragment() {
	float t = TIME/1000.0 * speed;
	float tsub = TIME/1000.0 * speedsub;
	float tdeep = TIME/1000.0 * speeddeep;
	vec2 texture_size=vec2(textureSize(TEXTURE,0));
	vec2 texture_coords= UV * texture_size;
	vec2 rounded_coords= floor(texture_coords);
	vec2 proper_texture= rounded_coords / texture_size;
	vec4 noise_color = texture (noise,proper_texture+t);
	vec4 noise_color_sub = texture (noisesub,proper_texture-tsub)*opacitysub;
	vec4 noise_color_deep = texture (noisedeep,proper_texture-tdeep)*opacitydeep*2.0;

	if (COLOR.b>0.2)
		{
		COLOR.rgb += COLOR.g * step((1.3-detail+detailsub),(noise_color-noise_color_sub-(noise_color_deep*0.5)).r)*opacity*0.4;
		COLOR.rgb += COLOR.g * step((1.6-detail+detailsub),(noise_color-noise_color_sub).r)*opacity*0.5;
		COLOR.rgb -= COLOR.rgb * smoothstep((1.0-detail+detaildeep),1.0,(noise_color_deep).r)*opacitydeep;
		}
	// Called for every pixel the material is visible on.
}
