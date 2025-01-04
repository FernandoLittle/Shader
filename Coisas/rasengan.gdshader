shader_type spatial;

render_mode unshaded, blend_mix;

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
const float texture_1_size = 1024.0;
float pingpong(float a, float b)
{
  return (b != 0.0) ? abs(fract((a - b) / (b * 2.0)) * b * 2.0 - b) : 0.0;
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
uniform sampler2D texture_2;
const float texture_2_size = 256.0;
float value_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float p00 = rand(mod(o, size));
	float p01 = rand(mod(o + vec2(0.0, 1.0), size));
	float p10 = rand(mod(o + vec2(1.0, 0.0), size));
	float p11 = rand(mod(o + vec2(1.0, 1.0), size));
	p00 = sin(p00 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p01 = sin(p01 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p10 = sin(p10 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p11 = sin(p11 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	vec2 t =  f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	return mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
}
float fbm_2d_value(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = value_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float perlin_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float a00 = rand(mod(o, size)) * 6.28318530718 + offset * 6.28318530718;
	float a01 = rand(mod(o + vec2(0.0, 1.0), size)) * 6.28318530718 + offset * 6.28318530718;
	float a10 = rand(mod(o + vec2(1.0, 0.0), size)) * 6.28318530718 + offset * 6.28318530718;
	float a11 = rand(mod(o + vec2(1.0, 1.0), size)) * 6.28318530718 + offset * 6.28318530718;
	vec2 v00 = vec2(cos(a00), sin(a00));
	vec2 v01 = vec2(cos(a01), sin(a01));
	vec2 v10 = vec2(cos(a10), sin(a10));
	vec2 v11 = vec2(cos(a11), sin(a11));
	float p00 = dot(v00, f);
	float p01 = dot(v01, f - vec2(0.0, 1.0));
	float p10 = dot(v10, f - vec2(1.0, 0.0));
	float p11 = dot(v11, f - vec2(1.0, 1.0));
	vec2 t =  f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	return 0.5 + mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
}
float fbm_2d_perlin(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = perlin_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float perlinabs_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	return abs(2.0*perlin_noise_2d(coord, size, offset, seed)-1.0);
}
float fbm_2d_perlinabs(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = perlinabs_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float fbm_2d_mod289(float x) {
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float fbm_2d_permute(float x) {
	return fbm_2d_mod289(((x * 34.0) + 1.0) * x);
}
vec2 fbm_2d_rgrad2(vec2 p, float rot, float seed) {
	float u = fbm_2d_permute(fbm_2d_permute(p.x) + p.y) * 0.0243902439 + rot; // Rotate by shift
	u = fract(u) * 6.28318530718; // 2*pi
	return vec2(cos(u), sin(u));
}
float simplex_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	coord *= 2.0; // needed for it to tile
	coord += rand2(vec2(seed, 1.0-seed)) + size;
	size *= 2.0; // needed for it to tile
	coord.y += 0.001;
	vec2 uv = vec2(coord.x + coord.y*0.5, coord.y);
	vec2 i0 = floor(uv);
	vec2 f0 = fract(uv);
	vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	i1 = i0 + i1;
	vec2 i2 = i0 + vec2(1.0, 1.0);
	vec2 d0 = coord - p0;
	vec2 d1 = coord - p1;
	vec2 d2 = coord - p2;
	vec3 xw = mod(vec3(p0.x, p1.x, p2.x), size.x);
	vec3 yw = mod(vec3(p0.y, p1.y, p2.y), size.y);
	vec3 iuw = xw + 0.5 * yw;
	vec3 ivw = yw;
	vec2 g0 = fbm_2d_rgrad2(vec2(iuw.x, ivw.x), offset, seed);
	vec2 g1 = fbm_2d_rgrad2(vec2(iuw.y, ivw.y), offset, seed);
	vec2 g2 = fbm_2d_rgrad2(vec2(iuw.z, ivw.z), offset, seed);
	vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	t = max(t, vec3(0.0));
	vec3 t2 = t * t;
	vec3 t4 = t2 * t2;
	float n = dot(t4, w);
	return 0.5 + 5.5 * n;
}
float fbm_2d_simplex(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = simplex_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node =  0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718 * node);
			vec2 diff = neighbor + node - f;
			float dist = length(diff);
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular2_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = length(diff);
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular2(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular2_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular3_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = abs((diff).x) + abs((diff).y);
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular3(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular3_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular4_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = abs((diff).x) + abs((diff).y);
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular4(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular4_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular5_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.5 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = max(abs((diff).x), abs((diff).y));
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular5(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular5_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular6_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = max(abs((diff).x), abs((diff).y));
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular6(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular6_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
// MIT License Inigo Quilez - https://www.shadertoy.com/view/Xd23Dh
float voronoise_noise_2d( vec2 coord, vec2 size, float offset, float seed) {
	vec2 i = floor(coord) + rand2(vec2(seed, 1.0-seed)) + size;
	vec2 f = fract(coord);
	
	vec2 a = vec2(0.0);
	
	for( int y=-2; y<=2; y++ ) {
		for( int x=-2; x<=2; x++ ) {
			vec2  g = vec2( float(x), float(y) );
			vec3  o = rand3( mod(i + g, size) + vec2(seed) );
			o.xy += 0.25 * sin(offset * 6.28318530718 + 6.28318530718*o.xy);
			vec2  d = g - f + o.xy;
			float w = pow( 1.0-smoothstep(0.0, 1.414, length(d)), 1.0 );
			a += vec2(o.z*w,w);
		}
	}
	
	return a.x/a.y;
}
float fbm_2d_voronoise(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = voronoise_noise_2d(coord*size, size, offset, seed);
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
vec2 get_from_tileset(float count, float seed, vec2 uv) {
	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));
}
vec2 custom_uv_transform(vec2 uv, vec2 cst_scale, float rnd_rotate, float rnd_scale, vec2 seed) {
	seed = rand2(seed);
	uv -= vec2(0.5);
	float angle = (seed.x * 2.0 - 1.0) * rnd_rotate;
	float ca = cos(angle);
	float sa = sin(angle);
	uv = vec2(ca*uv.x+sa*uv.y, -sa*uv.x+ca*uv.y);
	uv *= (seed.y-0.5)*2.0*rnd_scale+1.0;
	uv /= cst_scale;
	uv += vec2(0.5);
	return uv;
}
uniform sampler2D texture_3;
const float texture_3_size = 256.0;
vec2 rotate(vec2 uv, float rotate) {
 	vec2 rv;
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	return rv;	
}
vec2 scale(vec2 uv, vec2 center, vec2 scale) {
	uv -= center;
	uv /= scale;
	uv += center;
	return uv;
}
const float p_o30204_cx = 0.000000000;
const float p_o30204_cy = 0.000000000;
const float p_o30204_scale_x = 0.700000000;
const float p_o30204_scale_y = 0.700000000;
const float p_o29964_amount1 = 1.000000000;
const float p_o29964_amount2 = 1.000000000;
const float p_o29964_amount3 = 1.560000000;
const float p_o29964_amount4 = 1.000000000;
const float p_o30018_amount1 = 0.620000000;
const float p_o29841_amount1 = 0.700000000;
const float p_o29843_translate_x = 0.000000000;
const float p_o29843_translate_y = 0.000000000;
const float p_o29843_rotate = 0.000000000;
const float p_o29843_scale_x = 2.000000000;
const float p_o29843_scale_y = 2.000000000;
const float p_o29842_amount1 = 1.000000000;
const float p_o29792_gradient_0_pos = 0.210640000;
const vec4 p_o29792_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o29792_gradient_1_pos = 1.000000000;
const vec4 p_o29792_gradient_1_col = vec4(0.364196986, 0.563633978, 0.796875000, 1.000000000);
vec4 o29792_gradient_gradient_fct(float x) {
  if (x < p_o29792_gradient_0_pos) {
    return p_o29792_gradient_0_col;
  } else if (x < p_o29792_gradient_1_pos) {
    return mix(p_o29792_gradient_0_col, p_o29792_gradient_1_col, ((x-p_o29792_gradient_0_pos)/(p_o29792_gradient_1_pos-p_o29792_gradient_0_pos)));
  }
  return p_o29792_gradient_1_col;
}
const float p_o29839_default_in1 = 0.000000000;
const float p_o29839_default_in2 = 0.000000000;
const float p_o29836_default_in1 = 0.000000000;
const float p_o29836_default_in2 = 3.150000000;
const float p_o29834_default_in1 = 0.000000000;
const float p_o29834_default_in2 = 0.500000000;
const float p_o29833_default_in1 = 0.000000000;
const float p_o29833_default_in2 = 2.570000000;
const float p_o29805_default_in1 = 0.000000000;
const float p_o29805_default_in2 = -0.228100000;
const float p_o29806_repeat = 1.000000000;
const float p_o29806_rotate = -90.000000000;
const float p_o29806_gradient_0_pos = 0.000000000;
const vec4 p_o29806_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o29806_gradient_1_pos = 1.000000000;
const vec4 p_o29806_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o29806_gradient_gradient_fct(float x) {
  if (x < p_o29806_gradient_0_pos) {
    return p_o29806_gradient_0_col;
  } else if (x < p_o29806_gradient_1_pos) {
    return mix(p_o29806_gradient_0_col, p_o29806_gradient_1_col, ((x-p_o29806_gradient_0_pos)/(p_o29806_gradient_1_pos-p_o29806_gradient_0_pos)));
  }
  return p_o29806_gradient_1_col;
}
const float p_o29790_color = 0.000000000;
const float p_o29840_default_in1 = 0.000000000;
const float p_o29840_default_in2 = 0.000000000;
const float p_o29838_sides = 6.000000000;
const float p_o29838_radius = 2.050000000;
const float p_o29838_edge = 0.520000000;
const vec4 p_o30019_color = vec4(0.000000000, 0.281403989, 0.676962018, 1.000000000);
const float p_o30041_translate_x = 0.000000000;
const float p_o30041_translate_y = 0.511400000;
const float p_o30040_translate_x = 0.000000000;
const float p_o30040_translate_y = 0.000000000;
const float p_o30040_rotate = 0.000000000;
const float p_o30040_scale_x = 1.000000000;
const float p_o30040_scale_y = 0.406950000;
const float p_o30023_min = 0.807300000;
const float p_o30023_max = 0.984300000;
const float p_o30023_step = 0.000000000;
const float p_o30027_repeat = 1.000000000;
const float p_o30027_rotate = 90.000000000;
const float p_o30027_gradient_0_pos = 0.000000000;
const vec4 p_o30027_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o30027_gradient_1_pos = 1.000000000;
const vec4 p_o30027_gradient_1_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o30027_gradient_gradient_fct(float x) {
  if (x < p_o30027_gradient_0_pos) {
    return p_o30027_gradient_0_col;
  } else if (x < p_o30027_gradient_1_pos) {
    return mix(p_o30027_gradient_0_col, p_o30027_gradient_1_col, ((x-p_o30027_gradient_0_pos)/(p_o30027_gradient_1_pos-p_o30027_gradient_0_pos)));
  }
  return p_o30027_gradient_1_col;
}
const float p_o30024_translate_x = 0.000000000;
const float p_o30024_translate_y = -0.090250000;
const float p_o30024_rotate = 0.000000000;
const float p_o30024_scale_x = 1.000000000;
const float p_o30024_scale_y = 1.000000000;
const float p_o30025_default_in1 = 0.000000000;
const float p_o30025_default_in2 = 0.000000000;
const float p_o30026_sides = 6.000000000;
const float p_o30026_radius = 1.470000000;
const float p_o30026_edge = 1.000000000;
const float p_o29999_translate_x = 0.000000000;
const float p_o29999_translate_y = 0.000000000;
const float p_o29999_rotate = 0.000000000;
const float p_o29999_scale_x = 1.000000000;
const float p_o29999_scale_y = 1.000000000;
const float p_o30202_min = 1.000000000;
const float p_o30202_max = 0.901900000;
const float p_o30202_step = 0.000000000;
const float seed_o30201 = 0.000000000;
const float p_o30201_sx = 1.000000000;
const float p_o30201_sy = 1.000000000;
const float p_o30201_rotate = 0.000000000;
const float p_o30201_scale = 0.000000000;
const float seed_o30203 = 0.000000000;
const float p_o30203_scale_x = 15.000000000;
const float p_o30203_scale_y = 15.000000000;
const float p_o30203_folds = 0.000000000;
const float p_o30203_iterations = 5.000000000;
const float p_o30203_persistence = 0.700000000;
const float p_o30203_offset = 0.000000000;
vec4 o30201_input_in(vec2 uv, float _seed_variation_) {
float o30203_0_1_f = fbm_2d_voronoise((uv), vec2(p_o30203_scale_x, p_o30203_scale_y), int(p_o30203_folds), int(p_o30203_iterations), p_o30203_persistence, p_o30203_offset, (seed_o30203+fract(_seed_variation_)));
return vec4(vec3(o30203_0_1_f), 1.0);
}
const float p_o29966_amount1 = 1.000000000;
const float p_o29965_sides = 6.000000000;
const float p_o29965_radius = 0.670000000;
const float p_o29965_edge = 0.060000000;
const float p_o30000_gradient_0_pos = 0.000000000;
const vec4 p_o30000_gradient_0_col = vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000);
const float p_o30000_gradient_1_pos = 0.757868000;
const vec4 p_o30000_gradient_1_col = vec4(0.476684988, 0.536480010, 0.859375000, 1.000000000);
const float p_o30000_gradient_2_pos = 1.000000000;
const vec4 p_o30000_gradient_2_col = vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000);
vec4 o30000_gradient_gradient_fct(float x) {
  if (x < p_o30000_gradient_0_pos) {
    return p_o30000_gradient_0_col;
  } else if (x < p_o30000_gradient_1_pos) {
    return mix(mix(p_o30000_gradient_1_col, p_o30000_gradient_2_col, (x-p_o30000_gradient_1_pos)/(p_o30000_gradient_2_pos-p_o30000_gradient_1_pos)), mix(p_o30000_gradient_0_col, p_o30000_gradient_1_col, (x-p_o30000_gradient_0_pos)/(p_o30000_gradient_1_pos-p_o30000_gradient_0_pos)), 1.0-0.5*(x-p_o30000_gradient_0_pos)/(p_o30000_gradient_1_pos-p_o30000_gradient_0_pos));
  } else if (x < p_o30000_gradient_2_pos) {
    return mix(mix(p_o30000_gradient_0_col, p_o30000_gradient_1_col, (x-p_o30000_gradient_0_pos)/(p_o30000_gradient_1_pos-p_o30000_gradient_0_pos)), mix(p_o30000_gradient_1_col, p_o30000_gradient_2_col, (x-p_o30000_gradient_1_pos)/(p_o30000_gradient_2_pos-p_o30000_gradient_1_pos)), 0.5+0.5*(x-p_o30000_gradient_1_pos)/(p_o30000_gradient_2_pos-p_o30000_gradient_1_pos));
  }
  return p_o30000_gradient_2_col;
}
const float p_o29967_sides = 6.000000000;
const float p_o29967_radius = 0.540000000;
const float p_o29967_edge = 1.000000000;
const float p_o29974_amount1 = 1.000000000;
const float seed_o29970 = 0.267816782;
const float p_o29970_count = 50.000000000;
const float p_o29970_rings = 1.000000000;
const float p_o29970_scale_x = 1.000000000;
const float p_o29970_scale_y = 1.100000000;
const float p_o29970_radius = 0.000000000;
const float p_o29970_spiral = 0.000000000;
const float p_o29970_i_rotate = 1.000000000;
const float p_o29970_i_scale = 0.000000000;
const float p_o29970_rotate = 0.000000000;
const float p_o29970_scale = 0.000000000;
const float p_o29970_value = 2.000000000;
const float seed_o29998 = 0.000000000;
const float p_o29998_cx = 0.000000000;
const float p_o29998_cy = 0.000000000;
const float p_o30020_default_in1 = 0.000000000;
const float p_o30020_default_in2 = 0.000000000;
const float seed_o29783 = 0.723660052;
const float p_o29783_a = 4.000000000;
const float p_o29783_cx = 0.000000000;
const float p_o29783_cy = 0.000000000;
const float seed_o29784 = 0.327719808;
const float p_o29784_rotate = 0.000000000;
const float p_o29784_scale_x = 1.000000000;
const float p_o29784_scale_y = 1.000000000;
const float seed_o29785 = 0.543376327;
const float p_o29785_translate_x = 0.000000000;
const float p_o29785_rotate = 0.000000000;
const float p_o29785_scale_x = 0.400000000;
const float p_o29785_scale_y = 0.215000000;
const float p_o29786_value = 0.030000000;
const float p_o29786_width = 0.020000000;
float o29970_input_in(vec2 uv, float _seed_variation_) {
vec2 o29998_0_c = vec2(0.5+p_o29998_cx, 0.5+p_o29998_cy);vec2 o29783_0_co = vec2(p_o29783_cx+0.5,p_o29783_cy+0.5);
float o29783_0_f = dot(2.0*((rotate((uv)-o29998_0_c, (param_rnd(-360,360, (seed_o29998+fract(_seed_variation_))+34.841471)*elapsed_time*0.5)*0.01745329251)+o29998_0_c) - o29783_0_co),2.0*((rotate((uv)-o29998_0_c, (param_rnd(-360,360, (seed_o29998+fract(_seed_variation_))+34.841471)*elapsed_time*0.5)*0.01745329251)+o29998_0_c) - o29783_0_co));vec4 o29787_0 = textureLod(texture_3, transform2_clamp(transform2((fract(transform2((o29783_0_co-(o29783_0_co-(rotate((uv)-o29998_0_c, (param_rnd(-360,360, (seed_o29998+fract(_seed_variation_))+34.841471)*elapsed_time*0.5)*0.01745329251)+o29998_0_c))/(sqrt((param_rnd(.5,.7, (seed_o29783+fract(_seed_variation_))+0.841471))-o29783_0_f)*max(p_o29783_a,0.0)+1.0)), vec2(((elapsed_time*param_rnd(1.5,3.0, (seed_o29784+fract(_seed_variation_))+0.989358))+param_rnd(0,100, (seed_o29784+fract(_seed_variation_))+0.017702))*(2.0*1.0-1.0), (param_rnd(1.9,2.0, (seed_o29784+fract(_seed_variation_))+17.841471))*(2.0*1.0-1.0)), p_o29784_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29784_scale_x*(2.0*1.0-1.0), p_o29784_scale_y*(2.0*1.0-1.0))))), vec2(p_o29785_translate_x*(2.0*1.0-1.0), (param_rnd(.12,.15, (seed_o29785+fract(_seed_variation_))+17.841471))*(2.0*1.0-1.0)), p_o29785_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29785_scale_x*(2.0*1.0-1.0), p_o29785_scale_y*(2.0*1.0-1.0)))), 0.0);
vec4 o29785_0_1_rgba = o29787_0;
vec4 o29784_0_1_rgba = o29785_0_1_rgba;
vec4 o29787_1 = textureLod(texture_3, transform2_clamp(transform2((fract(transform2((rotate((uv)-o29998_0_c, (param_rnd(-360,360, (seed_o29998+fract(_seed_variation_))+34.841471)*elapsed_time*0.5)*0.01745329251)+o29998_0_c), vec2(((elapsed_time*param_rnd(1.5,3.0, (seed_o29784+fract(_seed_variation_))+0.989358))+param_rnd(0,100, (seed_o29784+fract(_seed_variation_))+0.017702))*(2.0*1.0-1.0), (param_rnd(1.9,2.0, (seed_o29784+fract(_seed_variation_))+17.841471))*(2.0*1.0-1.0)), p_o29784_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29784_scale_x*(2.0*1.0-1.0), p_o29784_scale_y*(2.0*1.0-1.0))))), vec2(p_o29785_translate_x*(2.0*1.0-1.0), (param_rnd(.12,.15, (seed_o29785+fract(_seed_variation_))+17.841471))*(2.0*1.0-1.0)), p_o29785_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29785_scale_x*(2.0*1.0-1.0), p_o29785_scale_y*(2.0*1.0-1.0)))), 0.0);
vec4 o29785_0_4_rgba = o29787_1;
vec4 o29784_0_4_rgba = o29785_0_4_rgba;
vec4 o29783_0_1_rgba = clamp(mix(o29784_0_1_rgba,o29784_0_4_rgba,step((param_rnd(.5,.7, (seed_o29783+fract(_seed_variation_))+0.841471)),o29783_0_f)),0.0,1.0);
float o29783_2_2_f = clamp((param_rnd(.5,.7, (seed_o29783+fract(_seed_variation_))+0.841471))-o29783_0_f,0.0,1.0);
vec3 o29786_0_false = clamp((vec4(vec3(o29783_2_2_f), 1.0).rgb-vec3(p_o29786_value))/max(0.0001, p_o29786_width)+vec3(0.5), vec3(0.0), vec3(1.0));
vec3 o29786_0_true = vec3(1.0)-o29786_0_false;vec4 o29786_0_1_rgba = vec4(o29786_0_false, vec4(vec3(o29783_2_2_f), 1.0).a);
float o30020_0_clamp_false = (dot((o29783_0_1_rgba).rgb, vec3(1.0))/3.0)*(dot((o29786_0_1_rgba).rgb, vec3(1.0))/3.0);
float o30020_0_clamp_true = clamp(o30020_0_clamp_false, 0.0, 1.0);
float o30020_0_1_f = o30020_0_clamp_false;
vec4 o29998_0_1_rgba = vec4(vec3(o30020_0_1_f), 1.0);
return (dot((o29998_0_1_rgba).rgb, vec3(1.0))/3.0);
}
float o29970_input_mask(vec2 uv, float _seed_variation_) {
return 1.0;
}
vec4 splatter_o29970(vec2 uv, int count, int rings, inout vec3 instance_uv, vec2 seed, float _seed_variation_) {
	float c = 0.0;
	vec3 rc = vec3(0.0);
	vec3 rc1;
	seed = rand2(seed);
	for (int i = 0; i < count; ++i) {
		float a = -1.57079632679+6.28318530718*float(i)*p_o29970_rings/float(count);
		float rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);
		float spiral_distance = float(i+1)/float(count);
		vec2 pos = p_o29970_radius*mix(rings_distance, spiral_distance, p_o29970_spiral)*vec2(cos(a), sin(a));
		float mask = o29970_input_mask(fract(pos-vec2(0.5)), _seed_variation_);
		if (mask > 0.01) {
			vec2 pv = uv-0.5-pos;
			rc1 = rand3(seed);
			seed = rand2(seed);
			float angle = (seed.x * 2.0 - 1.0) * p_o29970_rotate * 0.01745329251 + (a+1.57079632679) * p_o29970_i_rotate;
			float ca = cos(angle);
			float sa = sin(angle);
			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);
			pv /= mix(1.0, float(i+1)/float(count+1), p_o29970_i_scale);
			pv /= vec2(p_o29970_scale_x, p_o29970_scale_y);
			pv *= (seed.y-0.5)*2.0*p_o29970_scale+1.0;
			pv += vec2(0.5);
			seed = rand2(seed);
			if (pv != clamp(pv, vec2(0.0), vec2(1.0))) {
				continue;
			}
			vec2 full_uv = pv;
			pv = get_from_tileset( 1.0, seed.x, pv);
			float c1 = o29970_input_in(pv, true ? seed.x : 0.0)*mask*(1.0-p_o29970_value*seed.x);
			c = max(c, c1);
			rc = mix(rc, rc1, step(c, c1));
			instance_uv = mix(instance_uv, vec3(full_uv, seed.x), step(c, c1));
		}
	}
	return vec4(rc, c);
}
const vec4 p_o29969_color = vec4(0.000000000, 0.623529017, 1.000000000, 1.000000000);
const vec4 p_o29968_color = vec4(0.016330000, 0.019756000, 0.252748996, 1.000000000);
const vec4 p_o30017_color = vec4(0.133621007, 0.483781993, 0.492186993, 1.000000000);
const float p_o30016_default_in1 = 0.000000000;
const float p_o30016_default_in2 = 0.000000000;
const float p_o30015_value = 0.366900000;
const float p_o30015_width = 0.390000000;
const float p_o30015_contrast = -0.190000000;
const float p_o30014_sides = 6.000000000;
const float p_o30014_radius = 1.000000000;
const float p_o30014_edge = 1.000000000;
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);
vec4 o29859_0 = textureLod(texture_1, (transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29843_translate_x*(2.0*1.0-1.0), p_o29843_translate_y*(2.0*1.0-1.0)), p_o29843_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29843_scale_x*(2.0*1.0-1.0), p_o29843_scale_y*(2.0*1.0-1.0)))), 0.0);
float o29837_0_1_f = ((transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29843_translate_x*(2.0*1.0-1.0), p_o29843_translate_y*(2.0*1.0-1.0)), p_o29843_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29843_scale_x*(2.0*1.0-1.0), p_o29843_scale_y*(2.0*1.0-1.0)))).y);
vec4 o29792_0_1_rgba = o29792_gradient_gradient_fct(o29837_0_1_f);
float o29806_0_r = 0.5+(cos(p_o29806_rotate*0.01745329251)*((transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29843_translate_x*(2.0*1.0-1.0), p_o29843_translate_y*(2.0*1.0-1.0)), p_o29843_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29843_scale_x*(2.0*1.0-1.0), p_o29843_scale_y*(2.0*1.0-1.0)))).x-0.5)+sin(p_o29806_rotate*0.01745329251)*((transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29843_translate_x*(2.0*1.0-1.0), p_o29843_translate_y*(2.0*1.0-1.0)), p_o29843_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29843_scale_x*(2.0*1.0-1.0), p_o29843_scale_y*(2.0*1.0-1.0)))).y-0.5))/(cos(abs(mod(p_o29806_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);vec4 o29806_0_1_rgba = o29806_gradient_gradient_fct(fract(o29806_0_r*p_o29806_repeat));
float o29805_0_clamp_false = (dot((o29806_0_1_rgba).rgb, vec3(1.0))/3.0)+p_o29805_default_in2;
float o29805_0_clamp_true = clamp(o29805_0_clamp_false, 0.0, 1.0);
float o29805_0_2_f = o29805_0_clamp_false;
float o29833_0_clamp_false = o29805_0_2_f*p_o29833_default_in2;
float o29833_0_clamp_true = clamp(o29833_0_clamp_false, 0.0, 1.0);
float o29833_0_2_f = o29833_0_clamp_false;
float o29834_0_clamp_false = o29833_0_2_f+p_o29834_default_in2;
float o29834_0_clamp_true = clamp(o29834_0_clamp_false, 0.0, 1.0);
float o29834_0_2_f = o29834_0_clamp_false;
float o29836_0_clamp_false = pow(o29834_0_2_f,p_o29836_default_in2);
float o29836_0_clamp_true = clamp(o29836_0_clamp_false, 0.0, 1.0);
float o29836_0_2_f = o29836_0_clamp_true;
float o29839_0_clamp_false = smoothstep(0.0, 1.0, o29836_0_2_f);
float o29839_0_clamp_true = clamp(o29839_0_clamp_false, 0.0, 1.0);
float o29839_0_1_f = o29839_0_clamp_false;
vec4 o29842_0_b = o29859_0;
vec4 o29842_0_l;
float o29842_0_a;

o29842_0_l = o29792_0_1_rgba;
o29842_0_a = p_o29842_amount1*o29839_0_1_f;
o29842_0_b = vec4(blend_normal((transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29843_translate_x*(2.0*1.0-1.0), p_o29843_translate_y*(2.0*1.0-1.0)), p_o29843_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29843_scale_x*(2.0*1.0-1.0), p_o29843_scale_y*(2.0*1.0-1.0)))), o29842_0_l.rgb, o29842_0_b.rgb, o29842_0_a*o29842_0_l.a), min(1.0, o29842_0_b.a+o29842_0_a*o29842_0_l.a));

