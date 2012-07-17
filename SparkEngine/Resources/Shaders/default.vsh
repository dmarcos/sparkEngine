precision mediump float;
precision lowp int;

uniform mat4			u_mvpMatrix;
attribute highp vec4	a_vertex;
attribute vec2			a_texCoord;
varying vec2			v_texCoord;
varying vec4            v_vertexColor; 
attribute vec4 a_vertexColor;

void main(void)
{
    v_texCoord = a_texCoord;
    gl_Position = u_mvpMatrix * a_vertex;
    v_vertexColor = a_vertexColor;
}