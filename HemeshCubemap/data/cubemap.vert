
void main() {
    vec3 V = vec3(gl_ModelViewMatrix * gl_Vertex);
    vec3 N = normalize(gl_NormalMatrix * gl_Normal);
	gl_TexCoord[0].xyz = reflect(V, N);
    gl_Position = ftransform();
}