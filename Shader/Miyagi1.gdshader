shader_type canvas_item;

vec3 Cores(float lyoko)
{
	vec3 cor1=vec3(0.5,0.5,0.5);
	vec3 cor2=vec3(0.5,0.5,0.5);
	vec3 cor3=vec3(1.0,1.0,1.0);
	vec3 cor4=vec3(0.0,0.2,0.6);
	return cor1+ cor2*cos(6.2*(cor3*lyoko+cor4));
}
vec3 Figurinhas(vec2 uv)
{
		vec3 paleta=vec3(1.,1.,1.);
		vec2 st = uv;
		vec2 st1 = uv;
	 float position1 = -0.0;
	    float position2 = -0.;
	    float rotation = -0.0;
		st.x+=-position1;
	    st.y+=position2;
		
	  vec3 color = vec3(0.0);
	  float d = 0.0;

	  // Remap the space to -1. to 1.
	  st = st *2.-1.;
	  st1 = st1 *2.-1.;
		st*=2.0;
		st=fract(st);
		
		st-=0.5;
	  float chaos1 = 0.0;
	    float chaos2 = 0.0;
	    float chaos3 = 0.0;
	    float chaos4 = 0.0;
	     float chaos5 = 0.0;
	    float chaos6 = 0.0;
	  // Number of sides of your shape
	  int N = 8;
	  N+=int(floor(st1.x*2.0));
	N+=int(floor(st1.y*2.0));
	rotation+=TIME*(floor(st1.y*2.0));
	rotation+=TIME*(floor(st1.x*2.0));
	
	 paleta= Cores(length(st)+(TIME*0.3)+st1.x+st1.y);
	  // Angle and radius from the current pixel
	  float a = atan(st.x+chaos1,st.y+chaos2)+PI+rotation;
	  float r = chaos4+6.28/float(N);

	  // Shaping function that modulate the distance
	  d = cos(floor(chaos3+0.5+a/r)*r-a)*length(st+vec2(chaos5,chaos6));

	  color = vec3(smoothstep(.2,.41,d))-0.5;
	  // color = vec3(d);
		color=abs(color);
	color=0.2/color;
	color*=paleta;
	return color;
}
//
void fragment() {	
	vec3 color= vec3(0.,0.,0.);
	vec3 color1= vec3(0.,0.,0.);
	vec2 st = UV;
 float position1 = -0.0;
    float position2 = -0.;
    float rotation = -0.0;
	rotation+=TIME;
	st.x+=-position1;
    st.y+=position2;
  float d = 0.0;

  // Remap the space to -1. to 1.
  st = st *2.-1.;
  float chaos1 = 0.0;
    float chaos2 = 0.0;
    float chaos3 = 0.0;
    float chaos4 = 0.0;
     float chaos5 = 0.0;
    float chaos6 = 0.0;
  // Number of sides of your shape
  int N = 5;

  // Angle and radius from the current pixel
  float a = atan(st.x+chaos1,st.y+chaos2)+PI+rotation;
  float r = chaos4+6.28/float(N);

  // Shaping function that modulate the distance
  d = cos(floor(chaos3+0.5+a/r)*r-a)*length(st+vec2(chaos5,chaos6));

  color = vec3(1.0-smoothstep(.3,.41,d));
	color=1.0-color;
	color-=1.;
	color=abs(color);
	color=(3.10+abs(sin(TIME)*10.))/color;
	
	color1+= Figurinhas(UV);
	color1*=(color);
	color1=1.0-color1;
	COLOR = vec4(color1,1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
