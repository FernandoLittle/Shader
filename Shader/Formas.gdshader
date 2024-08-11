shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 st = UV;
 float position1 = -0.0;
    float position2 = -0.0;
    float rotation = -0.0;
	st.x+=-position1;
    st.y+=position2;
  vec3 color = vec3(0.0);
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
  int N = 4;

  // Angle and radius from the current pixel
  float a = atan(st.x+chaos1,st.y+chaos2)+PI+rotation;
  float r = chaos4+6.28/float(N);

  // Shaping function that modulate the distance
  d = cos(floor(chaos3+0.5+a/r)*r-a)*length(st+vec2(chaos5,chaos6));

  color = vec3(1.0-smoothstep(.4,.41,d));
  // color = vec3(d);


  COLOR = vec4(color,1.0);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
