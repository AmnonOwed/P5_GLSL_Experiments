
PShape createIcosahedron() {
  ArrayList <PVector> positions = new ArrayList <PVector> ();

  float sqrt5 = sqrt(5);
  float phi = (1 + sqrt5) * 0.5;
  float ratio = sqrt(10 + (2 * sqrt5)) / (4 * phi);
  float a = (1 / ratio) * 0.5;
  float b = (1 / ratio) / (2 * phi);

  PVector[] vertices = {
    new PVector( 0,  b, -a), 
    new PVector( b,  a,  0), 
    new PVector(-b,  a,  0), 
    new PVector( 0,  b,  a), 
    new PVector( 0, -b,  a), 
    new PVector(-a,  0,  b), 
    new PVector( 0, -b, -a), 
    new PVector( a,  0, -b), 
    new PVector( a,  0,  b), 
    new PVector(-a,  0, -b), 
    new PVector( b, -a,  0), 
    new PVector(-b, -a,  0)
  };

  int[] indices = { 
    0,1,2,    3,2,1,
    3,4,5,    3,8,4,
    0,6,7,    0,9,6,
    4,10,11,  6,11,10,
    2,5,9,    11,9,5,
    1,7,8,    10,8,7,
    3,5,2,    3,1,8,
    0,2,9,    0,7,1,
    6,9,11,   6,10,7,
    4,11,5,   4,8,10
  };

  for (int i=0; i<indices.length; i += 3) {
    positions.add(vertices[indices[i]]);
    positions.add(vertices[indices[i+2]]);
    positions.add(vertices[indices[i+1]]);
  }

  PShape mesh = createShape();
  mesh.beginShape(TRIANGLES);
  mesh.stroke(0);
  mesh.fill(255, 0, 0);
  for (PVector p : positions) {
    mesh.normal(p.x, p.y, p.z);
    mesh.vertex(p.x, p.y, p.z);
  }
  mesh.endShape();
  return mesh;
}

