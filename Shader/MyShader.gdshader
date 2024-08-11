shader_type canvas_item;
void vertex() {
	// Called for every vertex the material is visible on.
}
vec3 Cores(float lyoko)
{
	vec3 cor1=vec3(0.5,0.5,0.5);
	vec3 cor2=vec3(0.5,0.5,0.5);
	vec3 cor3=vec3(1.0,1.0,1.0);
	vec3 cor4=vec3(0.0,0.2,0.6);
	return cor1+ cor2*cos(6.2*(cor3*lyoko+cor4));
}
void fragment() {
	float code=1.3+sin(TIME/8.0);
	vec3 UltraColor=vec3(0.0,0.0,0.0);
	
	vec2 uv=  (UV-0.5)*2.0;
	
	vec2 my_uv = uv;
	
	for(float i = 0.0;  i<3.0;  i++)
	{
		
	uv=fract(uv*code)-0.5;
	//uv=uv*2.0;
	//uv=fract(uv);
	//uv=uv-0.5;

	float cor= length(uv);
	vec3 paleta= Cores(length(my_uv)+(TIME+i)*0.4);
	
	
	cor=sin(cor*8.0 +TIME)/8.0;
	
	cor=abs(cor);
	cor= 0.02/cor;
	
	UltraColor+=paleta*cor;
		
		
		
		
	}
	
	
	
	
	
	COLOR=vec4(UltraColor,1.0); 
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
