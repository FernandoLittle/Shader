shader_type canvas_item;

render_mode unshaded, blend_add;

uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5);
}
vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5);
}
vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5);
}
float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}
float param_rndi(float minimum, float maximum, float seed) {
	return floor(param_rnd(minimum, maximum + 1.0, seed));
}
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
const float p_o1141706338619_default_in1 = 0.000000000;
const float p_o1141706338619_default_in2 = 0.000000000;
const float p_o1141723115834_sides = 6.000000000;
const float p_o1141723115834_radius = 1.160000000;
const float p_o1141723115834_edge = 0.260000000;
const float p_o1141689561404_default_in1 = 0.000000000;
const float p_o1141689561404_default_in2 = 2.320000000;
const float p_o1141605675262_default_in1 = 0.000000000;
const float p_o1141605675262_default_in2 = 0.000000000;
const float p_o1141672784189_default_in1 = 0.090000000;
const float p_o1141672784189_default_in2 = 2.060000000;
const float p_o1141639229492_default_in1 = 0.560000000;
const float p_o1141639229492_default_in2 = 1.000000000;
const float p_o1141622452477_translate_x = 0.000000000;
const float p_o1141622452477_translate_y = 0.000000000;
const float p_o1141622452477_rotate = 0.000000000;
const float p_o1141622452477_scale_x = 1.000000000;
const float p_o1141622452477_scale_y = 1.000000000;
const float p_o1141588898047_default_in1 = 0.000000000;
const float p_o1141588898047_default_in2 = 0.000000000;
const float p_o1141572120832_offset = -0.280000000;
const float p_o1141555343618_sides = 6.000000000;
const float p_o1141555343618_radius = 0.340000000;
const float p_o1141555343618_edge = 0.160000000;
const float p_o1141538566403_default_in1 = 0.000000000;
const float p_o1141538566403_default_in2 = 0.000000000;
const float p_o1141521789188_sides = 4.000000000;
const float p_o1141521789188_radius = 0.190000000;
const float p_o1141521789188_edge = 0.190000000;
const float p_o1141505011763_offset = -0.605000000;
const float p_o1141488234685_sides = 6.000000000;
const float p_o1141488234685_radius = 0.820000000;
const float p_o1141488234685_edge = 0.130000000;
const float p_o1141437903109_default_in1 = 0.000000000;
const float p_o1141437903109_default_in2 = 0.000000000;
const float p_o1141404348477_cx = 0.000000000;
const float p_o1141404348477_cy = 0.000000000;
const float p_o1141421125682_default_in1 = 0.000000000;
const float p_o1141421125682_default_in2 = 0.000000000;
const float p_o1138921320531_default_in1 = 0.000000000;
const float p_o1138921320531_default_in2 = 2.000000000;
const float p_o1138954874961_default_in1 = 0.070000000;
const float p_o1138954874961_default_in2 = 0.010000000;
const float p_o1140280275131_curve_0_x = 0.000000000;
const float p_o1140280275131_curve_0_y = 0.000000000;
const float p_o1140280275131_curve_0_ls = 0.000000000;
const float p_o1140280275131_curve_0_rs = 1.000000000;
const float p_o1140280275131_curve_1_x = 1.000000000;
const float p_o1140280275131_curve_1_y = 1.000000000;
const float p_o1140280275131_curve_1_ls = 1.000000000;
const float p_o1140280275131_curve_1_rs = 0.000000000;
uniform sampler2D texture_1;
const float texture_1_size = 1024.000000000;
const float p_o1138904543323_sides = 6.000000000;
const float p_o1138904543323_radius = 1.000000000;
const float p_o1138904543323_edge = 0.000000000;
const float p_o1138787102814_default_in1 = 0.000000000;
const float p_o1138787102814_default_in2 = 0.000000000;
const float p_o1138837434563_cx = 0.000000000;
const float p_o1138837434563_cy = 0.000000000;
const float p_o1138820657346_default_in1 = 0.000000000;
const float p_o1138820657346_default_in2 = 0.000000000;
const float p_o1138753548535_default_in1 = 0.000000000;
const float p_o1138753548535_default_in2 = 2.000000000;
const float p_o1136220188788_default_in1 = 0.070000000;
const float p_o1136220188788_default_in2 = 0.010000000;
const float p_o1137545588985_curve_0_x = 0.000000000;
const float p_o1137545588985_curve_0_y = 0.000000000;
const float p_o1137545588985_curve_0_ls = 0.000000000;
const float p_o1137545588985_curve_0_rs = 1.000000000;
const float p_o1137545588985_curve_1_x = 1.000000000;
const float p_o1137545588985_curve_1_y = 1.000000000;
const float p_o1137545588985_curve_1_ls = 1.000000000;
const float p_o1137545588985_curve_1_rs = 0.000000000;
uniform sampler2D texture_2;
const float texture_2_size = 1024.000000000;
const float p_o1138803880026_sides = 6.000000000;
const float p_o1138803880026_radius = 1.000000000;
const float p_o1138803880026_edge = 0.000000000;
const float p_o1141471457468_default_in1 = 0.000000000;
const float p_o1141471457468_default_in2 = 0.000000000;
const float p_o1138770325740_default_in1 = 0.000000000;
const float p_o1138770325740_default_in2 = 0.000000000;
const float p_o1138719994102_translate_x = 0.000000000;
const float p_o1138719994102_translate_y = 0.000000000;
const float p_o1138719994102_rotate = 0.000000000;
const float p_o1138719994102_scale_x = 0.900000000;
const float p_o1138719994102_scale_y = 0.900000000;
const float p_o1138736771320_default_in1 = 0.000000000;
const float p_o1138736771320_default_in2 = 2.000000000;
const float p_o1136153079947_default_in1 = 0.060000000;
const float p_o1136153079947_default_in2 = 1.000000000;
const float p_o1136119525478_bevel = 0.130000000;
const float p_o1136119525478_base = 0.910000000;
const float p_o1136136302687_r = 0.010000000;
const float p_o1136136302687_ripples = 1.000000000;
const float p_o1136102748286_r = 0.400000000;
const float p_o1136102748286_cx = 0.000000000;
const float p_o1136102748286_cy = 0.000000000;
const float p_o1138703216874_translate_x = 0.000000000;
const float p_o1138703216874_translate_y = 0.000000000;
const float p_o1138703216874_rotate = 0.000000000;
const float p_o1138703216874_scale_x = 1.100000000;
const float p_o1138703216874_scale_y = 1.100000000;
const float p_o1141454680254_translate_x = 0.000000000;
const float p_o1141454680254_translate_y = 0.000000000;
const float p_o1141454680254_rotate = 0.000000000;
const float p_o1141454680254_scale_x = 0.720000000;
const float p_o1141454680254_scale_y = 0.720000000;
// #globals: math_19 (o1141706338619)
float pingpong(float a, float b)
{
  return (b != 0.0) ? abs(fract((a - b) / (b * 2.0)) * b * 2.0 - b) : 0.0;
}
// #globals: shape_6 (o1141723115834)
float shape_circle(vec2 uv, float sides, float size, float edge) {
	uv = 2.0*uv-1.0;
	edge = max(edge, 1.0e-8);
	float distance = length(uv);
	return clamp((1.0-distance/size)/edge, 0.0, 1.0);
}
float shape_polygon(vec2 uv, float sides, float size, float edge) {
	uv = 2.0*uv-1.0;
	edge = max(edge, 1.0e-8);
	float angle = atan(uv.x, uv.y)+3.14159265359;
	float slice = 6.28318530718/sides;
	return clamp((1.0-(cos(floor(0.5+angle/slice)*slice-angle)*length(uv))/size)/edge, 0.0, 1.0);
}
float shape_star(vec2 uv, float sides, float size, float edge) {
	uv = 2.0*uv-1.0;
	edge = max(edge, 1.0e-8);
	float angle = atan(uv.x, uv.y);
	float slice = 6.28318530718/sides;
	return clamp((1.0-(cos(floor(angle*sides/6.28318530718-0.5+2.0*step(fract(angle*sides/6.28318530718), 0.5))*slice-angle)*length(uv))/size)/edge, 0.0, 1.0);
}
float shape_curved_star(vec2 uv, float sides, float size, float edge) {
	uv = 2.0*uv-1.0;
	edge = max(edge, 1.0e-8);
	float angle = 2.0*(atan(uv.x, uv.y)+3.14159265359);
	float slice = 6.28318530718/sides;
	return clamp((1.0-cos(floor(0.5+0.5*angle/slice)*2.0*slice-angle)*length(uv)/size)/edge, 0.0, 1.0);
}
float shape_rays(vec2 uv, float sides, float size, float edge) {
	uv = 2.0*uv-1.0;
	edge = 0.5*max(edge, 1.0e-8)*size;
	float slice = 6.28318530718/sides;
	float angle = mod(atan(uv.x, uv.y)+3.14159265359, slice)/slice;
	return clamp(min((size-angle)/edge, angle/edge), 0.0, 1.0);
}
// #globals: invert_4 (o1141656006974)
// #globals: transform2_6 (o1141622452477)
vec2 transform2_clamp(vec2 uv) {
	return clamp(uv, vec2(0.0), vec2(1.0));
}
vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {
 	vec2 rv;
	uv -= translate;
	uv -= vec2(0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += vec2(0.5);
	return rv;	
}
// #globals: mirror_2 (o1141572120832)
vec2 uvmirror_h(vec2 uv, float offset, float flip_sides) {
	return vec2(flip_sides*max(0.0, (abs(uv.x-0.5)-0.5*offset))+0.5, uv.y);
}
vec2 uvmirror_v(vec2 uv, float offset, float flip_sides) {
	return vec2(uv.x, flip_sides*max(0.0, (abs(uv.y-0.5)-0.5*offset))+0.5);
}
// #globals: rotate_2 (o1141404348477)
vec2 rotate(vec2 uv, float rotate) {
 	vec2 rv;
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	return rv;	
}
// #globals: sdannularshape (o1136136302687)
float sdRipples(float d, float w, int r) {
	for (int i = 0; i < r; ++i) {
		d = abs(d)-w;
	}
	return d;
}
float o1140280275131_curve_curve_fct(float x) {
{
float dx = x - p_o1140280275131_curve_0_x;
float d = p_o1140280275131_curve_1_x - p_o1140280275131_curve_0_x;
float t = dx/d;
float omt = (1.0 - t);
float omt2 = omt * omt;
float omt3 = omt2 * omt;
float t2 = t * t;
float t3 = t2 * t;
d /= 3.0;
float y1 = p_o1140280275131_curve_0_y;
float yac = p_o1140280275131_curve_0_y + d*p_o1140280275131_curve_0_rs;
float ybc = p_o1140280275131_curve_1_y - d*p_o1140280275131_curve_1_ls;
float y2 = p_o1140280275131_curve_1_y;
return y1*omt3 + yac*omt2*t*3.0 + ybc*omt*t2*3.0 + y2*t3;
}
}
float o1137545588985_curve_curve_fct(float x) {
{
float dx = x - p_o1137545588985_curve_0_x;
float d = p_o1137545588985_curve_1_x - p_o1137545588985_curve_0_x;
float t = dx/d;
float omt = (1.0 - t);
float omt2 = omt * omt;
float omt3 = omt2 * omt;
float t2 = t * t;
float t3 = t2 * t;
d /= 3.0;
float y1 = p_o1137545588985_curve_0_y;
float yac = p_o1137545588985_curve_0_y + d*p_o1137545588985_curve_0_rs;
float ybc = p_o1137545588985_curve_1_y - d*p_o1137545588985_curve_1_ls;
float y2 = p_o1137545588985_curve_1_y;
return y1*omt3 + yac*omt2*t*3.0 + ybc*omt*t2*3.0 + y2*t3;
}
}
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);

