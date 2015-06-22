
PrintWriter output;
Mesher maker = new Mesher(output);

void setup() {
  output = createWriter("typeTest.stl");
  output.println("solid Object");
}


void draw() {
  // maker.cube(40);
  //maker.cylinder(20, 20, 10);
  // maker.cone(20,20,10);
  maker.rectSolid(10,20,30);



  output.flush();
  println("done");
  exit();
}

void stop() {
  output.close();
}

