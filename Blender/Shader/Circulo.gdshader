shader_type spatial;
uniform float BarreiraA;
uniform float BarreiraB;
uniform sampler2D textura;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float MultiplicadorA=0.0;
	float MultiplicadorB=0.0;
	vec2 uv=  (UV-0.5)*2.0;
	
	vec4 result = texture(textura,UV);

	MultiplicadorA=step(uv.y,BarreiraA);
	MultiplicadorB=step(uv.y,BarreiraB);
	MultiplicadorB=1.0-MultiplicadorB;

	if(uv.x>0.0)
	{
		result*=MultiplicadorA;
	}
	else{
		result*=MultiplicadorB;
	}

	//result.r=uv.y;
	//COLOR=vec4(result.r,result.b,result.g,result.a);
	ALBEDO=vec3(result.r,result.b,result.g);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
