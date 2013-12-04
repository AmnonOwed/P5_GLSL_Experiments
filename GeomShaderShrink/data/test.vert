
#version 330

uniform mat4 transform;
uniform mat3 normalMatrix;

attribute vec4 vertex;
attribute vec3 normal;

out vec4 colorV;

void main() {
  gl_Position = transform * vertex;
  colorV = vec4(normalize(normalMatrix * normal), 1.0);
}
