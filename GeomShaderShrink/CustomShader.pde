
import javax.media.opengl.GL3;

class PShaderCustom extends PShader {
  public int glGeometry;
  protected String geometryFilename;
  protected String[] geometryShaderSource;

  PShaderCustom(PApplet parent, String name) {
    super(parent, name + ".vert", name + ".frag");
    geometryFilename = name + ".geom";
    geometryShaderSource = loadStrings(geometryFilename);
  }

  @Override
  void setup() {
    if (hasGeometryShader()) {
      boolean geomRes = compileGeometryShader();
      if (geomRes) pgl.attachShader(glProgram, glGeometry);
    } else {
      PGraphics.showException("Doesn't have a geometry shader");
    }
  }

  protected boolean hasGeometryShader() {
    return geometryShaderSource != null && 0 < geometryShaderSource.length;
  }
  
  protected boolean compileGeometryShader() {
    glGeometry = pgl.createShader(GL3.GL_GEOMETRY_SHADER);

    pgl.shaderSource(glGeometry, join(geometryShaderSource, "\n"));
    pgl.compileShader(glGeometry);

    pgl.getShaderiv(glGeometry, PGL.COMPILE_STATUS, intBuffer);
    boolean compiled = intBuffer.get(0) == 0 ? false : true;
    if (!compiled) {
      PGraphics.showException("Cannot compile geometry shader:\n" +
        pgl.getShaderInfoLog(glGeometry));
      return false;
    } else {
      return true;
    }
  }
}

