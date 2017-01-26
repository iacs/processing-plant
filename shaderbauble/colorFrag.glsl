#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// #extension GL_OES_standard_derivatives : enable

uniform mat4 transform;
uniform vec2 resolution;

attribute vec4 position;
attribute vec4 color;

varying vec4 vertColor;

uniform float time;
uniform vec2 resolution;

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

mat2 m = mat2(0.8, 0.6, -0.6, 0.8);

float fbm(vec2 p) {
    float f = 0.0;
    f += 0.500 * noise(p); p *=m*2.02;
    f += 0.250 * noise(p); p *=m*2.03;
    f += 0.125 * noise(p); p *=m*2.01;
    f += 0.0625 * noise(p); p *=m*2.04;
    f /= 0.9375;
    return f;
}

void main( void ) {

    vec2 q = gl_FragCoord.xy/resolution.xy;
        vec2 p = -1.0 + 2.0 * q;
    // Correct aspect ratio
    p.x *= resolution.x/resolution.y;
    
        //float f = fbm(4.0*p);
    float r = sqrt(dot(p,p));
    float a = atan(p.y, p.x);
    
        vec3 c = vec3(1.0);
    
    if (r<0.8) {
        c = vec3(0.2, 0.3, 0.4);
        
        float f = fbm(5.0*p);
        c = mix(c, vec3(0.2,0.5,0.4), f);
        
        f = 1.0 - smoothstep(0.2, 0.5, r);
        c = mix(c, vec3(0.9, 0.4,0.2), f);
        
        //deform angle distortion
        a += 0.8*sin(time*0.2) * fbm(15.0*p);
        
        //f = fbm(vec2(6.0* r, 20.0* a));
        f = smoothstep( 0.3, 0.6, fbm(vec2(6.0* r, 20.0* a)));
        c = mix(c, vec3(0.8, 0.3, 0.1), f);
        
        //f = smoothstep(0.4, 0.9, fbm(vec2(8.0*r, 10.0*a)));
        //c *= 1.0 - f;
        
        f = smoothstep(0.79, 0.8, r);
        c *= 1.0 -0.7*f ;
        
        // label?
        //f = smoothstep(0.2, 0.3, r);
        f = smoothstep(0.34, 0.35, r);
        c *= f;
    }
    
    
    gl_FragColor = vec4(c, 1.0);

}