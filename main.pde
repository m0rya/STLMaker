
PrintWriter output;
Mesher maker = new Mesher(output);

void setup() {
  output = createWriter("typeTest.stl");
  output.println("solid Object");
}


void draw() {
  // maker.cube(40);
  maker.cylinder(20, 20, 60);


  output.flush();
  println("done");
  exit();
}

void stop() {
  output.close();
}

