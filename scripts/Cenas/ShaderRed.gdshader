shader_type spatial;
uniform float red;
uniform float green;
uniform float blue;
uniform sampler2D texturinha;
uniform float offsetx;
uniform float offsety;
uniform float scale;
uniform float metal:hint_range(0.0, 1.0, 0.1);
uniform float roug: hint_range(0.0, 1.0, 0.1);




void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uve= vec2((UV.x+offsetx)*scale,(UV.y+offsety)*scale);
	//SÓ O OUROvec2 uve= vec2(SCREEN_UV.x+offsetx,SCREEN_UV.y+offsety);
	vec4 textu=texture(texturinha,uve);
	ALBEDO.rgb=textu.rgb;
	ALBEDO.r-=red;
	ALBEDO.b-=blue;
	ALBEDO.g-=green;
	ALBEDO.r+=sin(TIME)*1.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
