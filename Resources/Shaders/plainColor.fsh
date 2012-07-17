precision mediump float;
precision lowp int;
uniform sampler2D		u_map;
varying vec2			v_texCoord;
varying vec4            v_vertexColor; 

void main (void)
{
    gl_FragColor = v_vertexColor;
}