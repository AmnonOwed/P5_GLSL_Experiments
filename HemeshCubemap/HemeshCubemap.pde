
/*

 Hemesh Cubemap by Amnon Owed (May 2013)
 https://github.com/AmnonOwed
 http://vimeo.com/amnon
 
 Based on the GLSL Spherical Harmonics Cubemap example
 by Julien 'v3ga' Gachadoat :: twitter.com/v3ga
 for the Processing Paris Masterclass 2013
 
 CubeMap by Emil 'Humus' Persson
 Get more here: http://www.humus.name/index.php?page=Textures
 Unzip them in the /data/cubemaps folder and use the folder name in the loadCubeMap() method

 Convert any HE_Mesh to a GLGraphics' GLModel.
 Apply an environment cubeMap GLSL shader to it.
 
 HORIZONTAL MOUSE MOVE = determine zoom/scale level
 MOUSE PRESS = toggle black or white background
 
 Built with Processing 1.5.1 + GLGraphics 1.0.0 + HE_Mesh 1.81

*/

import processing.opengl.*; // import the OpenGL core library
import codeanticode.glgraphics.*; // import the GLGraphics library
import javax.media.opengl.*; // import the Java OpenGL (JOGL) library to enable direct OpenGL calls

// Default HE_Mesh library 1.81 imports
import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

GLGraphics renderer; // the main GLGraphics renderer
GLModel glmodel; // GLModel to hold the geometry
GLSLShader shader; // shader for the environment cubeMap

boolean toggleBW; // toggle black or white background

void setup() {
  size(1280, 720, GLConstants.GLGRAPHICS); // use the GLGraphics renderer
  renderer = (GLGraphics) g; // create a hook to the main renderer
  HE_Mesh mesh = createHemesh(2); // create the HE_Mesh with the specified level of subdivision
  glmodel = getHemeshAsGLModel(mesh); // convert any HE_Mesh to a GLModel (only vertices and normals!)
  loadCubeMap("NissiBeach2"); // load the cubeMap from the specified folder
  shader = new GLSLShader(this, "cubemap.vert", "cubemap.frag"); // load cubeMap shader
}

void draw() {
  renderer.beginGL(); // place draw calls between the begin/endGL() calls
  background(toggleBW?255:0); // toggle black or white background
  camera(sin(frameCount*0.01)*width, cos(frameCount*0.01)*height, height/1.16, 100, 0, 0, 0, 1, 0); // flying camera
  scale(map(mouseX, 0, width, 1, 4)); // determine zoom/scale level by horizontal mouse position
  shader.start(); // start using the cubeMap shader
  renderer.model(glmodel); // render the GLModel
  translate(200, 0, 0); // translate over the X
  rotateX(HALF_PI); // rotate by 90 degrees
  renderer.model(glmodel); // render the same GLModel again!
  shader.stop(); // stop using the cubeMap shader
  renderer.endGL(); // place draw calls between the begin/endGL() calls
  frame.setTitle(int(frameRate) + " fps"); // display the fps in the top-left of the window
}

void mousePressed() {
  toggleBW = !toggleBW; // toggle black of white background
}

// create HE_Mesh with the specified level of subdivision
// this is just one example, it could be any customized HE_Mesh
HE_Mesh createHemesh(int subdivisionLevel) {
  HEC_SuperDuper sd = new HEC_SuperDuper();
  sd.setU(16).setV(8).setRadius(80);
  sd.setDonutParameters(0, 10, 10, 10, 3, 6, 12, 12, 3, 4);
  HE_Mesh mesh = new HE_Mesh(sd); // SuperDuper HE_Mesh
  mesh.subdivide(new HES_CatmullClark(), subdivisionLevel); // subdivide HE_Mesh
  return mesh;
}

// general purpose method to convert any HE_Mesh to a GLModel (only vertices and normals!)
GLModel getHemeshAsGLModel(HE_Mesh mesh) {
  ArrayList <PVector> verts = new ArrayList <PVector> (); // arrayList to hold the vertices
  ArrayList <PVector> norms = new ArrayList <PVector> (); // arrayList to hold the normals

  mesh.triangulate(); // important! we use a TRIANGLES-based GLModel, so we need triangle-faces from HE_Mesh

  int[][] facesHemesh = mesh.getFacesAsInt(); // get 3 vertex indices per face
  float[][] verticesHemesh = mesh.getVerticesAsFloat(); // get 3 floats per vertex
  WB_Normal3d[] normalsHemesh = mesh.getVertexNormals(); // get the normal of each vertex

  // for each face
  for (int i=0; i<facesHemesh.length; i++) {
    // for each vertex in the face
    for (int j=0; j<3; j++) {
      // get the vertex index
      int index = facesHemesh[i][j];
      // get the vertex from the list of vertices
      float[] vertexHemesh = verticesHemesh[index];
      // get the normal from the list of normals
      WB_Normal3d  normalHemesh = normalsHemesh[index];
      // add the vertex to the arrayList
      verts.add( new PVector(vertexHemesh[0], vertexHemesh[1], vertexHemesh[2]) );
      // add the normal to the arrayList
      norms.add( new PVector(normalHemesh.xf(), normalHemesh.yf(), normalHemesh.zf()) );
    }
  }

  // create GLModel with the correct size, of type TRIANGLES and make it static (the vertices don't change)
  GLModel glmodel = new GLModel(this, verts.size(), TRIANGLES, GLModel.STATIC);

  glmodel.updateVertices(verts); // put the arrayList of vertices into the mesh

  // initialize normals for the GLModel and put the arrayList of normals into the mesh
  glmodel.initNormals();
  glmodel.updateNormals(norms);

  // done! return the HE_Mesh converted GLModel
  return glmodel;
}

// convenience method to load and set a six-image cubeMap from the /data/cubemaps/cubemapName folder
void loadCubeMap(String cubemapName) {
  GL gl = renderer.gl;
  int[] glTextureId = { 0 };

  // these are the default names used for every cubeMap from www.humus.name/index.php?page=Textures
  String[] textureNames = { "posx.jpg", "negx.jpg", "posy.jpg", "negy.jpg", "posz.jpg", "negz.jpg" };
  // load the GLTextures
  GLTexture[] textures = new GLTexture[textureNames.length];
  for (int i=0; i<textures.length; i++) {
    textures[i] = new GLTexture(this, "cubemaps/" + cubemapName + "/" + textureNames[i]);
  }

  // create the OpenGL-based cubeMap
  gl.glGenTextures(1, glTextureId, 0);
  gl.glBindTexture(GL.GL_TEXTURE_CUBE_MAP, glTextureId[0]);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_S, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_T, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_WRAP_R, GL.GL_CLAMP_TO_EDGE);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MIN_FILTER, GL.GL_LINEAR);
  gl.glTexParameteri(GL.GL_TEXTURE_CUBE_MAP, GL.GL_TEXTURE_MAG_FILTER, GL.GL_LINEAR);

  // put the textures in the cubeMap
  for (int i=0; i<textures.length; i++) {
    int w = textures[i].width;
    int h = textures[i].height;
    int[] pix = new int[w * h];
    textures[i].getBuffer(pix, ARGB, GLConstants.TEX_BYTE);
    gl.glTexImage2D(GL.GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, GL.GL_RGBA, w, h, 0, GL.GL_RGBA, GL.GL_UNSIGNED_BYTE, java.nio.IntBuffer.wrap(pix));
  }
}

