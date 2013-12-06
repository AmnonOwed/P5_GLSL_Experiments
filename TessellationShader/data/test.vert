
#version 430 core

in vec4 vertex;
out vec3 vPosition;

void main() {
	vPosition = vertex.xyz;
}
