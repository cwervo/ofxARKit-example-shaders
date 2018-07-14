attribute vec4 position;
attribute vec4 color;
attribute vec4 normal;
attribute vec2 texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main(){
    
    //get our current vertex position so we can modify it
    vec4 pos = projectionMatrix * modelViewMatrix * position;
    gl_Position = pos;
}