vec4 o29842_0_1_rgba = o29842_0_b;
vec4 o29843_0_1_rgba = o29842_0_1_rgba;
float o29790_0_1_f = p_o29790_color;
float o29838_0_1_f = shape_circle((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), p_o29838_sides, p_o29838_radius*1.0, p_o29838_edge*1.0);
float o29840_0_clamp_false = smoothstep(0.0, 1.0, o29838_0_1_f);
float o29840_0_clamp_true = clamp(o29840_0_clamp_false, 0.0, 1.0);
float o29840_0_1_f = o29840_0_clamp_false;
vec4 o29791_0_1_rgba = vec4(vec3(1.0)-vec4(vec3(o29840_0_1_f), 1.0).rgb, vec4(vec3(o29840_0_1_f), 1.0).a);
vec4 o29841_0_b = o29843_0_1_rgba;
vec4 o29841_0_l;
float o29841_0_a;

o29841_0_l = vec4(vec3(o29790_0_1_f), 1.0);
o29841_0_a = p_o29841_amount1*(dot((o29791_0_1_rgba).rgb, vec3(1.0))/3.0);
o29841_0_b = vec4(blend_normal((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29841_0_l.rgb, o29841_0_b.rgb, o29841_0_a*o29841_0_l.a), min(1.0, o29841_0_b.a+o29841_0_a*o29841_0_l.a));

vec4 o29841_0_1_rgba = o29841_0_b;
vec4 o30019_0_1_rgba = p_o30019_color;
float o30027_0_r = 0.5+(cos(p_o30027_rotate*0.01745329251)*(((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y)))-vec2(p_o30041_translate_x, p_o30041_translate_y)).x-0.5)+sin(p_o30027_rotate*0.01745329251)*(((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y)))-vec2(p_o30041_translate_x, p_o30041_translate_y)).y-0.5))/(cos(abs(mod(p_o30027_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);vec4 o30027_0_1_rgba = o30027_gradient_gradient_fct(fract(o30027_0_r*p_o30027_repeat));
float o30023_0_x = (dot((o30027_0_1_rgba).rgb, vec3(1.0))/3.0)*(p_o30023_max-p_o30023_min);float o30023_0_1_f = p_o30023_min+o30023_0_x-mod(o30023_0_x, max(p_o30023_step, 0.00000001));
float o30026_0_1_f = shape_circle((transform2((transform2(((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y)))-vec2(p_o30041_translate_x, p_o30041_translate_y)), vec2(p_o30040_translate_x*(2.0*1.0-1.0), p_o30040_translate_y*(2.0*1.0-1.0)), p_o30040_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o30040_scale_x*(2.0*o30023_0_1_f-1.0), p_o30040_scale_y*(2.0*o30023_0_1_f-1.0)))), vec2(p_o30024_translate_x*(2.0*1.0-1.0), p_o30024_translate_y*(2.0*1.0-1.0)), p_o30024_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o30024_scale_x*(2.0*1.0-1.0), p_o30024_scale_y*(2.0*1.0-1.0)))), p_o30026_sides, p_o30026_radius*1.0, p_o30026_edge*1.0);
float o30025_0_clamp_false = smoothstep(0.0, 1.0, o30026_0_1_f);
float o30025_0_clamp_true = clamp(o30025_0_clamp_false, 0.0, 1.0);
float o30025_0_1_f = o30025_0_clamp_false;
vec4 o30024_0_1_rgba = vec4(vec3(o30025_0_1_f), 1.0);
vec4 o30040_0_1_rgba = o30024_0_1_rgba;
vec4 o30041_0_1_rgba = o30040_0_1_rgba;
vec4 o30018_0_b = o29841_0_1_rgba;
vec4 o30018_0_l;
float o30018_0_a;

