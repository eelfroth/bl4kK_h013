#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
uniform sampler2D texture;
 
varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 texSize; 
uniform float time;
uniform float modulo;

vec2 swirl(vec2 uv, float time) {
  float radius = texSize.x;
  float angle = 0.8;
  vec2 center = texSize / 2.0;
  vec2 tc = uv * texSize;
  tc -= center;
  float dist = length(tc);
  if (dist < radius) 
  {
    float percent = (radius-dist) / radius;
    float theta = percent * angle * 8.0;
    float s = sin(theta + time);
    float c = cos(theta + time);
    float t = tan(theta/percent);
    tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
    tc = vec2(dot(tc, vec2(-t, -s)), dot(tc, vec2(s, -t)));
  }
  tc += center;
  return tc / texSize;
}

float mod(float a, float b) {
	return a/b - floor(a/b);
}

void main() {
	vec2 uv = swirl(vertTexCoord.st, time/5000.0);
//	vec2 uv = vertTexCoord.st;
//	vec2 texSize = vec2(rt_w, rt_h);
	vec4 color = vertColor;
	float m = mod(uv.x + uv.y*texSize.y + time, modulo);
	//if(m >= 0.1) {
		color = vec4(1.0, 1.0, 1.0, m);
	//}
	//color = vec4(1.0, 7.0, 1.0, 1.0);
    gl_FragColor = texture2D(texture, uv) * color;
}
