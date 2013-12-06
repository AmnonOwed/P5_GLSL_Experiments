
import javax.media.opengl.GL4;

class PShaderCustom extends PShader {
  
  // Geometry Shader
  public int glGeometry;
  protected String geometryFilename;
  protected String[] geometryShaderSource;

  // Tessellation Control Shader
  public int glTessellationControl;
  protected String tessellationControlFilename;
  protected String[] tessellationControlShaderSource;

  // Tessellation Evaluation Shader
  public int glTessellationEvaluation;
  protected String tessellationEvaluationFilename;
  protected String[] tessellationEvaluationShaderSource;

  PShaderCustom(PApplet parent, String name) {
    super(parent, name + ".vert", name + ".frag");

    // Geometry Shader
    geometryFilename = name + ".geom";
    geometryShaderSource = loadStrings(geometryFilename);

    // Tessellation Control Shader
    tessellationControlFilename = name + ".ctrl";
    tessellationControlShaderSource = loadStrings(tessellationControlFilename);
    
    // Tessellation Evaluation Shader
    tessellationEvaluationFilename = name + ".eval";
    tessellationEvaluationShaderSource = loadStrings(tessellationEvaluationFilename);
  }

  @Override
  void setup() {
    
    // Geometry Shader
    if (hasGeometryShader()) {
      boolean geomRes = compileGeometryShader();
      if (geomRes) pgl.attachShader(glProgram, glGeometry);
    } else {
      println("Doesn't have a geometry shader");
    }
    
    // Tessellation Control Shader
    if (hasTessellationControlShader()) {
      boolean tessCtrlRes = compileTessellationControlShader();
      if (tessCtrlRes) pgl.attachShader(glProgram, glTessellationControl);
    } else {
      println("Doesn't have a tessellation control shader");
    }

    // Tessellation Evaluation Shader
    if (hasTessellationEvaluationShader()) {
      boolean tessEvalRes = compileTessellationEvaluationShader();
      if (tessEvalRes) pgl.attachShader(glProgram, glTessellationEvaluation);
    } else {
      println("Doesn't have a tessellation evaluation shader");
    }

    // setup Patches for tessellation shaders
    GL4 gl4 = ((PJOGL)((PGraphicsOpenGL)g).beginPGL()).gl.getGL4();
    gl4.glPatchParameteri(GL4.GL_PATCH_VERTICES, 3);
//    gl4.glDrawArrays(GL4.GL_PATCHES, firstVert, vertCount);
//    gl4.glDrawElements(GL4.GL_PATCHES, 0, GL4.GL_UNSIGNED_INT, 0);
  }

  // Geometry Shader

  protected boolean hasGeometryShader() {
    return geometryShaderSource != null && 0 < geometryShaderSource.length;
  }
  
  protected boolean compileGeometryShader() {
    glGeometry = pgl.createShader(GL4.GL_GEOMETRY_SHADER);

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

  // Tessellation Control Shader

  protected boolean hasTessellationControlShader() {
    return tessellationControlShaderSource != null && 0 < tessellationControlShaderSource.length;
  }

  protected boolean compileTessellationControlShader() {
    glTessellationControl = pgl.createShader(GL4.GL_TESS_CONTROL_SHADER);
    
    pgl.shaderSource(glTessellationControl, join(tessellationControlShaderSource, "\n"));
    pgl.compileShader(glTessellationControl);

    pgl.getShaderiv(glTessellationControl, PGL.COMPILE_STATUS, intBuffer);
    boolean compiled = intBuffer.get(0) == 0 ? false : true;
    if (!compiled) {
      PGraphics.showException("Cannot compile tesselation control shader:\n" +
        pgl.getShaderInfoLog(glTessellationControl));
      return false;
    } else {
      return true;
    }
  }

  // Tessellation Evaluation Shader

  protected boolean hasTessellationEvaluationShader() {
    return tessellationEvaluationShaderSource != null && 0 < tessellationEvaluationShaderSource.length;
  }

  protected boolean compileTessellationEvaluationShader() {
    glTessellationEvaluation = pgl.createShader(GL4.GL_TESS_EVALUATION_SHADER);

    pgl.shaderSource(glTessellationEvaluation, join(tessellationEvaluationShaderSource, "\n"));
    pgl.compileShader(glTessellationEvaluation);

    pgl.getShaderiv(glTessellationEvaluation, PGL.COMPILE_STATUS, intBuffer);
    boolean compiled = intBuffer.get(0) == 0 ? false : true;
    if (!compiled) {
      PGraphics.showException("Cannot compile tesselation evaluation shader:\n" +
        pgl.getShaderInfoLog(glTessellationEvaluation));
      return false;
    } else {
      return true;
    }
  }
}