o30018_0_l = o30019_0_1_rgba;
o30018_0_a = p_o30018_amount1*(dot((o30041_0_1_rgba).rgb, vec3(1.0))/3.0);
o30018_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o30018_0_l.rgb, o30018_0_b.rgb, o30018_0_a*o30018_0_l.a), min(1.0, o30018_0_b.a+o30018_0_a*o30018_0_l.a));

vec4 o30018_0_1_rgba = o30018_0_b;
float o30200_0_1_f = (fract(elapsed_time));
vec3 o30201_0_map = vec3(o30200_0_1_f);
float o30201_0_rnd =  float((seed_o30201+fract(_seed_variation_)))+o30201_0_map.z;
vec4 o30201_0_1_rgba = o30201_input_in(get_from_tileset(1.0, o30201_0_rnd, custom_uv_transform(o30201_0_map.xy, vec2(p_o30201_sx, p_o30201_sy), p_o30201_rotate*0.01745329251, p_o30201_scale, vec2(o30201_0_map.z, float((seed_o30201+fract(_seed_variation_)))))), false ? o30201_0_rnd : 0.0);
float o30202_0_x = (dot((o30201_0_1_rgba).rgb, vec3(1.0))/3.0)*(p_o30202_max-p_o30202_min);float o30202_0_1_f = p_o30202_min+o30202_0_x-mod(o30202_0_x, max(p_o30202_step, 0.00000001));
float o29965_0_1_f = shape_circle((transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0))))), p_o29965_sides, p_o29965_radius*1.0, p_o29965_edge*1.0);
float o29967_0_1_f = shape_circle((transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0))))), p_o29967_sides, p_o29967_radius*1.0, p_o29967_edge*1.0);
vec4 o30000_0_1_rgba = o30000_gradient_gradient_fct(o29967_0_1_f);
vec4 o29966_0_b = vec4(vec3(o29965_0_1_f), 1.0);
vec4 o29966_0_l;
float o29966_0_a;