// #output0: shape_6 (o1141723115834)
float o1141723115834_0_1_f = shape_circle((uv), p_o1141723115834_sides, p_o1141723115834_radius*1.0, p_o1141723115834_edge*1.0);

// #output0: shape_5 (o1141555343618)
float o1141555343618_0_1_f = shape_circle((uvmirror_h((transform2_clamp(transform2((uv), vec2(p_o1141622452477_translate_x*(2.0*1.0-1.0), p_o1141622452477_translate_y*(2.0*1.0-1.0)), p_o1141622452477_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1141622452477_scale_x*(2.0*1.0-1.0), p_o1141622452477_scale_y*(2.0*1.0-1.0))))), p_o1141572120832_offset, false ? -1.0 : 1.0)), p_o1141555343618_sides, p_o1141555343618_radius*1.0, p_o1141555343618_edge*1.0);

// #output0: mirror_2 (o1141572120832)
vec4 o1141572120832_0_1_rgba = vec4(vec3(o1141555343618_0_1_f), 1.0);

// #output0: shape_4 (o1141521789188)
float o1141521789188_0_1_f = shape_circle((transform2_clamp(transform2((uv), vec2(p_o1141622452477_translate_x*(2.0*1.0-1.0), p_o1141622452477_translate_y*(2.0*1.0-1.0)), p_o1141622452477_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1141622452477_scale_x*(2.0*1.0-1.0), p_o1141622452477_scale_y*(2.0*1.0-1.0))))), p_o1141521789188_sides, p_o1141521789188_radius*1.0, p_o1141521789188_edge*1.0);

