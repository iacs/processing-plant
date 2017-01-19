#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform mat4 transform;
uniform vec2 resolution;

attribute vec4 position;
attribute vec4 color;

varying vec4 vertColor;

float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

float noise(in vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    
    f = f*f*(3.0-2.0*f);
    
    float n = p.x + p.y*57.0;
    
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

void main() {
    vec2 q = gl_FragCoord.xy/resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    
    float f = noise(32.0*p);
    
    vec3 colorOut = vec3(f,f,f);
    
    gl_FragColor = vec4(colorOut, 1.0);
}