o29966_0_l = o30000_0_1_rgba;
o29966_0_a = p_o29966_amount1*1.0;
o29966_0_b = vec4(blend_multiply((transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0))))), o29966_0_l.rgb, o29966_0_b.rgb, o29966_0_a*o29966_0_l.a), min(1.0, o29966_0_b.a+o29966_0_a*o29966_0_l.a));

vec4 o29966_0_2_rgba = o29966_0_b;
vec4 o29999_0_1_rgba = o29966_0_2_rgba;
float o29965_0_4_f = shape_circle((transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0))))), p_o29965_sides, p_o29965_radius*1.0, p_o29965_edge*1.0);
vec4 o29999_2_3_rgba = vec4(vec3(o29965_0_4_f), 1.0);
vec3 o29970_0_instance_uv = vec3(0.0);
vec4 o29970_0_rch = splatter_o29970((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), int(p_o29970_count), int(p_o29970_rings), o29970_0_instance_uv, vec2(float((seed_o29970+fract(_seed_variation_)))), _seed_variation_);float o29970_0_1_f = o29970_0_rch.a;
vec4 o29969_0_1_rgba = p_o29969_color;
vec4 o29974_0_b = vec4(vec3(o29970_0_1_f), 1.0);
vec4 o29974_0_l;
float o29974_0_a;

