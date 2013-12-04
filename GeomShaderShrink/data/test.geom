
#version 150

layout(triangles) in;
layout(triangle_strip) out;
layout(max_vertices = 3) out;

uniform float strength;

in vec4 colorV[3];
out vec4 colorG;

void main() {
  vec4 center;
  for(int i=0; i<gl_in.length; i++) {
	center += gl_in[i].gl_Position;
  }
  center /= gl_in.length;
  

  for(int i=0; i<gl_in.length; i++) {
    gl_Position = strength * gl_in[i].gl_Position + (1.0-strength) * center;
    colorG = colorV[i];
    EmitVertex();
  }
  EndPrimitive();
}
