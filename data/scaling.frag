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

// Swirl effect parameters
uniform float radius;// = 200.0;
uniform float angle;// = 0.8;
uniform vec2 center;

vec2 swirl(vec2 uv) {
  vec2 texSize = vec2(rt_w, rt_h);
  vec2 tc = uv * texSize;
  tc -= center;
  float dist = length(tc);
  if (dist < radius) 
  {
    float percent = (radius - dist) / radius;
    float theta = percent * percent * angle * 8.0;
    float s = sin(theta);
    float c = cos(theta);
    tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
  }
  tc += center;
  return tc / texSize;
}

void main() {
	vec2 uv = swirl(vertTexCoord.st);
    int si = int(uv.x * pixelSize.s);
    int sj = int(uv.y * pixelSize.t); 
    gl_FragColor = texture2D(texture, vec2(float(si) / pixelSize.s, float(sj) / pixelSize.t) + pixelOffset) * vertColor;
}