// #output0: shape_3 (o1141488234685)
float o1141488234685_0_1_f = shape_circle((uvmirror_v((transform2_clamp(transform2((uv), vec2(p_o1141622452477_translate_x*(2.0*1.0-1.0), p_o1141622452477_translate_y*(2.0*1.0-1.0)), p_o1141622452477_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1141622452477_scale_x*(2.0*1.0-1.0), p_o1141622452477_scale_y*(2.0*1.0-1.0))))), p_o1141505011763_offset, false ? -1.0 : 1.0)), p_o1141488234685_sides, p_o1141488234685_radius*1.0, p_o1141488234685_edge*1.0);

// #output0: mirror (o1141505011763)
vec4 o1141505011763_0_1_rgba = vec4(vec3(o1141488234685_0_1_f), 1.0);

// #code: math_13 (o1141538566403)
float o1141538566403_0_clamp_false = (dot((o1141505011763_0_1_rgba).rgb, vec3(1.0))/3.0)-o1141521789188_0_1_f;
float o1141538566403_0_clamp_true = clamp(o1141538566403_0_clamp_false, 0.0, 1.0);
// #output0: math_13 (o1141538566403)
float o1141538566403_0_1_f = o1141538566403_0_clamp_true;

// #code: math_14 (o1141588898047)
float o1141588898047_0_clamp_false = o1141538566403_0_1_f+(dot((o1141572120832_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1141588898047_0_clamp_true = clamp(o1141588898047_0_clamp_false, 0.0, 1.0);
// #output0: math_14 (o1141588898047)
float o1141588898047_0_1_f = o1141588898047_0_clamp_false;

// #output0: transform2_6 (o1141622452477)
vec4 o1141622452477_0_1_rgba = vec4(vec3(o1141588898047_0_1_f), 1.0);

// #output0: invert_4 (o1141656006974)
vec4 o1141656006974_0_1_rgba = vec4(vec3(1.0)-o1141622452477_0_1_rgba.rgb, o1141622452477_0_1_rgba.a);

// #code: math_16 (o1141639229492)
float o1141639229492_0_clamp_false = p_o1141639229492_default_in1/(dot((o1141656006974_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1141639229492_0_clamp_true = clamp(o1141639229492_0_clamp_false, 0.0, 1.0);
// #output0: math_16 (o1141639229492)
float o1141639229492_0_1_f = o1141639229492_0_clamp_false;

// #code: math_17 (o1141672784189)
float o1141672784189_0_clamp_false = pow(o1141639229492_0_1_f,p_o1141672784189_default_in2);
float o1141672784189_0_clamp_true = clamp(o1141672784189_0_clamp_false, 0.0, 1.0);
// #output0: math_17 (o1141672784189)
float o1141672784189_0_1_f = o1141672784189_0_clamp_false;

// #code: rotate_2 (o1141404348477)
vec2 o1141404348477_0_c = vec2(0.5+p_o1141404348477_cx, 0.5+p_o1141404348477_cy);vec4 o1139290419380_0 = textureLod(texture_1, (rotate((uv)-o1141404348477_0_c, (elapsed_time*-2.5)*0.01745329251)+o1141404348477_0_c), 0.0);

// #output0: bevel_2/1536_2 (o1140699705510)
float o1140699705510_0_1_f = 1.0 - (dot((o1139290419380_0).rgb, vec3(1.0))/3.0);

// #output0: bevel_2/tonality (o1140280275131)
float o1140280275131_0_1_f = o1140280275131_curve_curve_fct(o1140699705510_0_1_f);

// #code: math_9 (o1138954874961)
float o1138954874961_0_clamp_false = p_o1138954874961_default_in1/o1140280275131_0_1_f;
float o1138954874961_0_clamp_true = clamp(o1138954874961_0_clamp_false, 0.0, 1.0);
// #output0: math_9 (o1138954874961)
float o1138954874961_0_1_f = o1138954874961_0_clamp_false;

// #code: math_8 (o1138921320531)
float o1138921320531_0_clamp_false = pow(o1138954874961_0_1_f,p_o1138921320531_default_in2);
float o1138921320531_0_clamp_true = clamp(o1138921320531_0_clamp_false, 0.0, 1.0);
// #output0: math_8 (o1138921320531)
float o1138921320531_0_1_f = o1138921320531_0_clamp_false;

// #output0: shape_2 (o1138904543323)
float o1138904543323_0_1_f = shape_circle((rotate((uv)-o1141404348477_0_c, (elapsed_time*-2.5)*0.01745329251)+o1141404348477_0_c), p_o1138904543323_sides, p_o1138904543323_radius*1.0, p_o1138904543323_edge*1.0);

// #code: math_10 (o1141421125682)
float o1141421125682_0_clamp_false = o1138904543323_0_1_f*o1138921320531_0_1_f;
float o1141421125682_0_clamp_true = clamp(o1141421125682_0_clamp_false, 0.0, 1.0);
// #output0: math_10 (o1141421125682)
float o1141421125682_0_1_f = o1141421125682_0_clamp_false;

// #output0: rotate_2 (o1141404348477)
vec4 o1141404348477_0_1_rgba = vec4(vec3(o1141421125682_0_1_f), 1.0);

// #code: rotate (o1138837434563)
vec2 o1138837434563_0_c = vec2(0.5+p_o1138837434563_cx, 0.5+p_o1138837434563_cy);vec4 o1136555733061_0 = textureLod(texture_2, (rotate((uv)-o1138837434563_0_c, (elapsed_time*5.0)*0.01745329251)+o1138837434563_0_c), 0.0);

// #output0: bevel/1536_2 (o1137965019374)
float o1137965019374_0_1_f = 1.0 - (dot((o1136555733061_0).rgb, vec3(1.0))/3.0);

// #output0: bevel/tonality (o1137545588985)
float o1137545588985_0_1_f = o1137545588985_curve_curve_fct(o1137965019374_0_1_f);

// #code: math_2 (o1136220188788)
float o1136220188788_0_clamp_false = p_o1136220188788_default_in1/o1137545588985_0_1_f;
float o1136220188788_0_clamp_true = clamp(o1136220188788_0_clamp_false, 0.0, 1.0);
// #output0: math_2 (o1136220188788)
float o1136220188788_0_1_f = o1136220188788_0_clamp_false;

// #code: math_4 (o1138753548535)
float o1138753548535_0_clamp_false = pow(o1136220188788_0_1_f,p_o1138753548535_default_in2);
float o1138753548535_0_clamp_true = clamp(o1138753548535_0_clamp_false, 0.0, 1.0);
// #output0: math_4 (o1138753548535)
float o1138753548535_0_1_f = o1138753548535_0_clamp_false;

// #output0: shape (o1138803880026)
float o1138803880026_0_1_f = shape_circle((rotate((uv)-o1138837434563_0_c, (elapsed_time*5.0)*0.01745329251)+o1138837434563_0_c), p_o1138803880026_sides, p_o1138803880026_radius*1.0, p_o1138803880026_edge*1.0);

// #code: math_7 (o1138820657346)
float o1138820657346_0_clamp_false = o1138803880026_0_1_f*o1138753548535_0_1_f;
float o1138820657346_0_clamp_true = clamp(o1138820657346_0_clamp_false, 0.0, 1.0);
// #output0: math_7 (o1138820657346)
float o1138820657346_0_1_f = o1138820657346_0_clamp_false;

// #output0: rotate (o1138837434563)
vec4 o1138837434563_0_1_rgba = vec4(vec3(o1138820657346_0_1_f), 1.0);

// #output0: sdcircle (o1136102748286)
float o1136102748286_0_1_sdf2d = length((transform2_clamp(transform2((uv), vec2(p_o1138719994102_translate_x*(2.0*1.0-1.0), p_o1138719994102_translate_y*(2.0*1.0-1.0)), p_o1138719994102_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1138719994102_scale_x*(2.0*1.0-1.0), p_o1138719994102_scale_y*(2.0*1.0-1.0)))))-vec2(p_o1136102748286_cx+0.5, p_o1136102748286_cy+0.5))-p_o1136102748286_r;

// #output0: sdannularshape (o1136136302687)
float o1136136302687_0_1_sdf2d = sdRipples(o1136102748286_0_1_sdf2d, p_o1136136302687_r, int(p_o1136136302687_ripples));

// #output0: sdshow (o1136119525478)
float o1136119525478_0_1_f = clamp(p_o1136119525478_base-o1136136302687_0_1_sdf2d/max(p_o1136119525478_bevel, 0.00001), 0.0, 1.0);

// #output0: invert (o1136169857113)
vec4 o1136169857113_0_1_rgba = vec4(vec3(1.0)-vec4(vec3(o1136119525478_0_1_f), 1.0).rgb, vec4(vec3(o1136119525478_0_1_f), 1.0).a);

// #code: math (o1136153079947)
float o1136153079947_0_clamp_false = p_o1136153079947_default_in1/(dot((o1136169857113_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1136153079947_0_clamp_true = clamp(o1136153079947_0_clamp_false, 0.0, 1.0);
// #output0: math (o1136153079947)
float o1136153079947_0_1_f = o1136153079947_0_clamp_false;

// #code: math_3 (o1138736771320)
float o1138736771320_0_clamp_false = pow(o1136153079947_0_1_f,p_o1138736771320_default_in2);
float o1138736771320_0_clamp_true = clamp(o1138736771320_0_clamp_false, 0.0, 1.0);
// #output0: math_3 (o1138736771320)
float o1138736771320_0_1_f = o1138736771320_0_clamp_false;

// #output0: transform2_3 (o1138719994102)
vec4 o1138719994102_0_1_rgba = vec4(vec3(o1138736771320_0_1_f), 1.0);

// #output0: sdcircle (o1136102748286)
float o1136102748286_0_3_sdf2d = length((transform2_clamp(transform2((uv), vec2(p_o1138703216874_translate_x*(2.0*1.0-1.0), p_o1138703216874_translate_y*(2.0*1.0-1.0)), p_o1138703216874_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1138703216874_scale_x*(2.0*1.0-1.0), p_o1138703216874_scale_y*(2.0*1.0-1.0)))))-vec2(p_o1136102748286_cx+0.5, p_o1136102748286_cy+0.5))-p_o1136102748286_r;

// #output0: sdannularshape (o1136136302687)
float o1136136302687_0_3_sdf2d = sdRipples(o1136102748286_0_3_sdf2d, p_o1136136302687_r, int(p_o1136136302687_ripples));

// #output0: sdshow (o1136119525478)
float o1136119525478_0_3_f = clamp(p_o1136119525478_base-o1136136302687_0_3_sdf2d/max(p_o1136119525478_bevel, 0.00001), 0.0, 1.0);

// #output0: invert (o1136169857113)
vec4 o1136169857113_0_3_rgba = vec4(vec3(1.0)-vec4(vec3(o1136119525478_0_3_f), 1.0).rgb, vec4(vec3(o1136119525478_0_3_f), 1.0).a);

// #code: math (o1136153079947)
float o1136153079947_2_clamp_false = p_o1136153079947_default_in1/(dot((o1136169857113_0_3_rgba).rgb, vec3(1.0))/3.0);
float o1136153079947_2_clamp_true = clamp(o1136153079947_2_clamp_false, 0.0, 1.0);
// #output0: math (o1136153079947)
float o1136153079947_0_3_f = o1136153079947_2_clamp_false;

// #code: math_3 (o1138736771320)
float o1138736771320_2_clamp_false = pow(o1136153079947_0_3_f,p_o1138736771320_default_in2);
float o1138736771320_2_clamp_true = clamp(o1138736771320_2_clamp_false, 0.0, 1.0);
// #output0: math_3 (o1138736771320)
float o1138736771320_0_3_f = o1138736771320_2_clamp_false;

// #output0: transform2_2 (o1138703216874)
vec4 o1138703216874_0_1_rgba = vec4(vec3(o1138736771320_0_3_f), 1.0);

// #code: math_5 (o1138770325740)
float o1138770325740_0_clamp_false = (dot((o1138703216874_0_1_rgba).rgb, vec3(1.0))/3.0)+(dot((o1138719994102_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1138770325740_0_clamp_true = clamp(o1138770325740_0_clamp_false, 0.0, 1.0);
// #output0: math_5 (o1138770325740)
float o1138770325740_0_1_f = o1138770325740_0_clamp_false;

// #output0: sdcircle (o1136102748286)
float o1136102748286_0_5_sdf2d = length((transform2_clamp(transform2((uv), vec2(p_o1141454680254_translate_x*(2.0*1.0-1.0), p_o1141454680254_translate_y*(2.0*1.0-1.0)), p_o1141454680254_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o1141454680254_scale_x*(2.0*1.0-1.0), p_o1141454680254_scale_y*(2.0*1.0-1.0)))))-vec2(p_o1136102748286_cx+0.5, p_o1136102748286_cy+0.5))-p_o1136102748286_r;

// #output0: sdannularshape (o1136136302687)
float o1136136302687_0_5_sdf2d = sdRipples(o1136102748286_0_5_sdf2d, p_o1136136302687_r, int(p_o1136136302687_ripples));

// #output0: sdshow (o1136119525478)
float o1136119525478_0_5_f = clamp(p_o1136119525478_base-o1136136302687_0_5_sdf2d/max(p_o1136119525478_bevel, 0.00001), 0.0, 1.0);

// #output0: invert (o1136169857113)
vec4 o1136169857113_0_5_rgba = vec4(vec3(1.0)-vec4(vec3(o1136119525478_0_5_f), 1.0).rgb, vec4(vec3(o1136119525478_0_5_f), 1.0).a);

// #code: math (o1136153079947)
float o1136153079947_4_clamp_false = p_o1136153079947_default_in1/(dot((o1136169857113_0_5_rgba).rgb, vec3(1.0))/3.0);
float o1136153079947_4_clamp_true = clamp(o1136153079947_4_clamp_false, 0.0, 1.0);
// #output0: math (o1136153079947)
float o1136153079947_0_5_f = o1136153079947_4_clamp_false;

// #code: math_3 (o1138736771320)
float o1138736771320_4_clamp_false = pow(o1136153079947_0_5_f,p_o1138736771320_default_in2);
float o1138736771320_4_clamp_true = clamp(o1138736771320_4_clamp_false, 0.0, 1.0);
// #output0: math_3 (o1138736771320)
float o1138736771320_0_5_f = o1138736771320_4_clamp_false;

// #output0: transform2_5 (o1141454680254)
vec4 o1141454680254_0_1_rgba = vec4(vec3(o1138736771320_0_5_f), 1.0);

// #code: math_12 (o1141471457468)
float o1141471457468_0_clamp_false = (dot((o1141454680254_0_1_rgba).rgb, vec3(1.0))/3.0)+o1138770325740_0_1_f;
float o1141471457468_0_clamp_true = clamp(o1141471457468_0_clamp_false, 0.0, 1.0);
// #output0: math_12 (o1141471457468)
float o1141471457468_0_1_f = o1141471457468_0_clamp_false;

// #code: math_6 (o1138787102814)
float o1138787102814_0_clamp_false = o1141471457468_0_1_f+(dot((o1138837434563_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1138787102814_0_clamp_true = clamp(o1138787102814_0_clamp_false, 0.0, 1.0);
// #output0: math_6 (o1138787102814)
float o1138787102814_0_1_f = o1138787102814_0_clamp_false;

// #code: math_11 (o1141437903109)
float o1141437903109_0_clamp_false = o1138787102814_0_1_f+(dot((o1141404348477_0_1_rgba).rgb, vec3(1.0))/3.0);
float o1141437903109_0_clamp_true = clamp(o1141437903109_0_clamp_false, 0.0, 1.0);
// #output0: math_11 (o1141437903109)
float o1141437903109_0_1_f = o1141437903109_0_clamp_false;

// #code: math_15 (o1141605675262)
float o1141605675262_0_clamp_false = o1141437903109_0_1_f+o1141672784189_0_1_f;
float o1141605675262_0_clamp_true = clamp(o1141605675262_0_clamp_false, 0.0, 1.0);
// #output0: math_15 (o1141605675262)
float o1141605675262_0_1_f = o1141605675262_0_clamp_false;

// #code: math_18 (o1141689561404)
float o1141689561404_0_clamp_false = pow(o1141605675262_0_1_f,p_o1141689561404_default_in2);
float o1141689561404_0_clamp_true = clamp(o1141689561404_0_clamp_false, 0.0, 1.0);
// #output0: math_18 (o1141689561404)
float o1141689561404_0_1_f = o1141689561404_0_clamp_true;

// #code: math_19 (o1141706338619)
float o1141706338619_0_clamp_false = o1141689561404_0_1_f*o1141723115834_0_1_f;
float o1141706338619_0_clamp_true = clamp(o1141706338619_0_clamp_false, 0.0, 1.0);
// #output0: math_19 (o1141706338619)
float o1141706338619_0_1_f = o1141706338619_0_clamp_false;

	vec4 color_tex = vec4(vec3(o1141706338619_0_1_f), 1.0);
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	COLOR = color_tex;
}



