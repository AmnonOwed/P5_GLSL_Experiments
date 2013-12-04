
#version 150

layout(triangles) in;
layout(triangle_strip) out;
layout(max_vertices = 3) out;

uniform float strength;

in vec4 colorV[3];
out vec4 colorG;

void main() {
  vec3 ab = gl_in[1].gl_Position.xyz - gl_in[0].gl_Position.xyz;
  vec3 ac = gl_in[2].gl_Position.xyz - gl_in[0].gl_Position.xyz;
  vec3 faceNormal = normalize(cross(ab, ac));

  for(int i=0; i<gl_in.length; i++) {
    gl_Position = gl_in[i].gl_Position + strength * vec4(faceNormal, 0.0);
    colorG = colorV[i];
    EmitVertex();
  }
  EndPrimitive();
}
