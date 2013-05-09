uniform samplerCube texCubeMap;

void main() {
	gl_FragColor = textureCube(texCubeMap, gl_TexCoord[0].xyz);
}