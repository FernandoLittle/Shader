shader_type canvas_item;
uniform float red;
uniform float green;
uniform float blue;
uniform sampler2D texturinha;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 textu =texture(texturinha,UV);
	COLOR.rgba=texture(texturinha,UV);
	COLOR.r-=(red*(1.0-COLOR.b))*(1.0-COLOR.g);
	COLOR.b-=(blue*(1.0-COLOR.r))*(1.0-COLOR.g);
	COLOR.g-=(green*(1.0-COLOR.b))*(1.0-COLOR.r);
	COLOR.r =COLOR.b+COLOR.g+COLOR.r*10.0;
	COLOR.g =COLOR.b+COLOR.g+COLOR.r;
	COLOR.b =COLOR.b+COLOR.g+COLOR.r;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
