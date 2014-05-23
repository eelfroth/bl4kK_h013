#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
uniform sampler2D texture;
uniform vec2 pixelSize;
uniform vec2 pixelOffset;
 
varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float rt_w; 
uniform float rt_h; 
uniform float time;

// Swirl effect parameters
uniform float radius;// = 200.0;
uniform float angle;// = 0.8;
uniform vec2 center;

float power(float a, int b) {
	
}

vec2 swirl(vec2 uv) {
  vec2 texSize = vec2(rt_w, rt_h);
  vec2 tc = uv * texSize;
  tc -= center;
  float dist = length(tc);
  if (dist < radius) 
  {
    float percent = (radius-dist) / radius;
    float theta = pow(percent, 16.0) * angle * 8.0;
    float s = sin(theta + time);
    float c = cos(theta + time);
    tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
  }
  tc += center;
  return tc / texSize;
}

void main() {
	vec2 uv = swirl(vertTexCoord.st);
//	vec2 uv = vertTexCoord.st;
    int si = int(uv.x * pixelSize.s);
    int sj = int(uv.y * pixelSize.t); 
    gl_FragColor = texture2D(texture, vec2(float(si) / pixelSize.s, float(sj) / pixelSize.t) + pixelOffset) * vertColor;
}
