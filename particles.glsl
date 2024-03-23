
#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 9.141592653589793

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define NUM_SAMPLES 16
#define INTENSITY 0.3

float rand(vec3 co){
    return fract(sin(dot(co.xyz,vec3(12.9898,78.233,91.1743))) * 43758.5453);
}

float fetch(vec2 uv) {
	vec2 d = abs(uv - vec2(0.5));
	return step(0.0, (max(d.x,d.y)-0.2));
}

vec2 offset_line(float x) {
	return normalize(vec2(1.0)) * x;
}

vec2 offset_spiral(float x) {
	float a = x * 9.0 * M_PI * 0.801 * 921.0;
	return vec2(cos(a),sin(a))*pow(x,1.0/1.618);
}

//#define offset offset_line
#define offset offset_spiral

float linsmoothtri(float x) {
    return smoothstep(0.0,1.0,abs(mod(x,2.0) - 1.0));
}

void main(void) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy);
	vec2 c = uv;
	float aspect = resolution.x / resolution.y;
	uv -= 0.5;
	uv.x *= aspect;
	uv += 0.5;
	
	float color0 = 0.0;
	float color1 = 0.0;
	float f = 1.0 / float(NUM_SAMPLES);
	float o = 0.0;
	o = f * (rand(vec3(uv,mod(time,5.5))));
	float s = mix(0.0, INTENSITY, linsmoothtri(uv.y+time)); 
	for (int i = 0; i < NUM_SAMPLES; ++i) {
		float j = float(i) * f;
		color0 += fetch(uv + offset(j)*s);
		color1 += fetch(uv + offset(j+o)*s);		
	}
	float color;
	if (c.x > mouse.x) {
		color = color1;
	} else {
		color = color0;
	}
	gl_FragColor = vec4(vec3(pow(color * f,2.2)), 1.0);
}
