shader_type canvas_item;
void vertex() {
	// Called for every vertex the material is visible on.
}
float quadrado(vec2 uvp, float tamanho)
{
	float corq=0.0;
	corq=abs(uvp.x)+abs(uvp.y)-tamanho;
	corq=abs(corq);
	corq=0.1/corq;
	return corq;
}
float circulo(vec2 uvp,float tamanho)
{
	
	float corc=0.0;
	corc=length(uvp)-tamanho;
	corc=abs(corc);
	corc=0.1/corc;
	//corq=abs(uvp.x)+abs(uvp.y)-0.5;
	//corq=abs(corq);
	//corq=0.1/corq;
	return corc;
}
void fragment() 
{
	vec3 extracolor= vec3(2.0,0.5,0.5);
	vec2 uv=(UV-0.5)*2.0;
	float cor_final=0.0;
	float times=0.0;
	for(float i = 0.0;  i<10.0;  i++)
	{
	times+=1.0;
	int circulotime=int(i)%2;
	int quadradotime=int(i+1.)%2;
	float cor=0.0;
	cor+=quadrado(uv,0.9*fract(TIME/4.0-i*0.1)*2.0)*float(quadradotime);
	cor+=circulo(uv,0.9*fract(TIME/4.3-i*0.1)*2.0)*float(circulotime);
	//float cor2=circulo(uv,0.6);
	//float cor3=quadrado(uv,0.9);
	//float cor4=circulo(uv,0.35);
	//cor=step(0.5,cor);
	cor_final+=cor;
	//cor_final=cor_final/2.;
	}
	cor_final=cor_final/(20.0+times);
	extracolor= extracolor*cor_final;
	COLOR=vec4(extracolor,1.);
	

		
		

	
	
	
	
	

	// Called for every pixel the material is visible on.
}