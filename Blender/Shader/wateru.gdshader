shader_type spatial;
uniform vec3 corzinha: source_color;
uniform vec3 corzinha2: source_color;
uniform float metal: hint_range(0.0, 1.0, 0.01);
uniform float roug: hint_range(0.0, 1.0, 0.01);
uniform sampler2D normalTexture1;
uniform sampler2D normalTexture2;
uniform vec2 wave1= vec2(0.1,0.3);
uniform vec2 wave2= vec2(0.3,0.1);
uniform float timescale: hint_range(0.0, 1.0, 0.01);
float fresnel(float amount, vec3 norm, vec3 view)
	{
		return pow((1.0-clamp(dot(normalize(norm),normalize(view)),0.0,1.0)),amount);
	}
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float fresn = fresnel(5.0,NORMAL,VIEW);
	vec3 surfacecolor=mix(corzinha,corzinha2,fresn);
	
	vec2 time=(TIME*wave1)*timescale;
	vec2 time2=(TIME*wave2)*timescale;
	ALBEDO= surfacecolor;
	METALLIC=metal;
	ROUGHNESS=roug;

	vec3 normal =texture(normalTexture1,UV + time).rgb;
	vec3 normal2 =texture(normalTexture2,UV + time2).rgb;
	vec3 normalblend= mix(normal,normal2,0.5);
	NORMAL_MAP=normalblend;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
