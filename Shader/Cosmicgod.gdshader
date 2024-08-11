shader_type spatial;
uniform sampler2D texturinha;
uniform float offsetx;
uniform float offsety;
uniform sampler2D noise: repeat_enable;
uniform float speed;
uniform float intensamente= 0.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec4 noisu= texture(noise,UV-TIME/(1.0+speed));
	vec2 uve= vec2((SCREEN_UV.x+offsetx),(SCREEN_UV.y+offsety));
	//uve= vec2(SCREEN_UV.x,SCREEN_UV.y);
	vec4 textu=texture(texturinha,uve);
	ALBEDO.r=clamp(textu.r*noisu.r*intensamente,0.f,1.f);
	ALBEDO.g=clamp(textu.r*noisu.r*intensamente,0.f,1.f);
	ALBEDO.b=clamp(textu.r*noisu.r*intensamente,0.f,1.f);
	//ALBEDO.rgb=textu.rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
