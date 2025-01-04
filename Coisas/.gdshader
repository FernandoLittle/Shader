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
vec2 rotate(vec2 uv, float rotate) {
 	vec2 rv;
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	return rv;
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
vec2 scale(vec2 uv, vec2 center, vec2 scale) {
	uv -= center;
	uv /= scale;
	uv += center;
	return uv;
}
const float p_o517350_translate_x = 0.000000000;
const float p_o517350_translate_y = 0.000000000;
const float p_o517350_rotate = 0.000000000;
const float p_o517350_scale_x = 2.135000000;
const float p_o517350_scale_y = 2.140000000;
const float p_o517349_cx = 0.000000000;
const float p_o517349_cy = 0.000000000;
const float p_o517349_scale_x = 5.570000000;
const float p_o517349_scale_y = 2.490000000;
const float seed_o517345 = 0.970748723;
const float p_o517345_count = 62.000000000;
const float p_o517345_rings = 1.000000000;
const float p_o517345_scale_x = 2.000000000;
const float p_o517345_scale_y = 0.090000000;
const float p_o517345_radius = 0.000000000;
const float p_o517345_spiral = 0.000000000;
const float p_o517345_i_rotate = 1.000000000;
const float p_o517345_i_scale = 0.000000000;
const float p_o517345_rotate = 0.000000000;
const float p_o517345_scale = 0.000000000;
const float p_o517345_value = 2.000000000;
const float seed_o517344 = 0.000000000;
const float p_o517344_cx = 0.000000000;
const float p_o517344_cy = 0.000000000;
const float seed_o517340 = 0.000000000;
const float p_o517340_rotate = 0.000000000;
const float p_o517340_scale_x = 1.000000000;
const float p_o517340_scale_y = 1.000000000;
const float p_o517339_translate_x = 0.000000000;
const float p_o517339_translate_y = 0.000000000;
const float p_o517339_rotate = 0.000000000;
const float p_o517339_scale_x = 0.165000000;
const float p_o517339_scale_y = 0.055000000;
float o517345_input_in(vec2 uv, float _seed_variation_) {
vec2 o517344_0_c = vec2(0.5+p_o517344_cx, 0.5+p_o517344_cy);vec4 o517337_0 = textureLod(texture_1, transform2_clamp(transform2((fract(transform2((rotate((uv)-o517344_0_c, ((elapsed_time*1.0)+param_rnd(-360.0,360.0, (seed_o517344+fract(_seed_variation_))+34.420167)*elapsed_time*0.2)*0.01745329251)+o517344_0_c), vec2(((elapsed_time*param_rnd(1.0,2.0, (seed_o517340+fract(_seed_variation_))+0.989358))*0.1)*(2.0*1.0-1.0), (param_rnd(1.9,2.0, (seed_o517340+fract(_seed_variation_))+17.841471))*(2.0*1.0-1.0)), p_o517340_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o517340_scale_x*(2.0*1.0-1.0), p_o517340_scale_y*(2.0*1.0-1.0))))), vec2(p_o517339_translate_x*(2.0*1.0-1.0), p_o517339_translate_y*(2.0*1.0-1.0)), p_o517339_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o517339_scale_x*(2.0*1.0-1.0), p_o517339_scale_y*(2.0*1.0-1.0)))), 0.0);
vec4 o517339_0_1_rgba = o517337_0;
vec4 o517340_0_1_rgba = o517339_0_1_rgba;
vec4 o517344_0_1_rgba = o517340_0_1_rgba;
return (dot((o517344_0_1_rgba).rgb, vec3(1.0))/3.0);
}
float o517345_input_mask(vec2 uv, float _seed_variation_) {
return 1.0;
}
vec4 splatter_o517345(vec2 uv, int count, int rings, inout vec3 instance_uv, vec2 seed, float _seed_variation_) {
	float c = 0.0;
	vec3 rc = vec3(0.0);
	vec3 rc1;
	seed = rand2(seed);
	for (int i = 0; i < count; ++i) {
		float a = -1.57079632679+6.28318530718*float(i)*p_o517345_rings/float(count);
		float rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);
		float spiral_distance = float(i+1)/float(count);
		vec2 pos = p_o517345_radius*mix(rings_distance, spiral_distance, p_o517345_spiral)*vec2(cos(a), sin(a));
		float mask = o517345_input_mask(fract(pos-vec2(0.5)), _seed_variation_);
		if (mask > 0.01) {
			vec2 pv = uv-0.5-pos;
			rc1 = rand3(seed);
			seed = rand2(seed);
			float angle = (seed.x * 2.0 - 1.0) * p_o517345_rotate * 0.01745329251 + (a+1.57079632679) * p_o517345_i_rotate;
			float ca = cos(angle);
			float sa = sin(angle);
			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);
			pv /= mix(1.0, float(i+1)/float(count+1), p_o517345_i_scale);
			pv /= vec2(p_o517345_scale_x, p_o517345_scale_y);
			pv *= (seed.y-0.5)*2.0*p_o517345_scale+1.0;
			pv += vec2(0.5);
			seed = rand2(seed);
			if (pv != clamp(pv, vec2(0.0), vec2(1.0))) {
				continue;
			}
			vec2 full_uv = pv;
			pv = get_from_tileset( 1.0, seed.x, pv);
			float c1 = o517345_input_in(pv, true ? seed.x : 0.0)*mask*(1.0-p_o517345_value*seed.x);
			c = max(c, c1);
			rc = mix(rc, rc1, step(c, c1));
			instance_uv = mix(instance_uv, vec3(full_uv, seed.x), step(c, c1));
		}
	}
	return vec4(rc, c);
}
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);
vec3 o517345_0_instance_uv = vec3(0.0);
vec4 o517345_0_rch = splatter_o517345((scale((fract(transform2((uv), vec2(p_o517350_translate_x*(2.0*1.0-1.0), p_o517350_translate_y*(2.0*1.0-1.0)), p_o517350_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o517350_scale_x*(2.0*1.0-1.0), p_o517350_scale_y*(2.0*1.0-1.0))))), vec2(0.5+p_o517349_cx, 0.5+p_o517349_cy), vec2(p_o517349_scale_x, p_o517349_scale_y))), int(p_o517345_count), int(p_o517345_rings), o517345_0_instance_uv, vec2(float((seed_o517345+fract(_seed_variation_)))), _seed_variation_);float o517345_0_1_f = o517345_0_rch.a;
vec4 o517349_0_1_rgba = vec4(vec3(o517345_0_1_f), 1.0);
vec4 o517350_0_1_rgba = o517349_0_1_rgba;

	vec4 color_tex = o517350_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	ALBEDO = color_tex.rgb*paleta;
	float stepo= step(0.01,color_tex.r);
	ALPHA = color_tex.a*stepo;

}



