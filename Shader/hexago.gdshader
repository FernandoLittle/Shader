shader_type canvas_item;
uniform vec2 resol= vec2(600.0,400.0);
const float x_shift = sin(PI / 3.0);
float hex(vec2 pi){
	pi.x = pi.x/x_shift;
	pi.y+=floor(pi.x)*0.5;
	pi=abs(fract(pi)-0.5);
	return step(0.05,abs(1.0-max(pi.y+pi.x*1.5,pi.y*2.0)));
}

void fragment() {
	
	vec2 uv=UV-0.5;
	uv.x*=resol.x/resol.y;
	uv=uv*5.0;
	vec3 color = vec3(0.0);
	color+=vec3(hex(uv));
	COLOR=vec4(color,1.0); 
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
