shader_type spatial;

render_mode unshaded, blend_mix;
uniform vec3 paleta =vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5453);
}
vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5453);
}
vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5453);
}
float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
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
uniform sampler2D texture_1;
const float texture_1_size = 256.0;
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
float pingpong(float a, float b)
{
  return (b != 0.0) ? abs(fract((a - b) / (b * 2.0)) * b * 2.0 - b) : 0.0;
}
uniform sampler2D texture_2;
const float texture_2_size = 64.0;
vec2 rotate(vec2 uv, float rotate) {
 	vec2 rv;
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	return rv;
}
vec2 swirl_tile_false(vec2 uv, vec2 center, float radius, float angle) {
	vec2 v = uv-center;
	float l = length(v);
	if (l > radius) {
		return uv;
	} else {
		return rotate(v, angle*(1.0-l/radius)*(1.0-l/radius))+center;
	}
}
vec2 swirl_tile_true(vec2 uv, vec2 center, float radius, float angle) {
	center = fract(center);
	vec2 tile_offset = 2.0*(step(vec2(0.5), uv)-vec2(0.5));
	uv = swirl_tile_false(uv, center, radius, angle);
	uv = swirl_tile_false(uv, center+tile_offset, radius, angle);
	uv = swirl_tile_false(uv, center+vec2(tile_offset.x, 0.0), radius, angle);
	return swirl_tile_false(uv, center+vec2(0.0, tile_offset.y), radius, angle);
}
vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1 + (1.0-opacity)*c2;
}
vec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	if (rand(uv) < opacity) {
		return c1;
	} else {
		return c2;
	}
}
vec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1*c2 + (1.0-opacity)*c2;
}
vec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;
}
float blend_overlay_f(float c1, float c2) {
	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));
}
vec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;
}
float blend_soft_light_f(float c1, float c2) {
	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);
}
vec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_burn_f(float c1, float c2) {
	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);
}
vec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_dodge_f(float c1, float c2) {
	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);
}
vec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*max(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*min(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;
}
vec3 blend_additive(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + c1 * oppacity;
}
vec3 blend_addsub(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + (c1 - .5) * 2.0 * oppacity;
}
float blend_linear_light_f(float c1, float c2) {
	return (c1 + 2.0 * c2) - 1.0;
}
vec3 blend_linear_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
return opacity*vec3(blend_linear_light_f(c1.x, c2.x), blend_linear_light_f(c1.y, c2.y), blend_linear_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_vivid_light_f(float c1, float c2) {
	return (c1 < 0.5) ? 1.0 - (1.0 - c2) / (2.0 * c1) : c2 / (2.0 * (1.0 - c1));
}
vec3 blend_vivid_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_vivid_light_f(c1.x, c2.x), blend_vivid_light_f(c1.y, c2.y), blend_vivid_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_pin_light_f( float c1, float c2) {
	return (2.0 * c1 - 1.0 > c2) ? 2.0 * c1 - 1.0 : ((c1 < 0.5 * c2) ? 2.0 * c1 : c2);
}
vec3 blend_pin_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_pin_light_f(c1.x, c2.x), blend_pin_light_f(c1.y, c2.y), blend_pin_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_hard_mix_f(float c1, float c2) {
	return floor(c1 + c2);
}
vec3 blend_hard_mix(vec2 uv, vec3 c1, vec3 c2, float opacity) {
		return opacity*vec3(blend_hard_mix_f(c1.x, c2.x), blend_hard_mix_f(c1.y, c2.y), blend_hard_mix_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_exclusion_f(float c1, float c2) {
	return c1 + c2 - 2.0 * c1 * c2;
}
vec3 blend_exclusion(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_exclusion_f(c1.x, c2.x), blend_exclusion_f(c1.y, c2.y), blend_exclusion_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
uniform sampler2D texture_3;
const float texture_3_size = 512.0;
uniform sampler2D texture_4;
const float texture_4_size = 256.0;
uniform sampler2D texture_5;
const float texture_5_size = 128.0;
const float p_o750015_translate_x = 0.000000000;
const float p_o750015_translate_y = 0.000000000;
const float p_o750015_rotate = 0.000000000;
const float p_o750015_scale_x = 1.000000000;
const float p_o750015_scale_y = 1.000000000;
const float p_o748945_d_in1_x = 0.000000000;
const float p_o748945_d_in1_y = 0.000000000;
const float p_o748945_d_in1_z = 0.000000000;
const float p_o748945_d_in2_x = 4.700000000;
const float p_o748945_d_in2_y = 4.700000000;
const float p_o748945_d_in2_z = 6.250000000;
const float p_o748939_d_in1_x = 0.000000000;
const float p_o748939_d_in1_y = 0.000000000;
const float p_o748939_d_in1_z = 0.000000000;
const float p_o748939_d_in2_x = 1.060000000;
const float p_o748939_d_in2_y = 0.720000000;
const float p_o748939_d_in2_z = 0.660000000;
const float p_o748913_d_in1_x = 0.000000000;
const float p_o748913_d_in1_y = 0.000000000;
const float p_o748913_d_in1_z = 0.000000000;
const float p_o748913_d_in2_x = 0.550000000;
const float p_o748913_d_in2_y = 1.510000000;
const float p_o748913_d_in2_z = 2.730000000;
const float p_o748948_amount1 = 2.000000000;
const float p_o748948_amount2 = 1.140000000;
const float p_o748948_amount3 = 1.500000000;
const float p_o748948_amount4 = 8.000000000;
const float p_o749279_translate_x = 0.000000000;
const float p_o749279_translate_y = 0.000000000;
const float p_o749279_rotate = 0.000000000;
const float p_o749279_scale_x = 1.361250000;
const float p_o749279_scale_y = 1.000000000;
const float p_o748947_default_in1 = 0.000000000;
const float p_o748947_default_in2 = 0.000000000;
const float p_o748946_sides = 6.000000000;
const float p_o748946_radius = 0.430000000;
const float p_o748946_edge = 1.000000000;
const float p_o750018_amount1 = 1.000000000;
const float p_o750018_amount2 = 1.000000000;
const float p_o748938_value = 0.410000000;
const float p_o748938_width = 0.400000000;
const float p_o748937_default_in1 = 0.000000000;
const float p_o748937_default_in2 = 0.000000000;
const float p_o748936_default_in1 = 0.000000000;
const float p_o748936_default_in2 = 0.000000000;
const float p_o748935_sides = 6.000000000;
const float p_o748935_radius = 2.530000000;
const float p_o748935_edge = 0.930000000;
const float p_o748944_cx = 0.000000000;
const float p_o748944_cy = 0.000000000;
const float p_o748919_cx = 0.000000000;
const float p_o748919_cy = 0.000000000;
const float p_o748919_angle = 170.000000000;
const float p_o748919_radius = 2.050000000;
const float p_o748920_radius = 2.900000000;
const float p_o748920_repeat = 1.000000000;
const float p_o748941_translate_x = 0.000000000;
const float p_o748941_translate_y = 0.000000000;
const float p_o748941_rotate = 0.000000000;
const float p_o748941_scale_x = 1.000000000;
const float p_o748941_scale_y = 1.000000000;
const float p_o748940_default_in1 = 1.000000000;
const float p_o748940_default_in2 = 0.000000000;
const float p_o748961_repeat = 1.000000000;
const float p_o748961_rotate = 90.000000000;
const float p_o748961_gradient_0_pos = 0.000000000;
const vec4 p_o748961_gradient_0_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
const float p_o748961_gradient_1_pos = 1.000000000;
const vec4 p_o748961_gradient_1_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
vec4 o748961_gradient_gradient_fct(float x) {
  if (x < p_o748961_gradient_0_pos) {
    return p_o748961_gradient_0_col;
  } else if (x < p_o748961_gradient_1_pos) {
    return mix(p_o748961_gradient_0_col, p_o748961_gradient_1_col, ((x-p_o748961_gradient_0_pos)/(p_o748961_gradient_1_pos-p_o748961_gradient_0_pos)));
  }
  return p_o748961_gradient_1_col;
}
const float p_o748974_translate_x = 0.000000000;
const float p_o748934_default_in1 = 0.000000000;
const float p_o748934_default_in2 = 0.000000000;
const float p_o748921_repeat = 1.000000000;
const float p_o748921_gradient_0_pos = 0.000000000;
const vec4 p_o748921_gradient_0_col = vec4(0.058594000, 0.058594000, 0.058594000, 1.000000000);
const float p_o748921_gradient_1_pos = 0.416212000;
const vec4 p_o748921_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o748921_gradient_gradient_fct(float x) {
  if (x < p_o748921_gradient_0_pos) {
    return p_o748921_gradient_0_col;
  } else if (x < p_o748921_gradient_1_pos) {
    return mix(p_o748921_gradient_0_col, p_o748921_gradient_1_col, (x-p_o748921_gradient_0_pos)/(p_o748921_gradient_1_pos-p_o748921_gradient_0_pos));
  }
  return p_o748921_gradient_1_col;
}
const float seed_o748914 = 0.739189982;
const float p_o748914_count = 64.000000000;
const float p_o748976_amount1 = 1.000000000;
const float p_o748912_translate_x = 0.700000000;
const float p_o748912_translate_y = 0.700000000;
const float p_o748912_rotate = 0.000000000;
const float p_o748912_scale_x = 0.500000000;
const float p_o748912_scale_y = 0.500000000;
const float p_o750029_amount1 = 1.000000000;
const float p_o750029_amount2 = 1.000000000;
const float p_o750023_in_min = 0.250000000;
const float p_o750023_in_max = 1.000000000;
const float p_o750023_out_min = 0.000000000;
const float p_o750023_out_max = 0.100000000;
const float p_o750027_default_in1 = 0.000000000;
const float p_o750027_default_in2 = 0.000000000;
const float seed_o750028 = 0.093465723;
const float seed_o750025 = 0.189840898;
const float seed_o750024 = 0.515960336;
const float p_o750033_in_min = -1.000000000;
const float p_o750033_in_max = 1.000000000;
const float p_o750033_out_min = 0.000000000;
const float p_o750033_out_max = 1.000000000;
const float p_o750032_amount1 = 1.000000000;
const float p_o750031_d_in1_x = 0.000000000;
const float p_o750031_d_in1_y = 0.000000000;
const float p_o750031_d_in1_z = 0.000000000;
const float p_o750031_d_in2_x = 0.000000000;
const float p_o750031_d_in2_y = 0.000000000;
const float p_o750031_d_in2_z = 0.000000000;
const float p_o750035_in_min = 0.000000000;
const float p_o750035_in_max = 1.000000000;
const float p_o750035_out_min = -1.000000000;
const float p_o750035_out_max = 1.000000000;
const float seed_o750034 = 0.628730416;
const float seed_o750026 = 0.000000000;
const float p_o750026_in_min = 0.000000000;
const float p_o750026_in_max = 1.000000000;
const float p_o750026_out_max = 0.500000000;
const float p_o749906_amount1 = 9.000000000;
const float p_o749906_amount2 = 2.000000000;
const float p_o749906_amount3 = 5.000000000;
const float p_o749812_sides = 6.000000000;
const float p_o749812_radius = 0.030000000;
const float p_o749812_edge = 1.000000000;
const float p_o750124_default_in1 = 0.000000000;
const float p_o750124_default_in2 = 0.000000000;
const float p_o750123_in_min = 0.000000000;
const float p_o750123_in_max = 0.100000000;
const float p_o750123_out_min = 0.000000000;
const float p_o750123_out_max = 0.500000000;
const float p_o750122_in_min = 0.700000000;
const float p_o750122_in_max = 1.000000000;
const float p_o750122_out_min = 0.700000000;
const float p_o750122_out_max = 0.000000000;
float o748914_input_in(vec2 uv, float _seed_variation_) {
float o750028_0_1_f = (fract(elapsed_time*param_rnd(.9,1.7, (seed_o750028+fract(_seed_variation_))+0.420167)+param_rnd(0,1, (seed_o750028+fract(_seed_variation_))+0.123573)));
float o750027_0_clamp_false = smoothstep(0.0, 1.0, o750028_0_1_f);
float o750027_0_clamp_true = clamp(o750027_0_clamp_false, 0.0, 1.0);
float o750027_0_1_f = o750027_0_clamp_false;
vec4 o750023_0_1_rgba = vec4(vec3(p_o750023_out_min)+(vec4(vec3(o750027_0_1_f), 1.0).rgb-vec3(p_o750023_in_min))*vec3((p_o750023_out_max-(p_o750023_out_min))/(p_o750023_in_max-(p_o750023_in_min))), vec4(vec3(o750027_0_1_f), 1.0).a);
float o750025_0_clamp_false = sin((elapsed_time*1.2+param_rnd(0,10.0, (seed_o750025+fract(_seed_variation_))+-0.999990))*(param_rnd(0,10, (seed_o750025+fract(_seed_variation_))+17.841471)));
float o750025_0_clamp_true = clamp(o750025_0_clamp_false, 0.0, 1.0);
float o750025_0_2_f = o750025_0_clamp_false;
float o750024_0_clamp_false = cos((elapsed_time*1.2+param_rnd(0,10.0, (seed_o750024+fract(_seed_variation_))+-0.999990))*(param_rnd(0,10, (seed_o750024+fract(_seed_variation_))+17.841471)));
float o750024_0_clamp_true = clamp(o750024_0_clamp_false, 0.0, 1.0);
float o750024_0_2_f = o750024_0_clamp_false;
vec4 o750022_0_1_rgba = vec4(o750025_0_2_f, o750024_0_2_f, 0.0, 1.0);
vec3 o750034_0_rand = vec3(0.0);vec3 o750034_0_2_rgb = rand3( vec2( float((seed_o750034+fract(_seed_variation_))) + o750034_0_rand.x, rand( o750034_0_rand.yz ) ) );
vec4 o750035_0_1_rgba = vec4(vec3(p_o750035_out_min)+(vec4(o750034_0_2_rgb, 1.0).rgb-vec3(p_o750035_in_min))*vec3((p_o750035_out_max-(p_o750035_out_min))/(p_o750035_in_max-(p_o750035_in_min))), vec4(o750034_0_2_rgb, 1.0).a);
vec3 o750031_0_clamp_false = normalize(((o750035_0_1_rgba).rgb));
vec3 o750031_0_clamp_true = clamp(o750031_0_clamp_false, vec3(0.0), vec3(1.0));
vec3 o750031_0_1_rgb = o750031_0_clamp_false;
vec4 o750032_0_b = vec4(o750031_0_1_rgb, 1.0);
vec4 o750032_0_l;
float o750032_0_a;
o750032_0_l = vec4(vec3(o750028_0_1_f), 1.0);
o750032_0_a = p_o750032_amount1*1.0;
o750032_0_b = vec4(blend_multiply((uv), o750032_0_l.rgb, o750032_0_b.rgb, o750032_0_a*o750032_0_l.a), min(1.0, o750032_0_b.a+o750032_0_a*o750032_0_l.a));
vec4 o750032_0_2_rgba = o750032_0_b;
vec4 o750033_0_1_rgba = vec4(vec3(p_o750033_out_min)+(o750032_0_2_rgba.rgb-vec3(p_o750033_in_min))*vec3((p_o750033_out_max-(p_o750033_out_min))/(p_o750033_in_max-(p_o750033_in_min))), o750032_0_2_rgba.a);
vec4 o750029_0_b = o750023_0_1_rgba;
vec4 o750029_0_l;
float o750029_0_a;
o750029_0_l = o750022_0_1_rgba;
o750029_0_a = p_o750029_amount1*1.0;
o750029_0_b = vec4(blend_multiply((uv), o750029_0_l.rgb, o750029_0_b.rgb, o750029_0_a*o750029_0_l.a), min(1.0, o750029_0_b.a+o750029_0_a*o750029_0_l.a));
o750029_0_l = o750033_0_1_rgba;
o750029_0_a = p_o750029_amount2*1.0;
o750029_0_b = vec4(blend_additive((uv), o750029_0_l.rgb, o750029_0_b.rgb, o750029_0_a*o750029_0_l.a), min(1.0, o750029_0_b.a+o750029_0_a*o750029_0_l.a));
vec4 o750029_0_2_rgba = o750029_0_b;
float o750121_0_1_f = o750029_0_2_rgba.r;
float o750121_1_2_f = o750029_0_2_rgba.g;
vec4 o750026_0_1_rgba = vec4(vec3((param_rnd(1,4, (seed_o750026+fract(_seed_variation_))+34.841471)))+(vec4(vec3(o750027_0_1_f), 1.0).rgb-vec3(p_o750026_in_min))*vec3((p_o750026_out_max-((param_rnd(1,4, (seed_o750026+fract(_seed_variation_))+34.841471))))/(p_o750026_in_max-(p_o750026_in_min))), vec4(vec3(o750027_0_1_f), 1.0).a);
vec4 o749737_0 = textureLod(texture_3, (transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), 0.0);
vec4 o749831_0 = textureLod(texture_4, (transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), 0.0);
float o749812_0_1_f = shape_circle((transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), p_o749812_sides, p_o749812_radius*1.0, p_o749812_edge*1.0);
vec4 o749644_0 = textureLod(texture_5, (transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), 0.0);
vec4 o749906_0_b = o749737_0;
vec4 o749906_0_l;
float o749906_0_a;
o749906_0_l = o749831_0;
o749906_0_a = p_o749906_amount1*1.0;
o749906_0_b = vec4(blend_additive((transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), o749906_0_l.rgb, o749906_0_b.rgb, o749906_0_a*o749906_0_l.a), min(1.0, o749906_0_b.a+o749906_0_a*o749906_0_l.a));
o749906_0_l = vec4(vec3(o749812_0_1_f), 1.0);
o749906_0_a = p_o749906_amount2*1.0;
o749906_0_b = vec4(blend_additive((transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), o749906_0_l.rgb, o749906_0_b.rgb, o749906_0_a*o749906_0_l.a), min(1.0, o749906_0_b.a+o749906_0_a*o749906_0_l.a));
o749906_0_l = o749644_0;
o749906_0_a = p_o749906_amount3*1.0;
o749906_0_b = vec4(blend_additive((transform2_clamp(transform2((uv), vec2(p_o748912_translate_x*(2.0*o750121_0_1_f-1.0), p_o748912_translate_y*(2.0*o750121_1_2_f-1.0)), p_o748912_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748912_scale_x*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0), p_o748912_scale_y*(2.0*(dot((o750026_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0))))), o749906_0_l.rgb, o749906_0_b.rgb, o749906_0_a*o749906_0_l.a), min(1.0, o749906_0_b.a+o749906_0_a*o749906_0_l.a));
vec4 o749906_0_2_rgba = o749906_0_b;
vec4 o748912_0_1_rgba = o749906_0_2_rgba;
vec4 o750123_0_1_rgba = vec4(vec3(p_o750123_out_min)+(vec4(vec3(o750027_0_1_f), 1.0).rgb-vec3(p_o750123_in_min))*vec3((p_o750123_out_max-(p_o750123_out_min))/(p_o750123_in_max-(p_o750123_in_min))), vec4(vec3(o750027_0_1_f), 1.0).a);
vec4 o750122_0_1_rgba = vec4(vec3(p_o750122_out_min)+(vec4(vec3(o750027_0_1_f), 1.0).rgb-vec3(p_o750122_in_min))*vec3((p_o750122_out_max-(p_o750122_out_min))/(p_o750122_in_max-(p_o750122_in_min))), vec4(vec3(o750027_0_1_f), 1.0).a);
float o750124_0_clamp_false = (dot((o750123_0_1_rgba).rgb, vec3(1.0))/3.0)*(dot((o750122_0_1_rgba).rgb, vec3(1.0))/3.0);
float o750124_0_clamp_true = clamp(o750124_0_clamp_false, 0.0, 1.0);
float o750124_0_1_f = o750124_0_clamp_false;
vec4 o748976_0_b = o748912_0_1_rgba;
vec4 o748976_0_l;
float o748976_0_a;
o748976_0_l = vec4(vec3(o750124_0_1_f), 1.0);
o748976_0_a = p_o748976_amount1*1.0;
o748976_0_b = vec4(blend_multiply((uv), o748976_0_l.rgb, o748976_0_b.rgb, o748976_0_a*o748976_0_l.a), min(1.0, o748976_0_b.a+o748976_0_a*o748976_0_l.a));
vec4 o748976_0_2_rgba = o748976_0_b;
return (dot((o748976_0_2_rgba).rgb, vec3(1.0))/3.0);
}
float b_o748914(vec2 uv, int count, float seed, float _seed_variation_) {
	float res = 0.0;
	for(int i=0; i < count; i++)
		res += o748914_input_in(uv,rand2(vec2(seed+float(i))).x);
	return res;
}const float p_o748955_value = 0.630000000;
const float p_o748955_width = 0.440000000;
const float p_o748954_default_in1 = 0.000000000;
const float p_o748954_default_in2 = 0.000000000;
const float p_o748953_default_in1 = 0.000000000;
const float p_o748953_default_in2 = 0.000000000;
const float p_o748952_value = 0.500000000;
const float p_o748952_width = 0.800000000;
const float p_o748952_contrast = 0.000000000;
const float p_o748951_sides = 6.000000000;
const float p_o748951_radius = 2.000000000;
const float p_o748951_edge = 1.000000000;
const float p_o748959_cx = 0.000000000;
const float p_o748959_cy = 0.000000000;
const float p_o748958_translate_x = 0.000000000;
const float p_o748958_translate_y = 0.000000000;
const float p_o748958_rotate = 15.000000000;
const float p_o748958_scale_x = -1.000000000;
const float p_o748958_scale_y = 1.000000000;
const float p_o748950_radius = 5.100000000;
const float p_o748950_repeat = 1.000000000;
const float p_o748957_translate_x = 0.000000000;
const float p_o748957_translate_y = 0.000000000;
const float p_o748957_rotate = 0.000000000;
const float p_o748957_scale_x = 1.000000000;
const float p_o748957_scale_y = 1.000000000;
const float p_o748949_default_in1 = 0.611200000;
const float p_o748949_default_in2 = 0.000000000;
const float p_o748975_translate_x = 0.000000000;
const float p_o748960_sides = 6.000000000;
const float p_o748960_radius = 1.500000000;
const float p_o748960_edge = 1.000000000;
const float p_o750017_default_in1 = 0.000000000;
const float p_o750017_default_in2 = 0.000000000;
const float p_o750016_sides = 6.000000000;
const float p_o750016_radius = 1.110000000;
const float p_o750016_edge = 2.690000000;
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);
vec4 o749277_0 = textureLod(texture_1, transform2_clamp(transform2((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), vec2(p_o749279_translate_x*(2.0*1.0-1.0), p_o749279_translate_y*(2.0*1.0-1.0)), p_o749279_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o749279_scale_x*(2.0*1.0-1.0), p_o749279_scale_y*(2.0*1.0-1.0)))), 0.0);
vec4 o749279_0_1_rgba = o749277_0;
float o748946_0_1_f = shape_circle((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), p_o748946_sides, p_o748946_radius*1.0, p_o748946_edge*1.0);
float o748947_0_clamp_false = smoothstep(0.0, 1.0, o748946_0_1_f);
float o748947_0_clamp_true = clamp(o748947_0_clamp_false, 0.0, 1.0);
float o748947_0_1_f = o748947_0_clamp_false;
float o748935_0_1_f = shape_circle((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), p_o748935_sides, p_o748935_radius*1.0, p_o748935_edge*1.0);
float o748936_0_clamp_false = smoothstep(0.0, 1.0, o748935_0_1_f);
float o748936_0_clamp_true = clamp(o748936_0_clamp_false, 0.0, 1.0);
float o748936_0_1_f = o748936_0_clamp_false;
vec2 o748944_0_c = vec2(0.5+p_o748944_cx, 0.5+p_o748944_cy);float o748961_0_r = 0.5+(cos(p_o748961_rotate*0.01745329251)*((vec2(fract(p_o748920_repeat*atan((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).y-0.5, (swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748920_radius*length((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251))-vec2(0.5))))).x-0.5)+sin(p_o748961_rotate*0.01745329251)*((vec2(fract(p_o748920_repeat*atan((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).y-0.5, (swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748920_radius*length((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251))-vec2(0.5))))).y-0.5))/(cos(abs(mod(p_o748961_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);vec4 o748961_0_1_rgba = o748961_gradient_gradient_fct(fract(o748961_0_r*p_o748961_repeat));
float o748940_0_clamp_false = p_o748940_default_in1/(dot((o748961_0_1_rgba).rgb, vec3(1.0))/3.0);
float o748940_0_clamp_true = clamp(o748940_0_clamp_false, 0.0, 1.0);
float o748940_0_2_f = o748940_0_clamp_false;
vec4 o750013_0 = textureLod(texture_2, ((fract(transform2((vec2(fract(p_o748920_repeat*atan((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).y-0.5, (swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251)).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748920_radius*length((swirl_tile_false((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748944_0_c, (elapsed_time*110.)*0.01745329251)+o748944_0_c), vec2(0.5+p_o748919_cx, 0.5+p_o748919_cy), p_o748919_radius, p_o748919_angle*0.01745329251))-vec2(0.5))))), vec2(p_o748941_translate_x*(2.0*1.0-1.0), p_o748941_translate_y*(2.0*1.0-1.0)), p_o748941_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748941_scale_x*(2.0*1.0-1.0), p_o748941_scale_y*(2.0*o748940_0_2_f-1.0)))))-vec2(p_o748974_translate_x, (elapsed_time*-.6))), 0.0);
float o748943_0_1_f = o750013_0.r;
vec4 o748974_0_1_rgba = vec4(vec3(o748943_0_1_f), 1.0);
vec4 o748941_0_1_rgba = o748974_0_1_rgba;
vec4 o748920_0_1_rgba = o748941_0_1_rgba;
vec4 o748919_0_1_rgba = o748920_0_1_rgba;
vec4 o748944_0_1_rgba = o748919_0_1_rgba;
float o748937_0_clamp_false = o748936_0_1_f-(dot((o748944_0_1_rgba).rgb, vec3(1.0))/3.0);
float o748937_0_clamp_true = clamp(o748937_0_clamp_false, 0.0, 1.0);
float o748937_0_1_f = o748937_0_clamp_false;
vec3 o748938_0_false = clamp((vec4(vec3(o748937_0_1_f), 1.0).rgb-vec3(p_o748938_value))/max(0.0001, p_o748938_width)+vec3(0.5), vec3(0.0), vec3(1.0));
vec3 o748938_0_true = vec3(1.0)-o748938_0_false;vec4 o748938_0_1_rgba = vec4(o748938_0_false, vec4(vec3(o748937_0_1_f), 1.0).a);
vec4 o748921_0_1_rgba = o748921_gradient_gradient_fct(fract(p_o748921_repeat*1.41421356237*length(fract((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))))-vec2(0.5, 0.5))));
float o748934_0_clamp_false = (dot((o748938_0_1_rgba).rgb, vec3(1.0))/3.0)/(dot((o748921_0_1_rgba).rgb, vec3(1.0))/3.0);
float o748934_0_clamp_true = clamp(o748934_0_clamp_false, 0.0, 1.0);
float o748934_0_1_f = o748934_0_clamp_false;
float o748914_0_b = b_o748914((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), int(p_o748914_count), float((seed_o748914+fract(_seed_variation_))), _seed_variation_);float o748914_0_1_f = o748914_0_b;
vec4 o750018_0_b = o748938_0_1_rgba;
vec4 o750018_0_l;
float o750018_0_a;

o750018_0_l = vec4(vec3(o748934_0_1_f), 1.0);
o750018_0_a = p_o750018_amount1*1.0;
o750018_0_b = vec4(blend_multiply((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o750018_0_l.rgb, o750018_0_b.rgb, o750018_0_a*o750018_0_l.a), min(1.0, o750018_0_b.a+o750018_0_a*o750018_0_l.a));

o750018_0_l = vec4(vec3(o748914_0_1_f), 1.0);
o750018_0_a = p_o750018_amount2*1.0;
o750018_0_b = vec4(blend_additive((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o750018_0_l.rgb, o750018_0_b.rgb, o750018_0_a*o750018_0_l.a), min(1.0, o750018_0_b.a+o750018_0_a*o750018_0_l.a));

vec4 o750018_0_2_rgba = o750018_0_b;
float o748951_0_1_f = shape_circle((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), p_o748951_sides, p_o748951_radius*1.0, p_o748951_edge*1.0);
float o748952_0_step = clamp((o748951_0_1_f - (p_o748952_value))/max(0.0001, p_o748952_width)+0.5, 0.0, 1.0);
float o748952_0_false = clamp((min(o748952_0_step, 1.0-o748952_0_step) * 2.0) / (1.0 - p_o748952_contrast), 0.0, 1.0);
float o748952_0_true = 1.0-o748952_0_false;float o748952_0_1_f = o748952_0_false;
float o748953_0_clamp_false = smoothstep(0.0, 1.0, o748952_0_1_f);
float o748953_0_clamp_true = clamp(o748953_0_clamp_false, 0.0, 1.0);
float o748953_0_1_f = o748953_0_clamp_false;
vec2 o748959_0_c = vec2(0.5+p_o748959_cx, 0.5+p_o748959_cy);float o750019_0_1_f = (log2(distance((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c),vec2(.5)))/log2(.7091));
float o748961_2_r = 0.5+(cos(p_o748961_rotate*0.01745329251)*((vec2(fract(p_o748950_repeat*atan((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).y-0.5, (transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748950_radius*length((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0))))-vec2(0.5))))).x-0.5)+sin(p_o748961_rotate*0.01745329251)*((vec2(fract(p_o748950_repeat*atan((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).y-0.5, (transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748950_radius*length((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0))))-vec2(0.5))))).y-0.5))/(cos(abs(mod(p_o748961_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);vec4 o748961_0_3_rgba = o748961_gradient_gradient_fct(fract(o748961_2_r*p_o748961_repeat));
float o748949_0_clamp_false = p_o748949_default_in1/(dot((o748961_0_3_rgba).rgb, vec3(1.0))/3.0);
float o748949_0_clamp_true = clamp(o748949_0_clamp_false, 0.0, 1.0);
float o748949_0_2_f = o748949_0_clamp_false;
vec4 o750013_1 = textureLod(texture_2, ((fract(transform2((vec2(fract(p_o748950_repeat*atan((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).y-0.5, (transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0)))).x-0.5)*0.15915494309), min(0.99999, 2.0/p_o748950_radius*length((transform2((rotate((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0))))-o748959_0_c, (elapsed_time*150.)*0.01745329251)+o748959_0_c), vec2(p_o748958_translate_x*(2.0*1.0-1.0), p_o748958_translate_y*(2.0*1.0-1.0)), p_o748958_rotate*0.01745329251*(2.0*o750019_0_1_f-1.0), vec2(p_o748958_scale_x*(2.0*1.0-1.0), p_o748958_scale_y*(2.0*1.0-1.0))))-vec2(0.5))))), vec2(p_o748957_translate_x*(2.0*1.0-1.0), p_o748957_translate_y*(2.0*1.0-1.0)), p_o748957_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o748957_scale_x*(2.0*1.0-1.0), p_o748957_scale_y*(2.0*o748949_0_2_f-1.0)))))-vec2(p_o748975_translate_x, (elapsed_time*1.5))), 0.0);
float o748943_1_3_f = o750013_1.g;
vec4 o748975_0_1_rgba = vec4(vec3(o748943_1_3_f), 1.0);
vec4 o748957_0_1_rgba = o748975_0_1_rgba;
vec4 o748950_0_1_rgba = o748957_0_1_rgba;
vec4 o748958_0_1_rgba = o748950_0_1_rgba;
vec4 o748959_0_1_rgba = o748958_0_1_rgba;
float o748954_0_clamp_false = o748953_0_1_f-(dot((o748959_0_1_rgba).rgb, vec3(1.0))/3.0);
float o748954_0_clamp_true = clamp(o748954_0_clamp_false, 0.0, 1.0);
float o748954_0_1_f = o748954_0_clamp_false;
vec3 o748955_0_false = clamp((vec4(vec3(o748954_0_1_f), 1.0).rgb-vec3(p_o748955_value))/max(0.0001, p_o748955_width)+vec3(0.5), vec3(0.0), vec3(1.0));
vec3 o748955_0_true = vec3(1.0)-o748955_0_false;vec4 o748955_0_1_rgba = vec4(o748955_0_false, vec4(vec3(o748954_0_1_f), 1.0).a);
float o748960_0_1_f = shape_circle((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), p_o748960_sides, p_o748960_radius*1.0, p_o748960_edge*1.0);
float o750016_0_1_f = shape_circle((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), p_o750016_sides, p_o750016_radius*1.0, p_o750016_edge*1.0);
float o750017_0_clamp_false = smoothstep(0.0, 1.0, o750016_0_1_f);
float o750017_0_clamp_true = clamp(o750017_0_clamp_false, 0.0, 1.0);
float o750017_0_1_f = o750017_0_clamp_false;
vec4 o748948_0_b = o749279_0_1_rgba;
vec4 o748948_0_l;
float o748948_0_a;

o748948_0_l = vec4(vec3(o748947_0_1_f), 1.0);
o748948_0_a = p_o748948_amount1*1.0;
o748948_0_b = vec4(blend_additive((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o748948_0_l.rgb, o748948_0_b.rgb, o748948_0_a*o748948_0_l.a), min(1.0, o748948_0_b.a+o748948_0_a*o748948_0_l.a));

o748948_0_l = o750018_0_2_rgba;
o748948_0_a = p_o748948_amount2*1.0;
o748948_0_b = vec4(blend_additive((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o748948_0_l.rgb, o748948_0_b.rgb, o748948_0_a*o748948_0_l.a), min(1.0, o748948_0_b.a+o748948_0_a*o748948_0_l.a));

o748948_0_l = o748955_0_1_rgba;
o748948_0_a = p_o748948_amount3*o748960_0_1_f;
o748948_0_b = vec4(blend_additive((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o748948_0_l.rgb, o748948_0_b.rgb, o748948_0_a*o748948_0_l.a), min(1.0, o748948_0_b.a+o748948_0_a*o748948_0_l.a));

o748948_0_l = vec4(vec3(o750017_0_1_f), 1.0);
o748948_0_a = p_o748948_amount4*1.0;
o748948_0_b = vec4(blend_additive((transform2((uv), vec2(p_o750015_translate_x*(2.0*1.0-1.0), p_o750015_translate_y*(2.0*1.0-1.0)), p_o750015_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o750015_scale_x*(2.0*1.0-1.0), p_o750015_scale_y*(2.0*1.0-1.0)))), o748948_0_l.rgb, o748948_0_b.rgb, o748948_0_a*o748948_0_l.a), min(1.0, o748948_0_b.a+o748948_0_a*o748948_0_l.a));

vec4 o748948_0_2_rgba = o748948_0_b;
vec3 o748913_0_clamp_false = ((o748948_0_2_rgba).rgb)*vec3(p_o748913_d_in2_x, p_o748913_d_in2_y, p_o748913_d_in2_z);
vec3 o748913_0_clamp_true = clamp(o748913_0_clamp_false, vec3(0.0), vec3(1.0));
vec3 o748913_0_2_rgb = o748913_0_clamp_false;
vec3 o748939_0_clamp_false = pow(o748913_0_2_rgb,vec3(p_o748939_d_in2_x, p_o748939_d_in2_y, p_o748939_d_in2_z));
vec3 o748939_0_clamp_true = clamp(o748939_0_clamp_false, vec3(0.0), vec3(1.0));
vec3 o748939_0_2_rgb = o748939_0_clamp_false;
vec3 o748945_0_clamp_false = o748939_0_2_rgb/vec3(p_o748945_d_in2_x, p_o748945_d_in2_y, p_o748945_d_in2_z);
vec3 o748945_0_clamp_true = clamp(o748945_0_clamp_false, vec3(0.0), vec3(1.0));
vec3 o748945_0_2_rgb = o748945_0_clamp_false;
vec4 o750015_0_1_rgba = vec4(o748945_0_2_rgb, 1.0);

	vec4 color_tex = o750015_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	ALBEDO = color_tex.rgb*paleta;
	ALPHA = color_tex.a;

}



