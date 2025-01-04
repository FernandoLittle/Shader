shader_type spatial;
uniform float metal;
uniform sampler2D noise: repeat_enable;
uniform float speed=1.0;
uniform float intensamente= 0.0;

void fragment() {
//	vec4 text=texture(TEXTURE,UV);
	vec4 noisu= texture(noise,UV-TIME/(1.0+speed));
	ALBEDO=noisu.rgb;
	METALLIC=metal;
	ALPHA=-noisu.r*noisu.g*noisu.b;
	//COLOR.a=clamp(text.r*noisu.r*intensamente,0.f,1.f);
	//COLOR.a=pow(COLOR.a,2);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
