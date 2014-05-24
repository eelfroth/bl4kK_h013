#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
uniform sampler2D texture;
uniform vec2 pixelSize;
uniform vec2 pixelOffset;
 
varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	vec2 uv = vertTexCoord.st;
    int si = int(uv.x * pixelSize.s);
    int sj = int(uv.y * pixelSize.t); 
    gl_FragColor = texture2D(texture, vec2(float(si) / pixelSize.s, float(sj) / pixelSize.t) + pixelOffset) * vertColor;
}