o29974_0_l = o29969_0_1_rgba;
o29974_0_a = p_o29974_amount1*o29970_0_1_f;
o29974_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29974_0_l.rgb, o29974_0_b.rgb, o29974_0_a*o29974_0_l.a), min(1.0, o29974_0_b.a+o29974_0_a*o29974_0_l.a));

vec4 o29974_0_1_rgba = o29974_0_b;
vec4 o29968_0_1_rgba = p_o29968_color;
vec4 o30091_0 = textureLod(texture_2, transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0)))), 0.0);
vec4 o29999_1_4_rgba = o30091_0;
vec4 o30017_0_1_rgba = p_o30017_color;
float o30014_0_1_f = shape_circle((transform2_clamp(transform2((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), vec2(p_o29999_translate_x*(2.0*1.0-1.0), p_o29999_translate_y*(2.0*1.0-1.0)), p_o29999_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o29999_scale_x*(2.0*o30202_0_1_f-1.0), p_o29999_scale_y*(2.0*o30202_0_1_f-1.0))))), p_o30014_sides, p_o30014_radius*1.0, p_o30014_edge*1.0);
float o30015_0_step = clamp((o30014_0_1_f - (p_o30015_value))/max(0.0001, p_o30015_width)+0.5, 0.0, 1.0);
float o30015_0_false = clamp((min(o30015_0_step, 1.0-o30015_0_step) * 2.0) / (1.0 - p_o30015_contrast), 0.0, 1.0);
float o30015_0_true = 1.0-o30015_0_false;float o30015_0_1_f = o30015_0_false;
float o30016_0_clamp_false = smoothstep(0.0, 1.0, o30015_0_1_f);
float o30016_0_clamp_true = clamp(o30016_0_clamp_false, 0.0, 1.0);
float o30016_0_1_f = o30016_0_clamp_false;
vec4 o29999_3_5_rgba = vec4(vec3(o30016_0_1_f), 1.0);
vec4 o29964_0_b = o30018_0_1_rgba;
vec4 o29964_0_l;
float o29964_0_a;

