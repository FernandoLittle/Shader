shader_type canvas_item;
uniform vec2 position1[50];
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 cor1=vec3(0.5,0.5,0.9);
	vec2 st=UV;
	 float color = 0.0 ;
	 vec2 point[5];
	float power[5];
	int IdStar=0;
	int NewStar=0;
	

	power[0]=3.8;
	power[1]=1.4;
	power[2]=1.5;
	power[3]=3.6;
	power[4]=1.2;
	
	
	
	
	float m_dist = 1.;  // minimum distance

    // Iterate through the points positions
    for (int i = 0; i < 50; i++) {
        float dist = distance(st, position1[i]);
		
		
		
		NewStar=int(step(dist,m_dist));
		IdStar=max(IdStar,NewStar*i);
        // Keep the closer distance
        m_dist = min(m_dist, dist);
		
		
		
		
	// Called for every pixel the material is visible on.
	}
	color= (1.3+0.02*float(IdStar))*m_dist*25.0+(abs(sin(TIME))*0.1);
	
	
	color=0.2/color;
	color*= smoothstep(0.2,.8, color);
	cor1=cor1*color;
	
	
	COLOR=vec4(cor1,1.0);

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
