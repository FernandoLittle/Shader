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
	ALBEDO.r-=(red*(1.0-ALBEDO.b))*(1.0-ALBEDO.g);
	ALBEDO.b-=(blue*(1.0-ALBEDO.r))*(1.0-ALBEDO.g);
	ALBEDO.g-=(green*(1.0-ALBEDO.b))*(1.0-ALBEDO.r);
	ALBEDO.r =ALBEDO.b+ALBEDO.g+ALBEDO.r*10.0;
	ALBEDO.g =ALBEDO.b+ALBEDO.g+ALBEDO.r;
	ALBEDO.b =ALBEDO.b+ALBEDO.g+ALBEDO.r;
	METALLIC=metal;
	ROUGHNESS=roug;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
