shader_type canvas_item;
uniform sampler2D mist_texture: repeat_enable, filter_nearest;
uniform float speed_x: hint_range(-0.1, 0.1, 0.005);
uniform float speed_y: hint_range(-0.1, 0.1, 0.005);

void fragment() {
	vec2 speed = vec2(speed_x,speed_y);
	vec2 uv=UV+speed*TIME;
	
	float mist = texture(mist_texture,uv).a;
	COLOR.a *= mist*2.0-0.2;
	// Called for every pixel the material is visible on.
}
