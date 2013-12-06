
/*
  Tessellation Shader experiment by Amnon Owed (06.12.2013)
  https://github.com/AmnonOwed
  http://vimeo.com/amnon
  
  Trying to get tessellation shaders to work in Processing 2.1, based on the example code from http://prideout.net/blog/?p=48
  
  The shaders are correctly loaded and compiled, but still not working :(

  I don't get an exception, but a non-descript error message: OpenGL error 1282 at top endDraw(): invalid operation
  
  Possible causes:
  - Geometry is not drawn using primitive type GL_PATCHES  
  - ???
  
  Anybody got suggestions on how to fix this?

  Built with Processing 2.1 / Requires OpenGL 4.0+
*/

PShader shader;
PShape shape;

void setup() {
  size(600, 600, P3D);
  smooth(8);
  shader = new PShaderCustom(this, "test");
  shader.set("TessLevelInner", 3);
  shader.set("TessLevelOuter", 2);
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

  shape(shape);
}  

