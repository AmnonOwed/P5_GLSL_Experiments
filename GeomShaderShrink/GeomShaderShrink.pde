
/*
  Geometry Shader Shrink by Amnon Owed (04.12.2013)
  https://github.com/AmnonOwed
  http://vimeo.com/amnon
  
  Triangle vertices are translated towards the center of the triangle (strength range 0 to 1 based on the mouseX position)

  Built with Processing 2.1
*/

PShader shader;
PShape shape;

void setup() {
  size(600, 600, P3D);
  smooth(8);
  shader = new PShaderCustom(this, "test");
  shader(shader);
  shape = createIcosahedron();
}

void draw() {
  background(255);
  perspective(PI/3.0, (float) width/height, 1, 1000000);
  translate(width/2, height/2, -200);
  rotateY(frameCount*0.01);
  rotateZ(frameCount*0.005);
  scale(150);

  shader.set("strength", float(mouseX) / width);

  shape(shape);
}  