o29964_0_l = o29999_0_1_rgba;
o29964_0_a = p_o29964_amount1*(dot((o29999_2_3_rgba).rgb, vec3(1.0))/3.0);
o29964_0_b = vec4(blend_normal((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29964_0_l.rgb, o29964_0_b.rgb, o29964_0_a*o29964_0_l.a), min(1.0, o29964_0_b.a+o29964_0_a*o29964_0_l.a));

o29964_0_l = o29974_0_1_rgba;
o29964_0_a = p_o29964_amount2*1.0;
o29964_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29964_0_l.rgb, o29964_0_b.rgb, o29964_0_a*o29964_0_l.a), min(1.0, o29964_0_b.a+o29964_0_a*o29964_0_l.a));

o29964_0_l = o29968_0_1_rgba;
o29964_0_a = p_o29964_amount3*(dot((o29999_1_4_rgba).rgb, vec3(1.0))/3.0);
o29964_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29964_0_l.rgb, o29964_0_b.rgb, o29964_0_a*o29964_0_l.a), min(1.0, o29964_0_b.a+o29964_0_a*o29964_0_l.a));

o29964_0_l = o30017_0_1_rgba;
o29964_0_a = p_o29964_amount4*(dot((o29999_3_5_rgba).rgb, vec3(1.0))/3.0);
o29964_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o30204_cx, 0.5+p_o30204_cy), vec2(p_o30204_scale_x, p_o30204_scale_y))), o29964_0_l.rgb, o29964_0_b.rgb, o29964_0_a*o29964_0_l.a), min(1.0, o29964_0_b.a+o29964_0_a*o29964_0_l.a));

vec4 o29964_0_2_rgba = o29964_0_b;
vec4 o30204_0_1_rgba = o29964_0_2_rgba;

	vec4 color_tex = o30204_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	ALBEDO = color_tex.rgb;
	//ALPHA = color_tex.a;
	ALPHA = (color_tex.r+color_tex.g+color_tex.b)/3.;

}



