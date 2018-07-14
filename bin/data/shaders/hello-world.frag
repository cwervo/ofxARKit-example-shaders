#ifdef GL_ES
// define default precision for float, vec, mat.
precision highp float;
#endif

//uniform sampler2D src_tex_unit0;
//uniform float useTexture;
//uniform float useColors;
//uniform vec4 globalColor;

// Variables injected by OpenFrameworks:
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat4 textureMatrix;
uniform vec4 globalColor;

//varying float depth;
//varying vec4 colorVarying;
//varying vec2 texCoordVarying;

uniform vec2 u_resolution;
uniform vec3 u_mouse;
uniform float u_time;

void main(){
    vec2 st = gl_FragCoord.st/u_resolution;
    gl_FragColor = vec4(st.x,st.y,abs(sin(u_time * 0.1)),1.0);
}
