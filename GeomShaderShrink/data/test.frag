
#version 150

#define PROCESSING_COLOR_SHADER

in vec4 colorG;

void main() {
  gl_FragColor = colorG;
}
