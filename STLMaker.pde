PrintWriter output;

void setup(){
  output = createWriter("typeTest.stl");
  output.println("solid Object");

}


void draw(){
  cube(50);

  output.flush();
  exit();
}

void stop(){
  output.close();
}


//3D Mesher
String tab = "    ";

void facet(PrintWriter writer,String x, String y, String z){
  writer.println(tab + "facet normal " + x + " " + y + " " + z);
}

void vertex3(PrintWriter writer, String x1, String y1, String z1, String x2, String y2, String z2, String x3, String y3, String z3){
  writer.println(tab+tab + "outer loop");
  writer.println(tab+tab+tab + "vertex " + x1 + " " + y1 + " " + z1);
  writer.println(tab+tab+tab + "vertex " + x2 + " " + y2 + " " + z2);
  writer.println(tab+tab+tab + "vertex " + x3 + " " + y3 + " " + z3);
  writer.println(tab+tab + "endloop");
}

int data_d2e[] = new int[10];
int count=0;
int digit;

String int2e(int num){
  if(num == 0) return "0.0e+00";

  while(num > 0){
    data_d2e[count] = num%10;
    num /= 10;
    count ++;
  }
  
  String ans = new String();
  digit = count-1;
  count --;
  ans += data_d2e[count] + ".";
  count--;

  while(count >= 0){
    ans += data_d2e[count];
    count --;
  }
  ans += "e+0" + digit;
  return ans;
}


  
void cube(int r){
  
  String l = int2e(r);
  String none = "0.0e+00";
  String plus = "1.0e+00";
  String mns = "-1.0e+00";
  String zero = "0.0e+00";


  facet(output,zero, mns, zero);
  vertex3(output,none,none,none,l,none,none,l,none,l);
  facet(output,zero, mns, zero);
  vertex3(output,none,none,none,l,none,l,none,none,l);

  facet(output,zero, zero, mns);
  vertex3(output,none,none,none,l,none,none,l,l,none);
  facet(output,zero, zero, mns);
  vertex3(output,none,none,none,l,l,none,none,l,none);

  facet(output,mns, zero, zero);
  vertex3(output,none,none,none,none,l,none,none,l,l);
  facet(output,mns, zero, zero);
  vertex3(output,none,none,none,none,l,l,none,none,l);

  facet(output,zero, zero, plus);
  vertex3(output,none,none,l,l,none,l,l,l,l);
  facet(output,zero, zero, plus);
  vertex3(output,none,none,l,l,l,l,none,l,l);

  facet(output,zero, plus, zero);
  vertex3(output,none,l,none,l,l,none,l,l,l);
  facet(output,zero, plus, zero);
  vertex3(output,none,l,none,l,l,l,none,l,l);

  facet(output,plus, zero, zero);
  vertex3(output,l,none,none,l,l,none,l,l,l);
  facet(output,plus, zero, zero);
  vertex3(output,l,none,none,l,l,l,l,none,l);
  
  output.println("endsolid");

}

   



  
   
   
