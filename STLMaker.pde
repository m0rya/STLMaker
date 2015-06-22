sclass Mesher {

  PrintWriter writer;
  String tab = "    ";  //3 spaces

  //int2e(); double2e();
  int data_d2e[] = new int[10];
  int int2eCount=0;
  int double2eCount = 0;
  int digit;


  Mesher(PrintWriter _writer) {
    this.writer = _writer;
  }


  //Function
  //=========writing STL==============
  void facet(PrintWriter writer, String x, String y, String z) {
    writer.println(tab + "facet normal " + x + " " + y + " " + z);
  }

  void vertex3(PrintWriter writer, String x1, String y1, String z1, String x2, String y2, String z2, String x3, String y3, String z3) {
    writer.println(tab+tab + "outer loop");
    writer.println(tab+tab+tab + "vertex " + x1 + " " + y1 + " " + z1);
    writer.println(tab+tab+tab + "vertex " + x2 + " " + y2 + " " + z2);
    writer.println(tab+tab+tab + "vertex " + x3 + " " + y3 + " " + z3);
    writer.println(tab+tab + "endloop");
    writer.println(tab + "endfacet");
  }


  //========Util============
  // convert integer to exponent notaion(String)
  String int2e(int num) {
    if (num == 0) return "0.000000e+00";


    while (num > 0) {
      data_d2e[int2eCount] = num%10;
      num /= 10;
      int2eCount ++;
    }

    String ans = new String();
    digit = int2eCount-1;
    int2eCount --;
    ans += data_d2e[int2eCount] + ".";
    int2eCount--;

    while (int2eCount >= 0) {
      ans += data_d2e[int2eCount];
      int2eCount --;
    }
    ans += "e+0" + digit;
    return ans;
  }

  // convert double to exponent notaion(String)
  String double2e(double num) {
    double2eCount = 0;
    if (num == 0.0 ) return "0.000000E+00";
    if (num < 0.1E-05 && num > -0.1E-010) return "0.000000E+00";


    if (num >= 10) {
      while (num > 10) {
        num /= 10;
        double2eCount ++;
      }

      String Ans = nf((float)num, 1, 6);
      Ans += "E+0";
      Ans += str(double2eCount);

      return Ans;
    } else if (num >= 0.1) {


      String Ans = nf((float)num, 1, 6);
      Ans += "E+0" + str(double2eCount);

      return Ans;
    } else if (num < 0.1 && num > -0.1) {

      while ( num > -0.1 && num < 0.1) {
        num *= 10;
        double2eCount++;
      }
      String Ans = nf((float)num, 1, 6);
      Ans += "E-0" + str(double2eCount);
      return Ans;
    } else if (num <-0.1 && num > -10) {

      String Ans = nf((float)num, 1, 6);
      Ans += "E+0" + str(double2eCount);

      return Ans;
    } else if (num < -10) {
      while ( num < -10) {
        num /= 10;
        double2eCount++;
      }

      String Ans = nf((float)num, 1, 6);
      Ans += "E+0" + str(double2eCount);
      return Ans;
    } else {
      return null;
    }
  }


  //make normal Vector
  PVector normalVec(PVector a, PVector b, PVector c) {
    PVector v1 = PVector.sub(b, a);
    PVector v2 = PVector.sub(c, b);

    PVector ans = v1.cross(v2);
    ans.normalize();
    return ans;
  }




  //=====Object=======


  ////Cylynder Object
  void cylinder(int radius, int h, int rsl) {

    //Variable
    double cylynder_data[][] = new double[360/rsl + 1][2];
    String cylData[][] = new String[360/rsl + 1][2];
    String zero = "0.000000E+00";
    String plus = "1.000000E+00";
    String mns = "-1.000000E+00";
    String cylBottom = double2e(0.0);
    String cylTop    = double2e(h);


    for (int i=0; i<360/rsl + 1; i++) {
      if (i*rsl == 180) {
        cylynder_data[i][0] = 0.0;
      } else {
        cylynder_data[i][0] = sin(radians(i*rsl)) * radius;
      }

      if (i*rsl == 90 || i*rsl == 270) {
        cylynder_data[i][1] = 0.0;
      } else {
        cylynder_data[i][1] = cos(radians(i*rsl)) * radius;
      }

      println(cylynder_data[i][0]);
      println(cylynder_data[i][1]);

      cylData[i][0] = double2e(cylynder_data[i][0]);
      cylData[i][1] = double2e(cylynder_data[i][1]);

      println(i);
    }

    //Bottom Mesh
    for (int i=0; i<360/rsl; i++) {

      facet(output, zero, zero, mns);
      vertex3(output, zero, zero, zero, cylData[i][0], cylData[i][1], cylBottom, cylData[i+1][0], cylData[i+1][1], cylBottom);
    }

    //Top Mesh
    for (int i=0; i<360/rsl; i++) {

      facet(output, zero, zero, plus);
      vertex3(output, zero, zero, cylTop, cylData[i][0], cylData[i][1], cylTop, cylData[i+1][0], cylData[i+1][1], cylTop);
    }

    //Side Mesh
    for (int i=0; i<360/rsl; i++) {

      PVector vtxx[][] = new PVector[2][2];
      vtxx[0][0] = new PVector(int(cylData[i][0]), int(cylData[i][1]), int(cylBottom));
      vtxx[0][1] = new PVector(int(cylData[i+1][0]), int(cylData[i+1][1]), int(cylBottom));
      vtxx[1][0] = new PVector(int(cylData[i][0]), int(cylData[i][1]), int(cylTop));
      vtxx[1][1] = new PVector(int(cylData[i+1][0]), int(cylData[i+1][1]), int(cylTop));

      PVector nor1 = normalVec(vtxx[0][0], vtxx[0][1], vtxx[1][0]);
      PVector nor2 = normalVec(vtxx[1][0], vtxx[0][1], vtxx[1][1]);

      String nml[][] = new String[2][3];
      nml[0][0] = str(nor1.x);
      nml[0][1] = str(nor1.y);
      nml[0][2] = str(nor1.z);

      nml[1][0] = str(nor2.x);
      nml[1][1] = str(nor2.y);
      nml[1][2] = str(nor2.z);


      facet(output, nml[0][0], nml[0][1], nml[0][2]  );
      vertex3(output, cylData[i][0], cylData[i][1], cylBottom, cylData[i+1][0], cylData[i+1][1], cylBottom, cylData[i][0], cylData[i][1], cylTop);

      facet(output, nml[1][0], nml[1][1], nml[1][2] );
      vertex3(output, cylData[i][0], cylData[i][1], cylTop, cylData[i+1][0], cylData[i+1][1], cylBottom, cylData[i+1][0], cylData[i+1][1], cylTop);
    }
    output.println("endsolid");
  }


  //Cube Object
  void cube(int r) {

    String l = int2e(r);
    String none = "0.0e+00";
    String plus = "1.0e+00";
    String mns = "-1.0e+00";
    String zero = "0.0e+00";


    facet(output, zero, mns, zero);
    vertex3(output, none, none, none, l, none, none, l, none, l);
    facet(output, zero, mns, zero);
    vertex3(output, none, none, none, l, none, l, none, none, l);

    facet(output, zero, zero, mns);
    vertex3(output, none, none, none, l, none, none, l, l, none);
    facet(output, zero, zero, mns);
    vertex3(output, none, none, none, l, l, none, none, l, none);

    facet(output, mns, zero, zero);
    vertex3(output, none, none, none, none, l, none, none, l, l);
    facet(output, mns, zero, zero);
    vertex3(output, none, none, none, none, l, l, none, none, l);

    facet(output, zero, zero, plus);
    vertex3(output, none, none, l, l, none, l, l, l, l);
    facet(output, zero, zero, plus);
    vertex3(output, none, none, l, l, l, l, none, l, l);

    facet(output, zero, plus, zero);
    vertex3(output, none, l, none, l, l, none, l, l, l);
    facet(output, zero, plus, zero);
    vertex3(output, none, l, none, l, l, l, none, l, l);

    facet(output, plus, zero, zero);
    vertex3(output, l, none, none, l, l, none, l, l, l);
    facet(output, plus, zero, zero);
    vertex3(output, l, none, none, l, l, l, l, none, l);

    output.println("endsolid");
  }


  //Cone Object
  void cone(int radius, int h, int rsl) {
    //variable
    double cone_data[][] = new double[360/rsl + 1][2];
    String coneData[][] = new String[360/rsl + 1][2];
    String zero = "0.000000E+00";
    String plus = "1.000000E+00";
    String mns = "-1.000000E+00";
    // String coneTop = int2e(h);
    String coneTop = double2e(h);

    for (int i=0; i<360/rsl +1; i++) {
      if (i*rsl == 180) {
        cone_data[i][0] = 0.0;
      } else {
        cone_data[i][0] = sin(radians(i*rsl)) * radius;
      }

      if (i*rsl == 90 || i*rsl == 270) {
        cone_data[i][1] = 0.0;
      } else {
        cone_data[i][1] = cos(radians(i*rsl)) * radius;
      }

      coneData[i][0] = double2e(cone_data[i][0]);
      coneData[i][1] = double2e(cone_data[i][1]);
    }

    //Bottom Mesh
    for (int i=0; i<360/rsl; i++) {
      facet(output, zero, zero, mns);
      vertex3(output, zero, zero, zero, coneData[i][0], coneData[i][1], zero, coneData[i+1][0], coneData[i+1][1], zero);
    }

    //Side Mesh
    for (int i=0; i<360/rsl; i++) {

      PVector vtxx[] = new PVector[3];
      vtxx[0] = new PVector(int(coneData[i][0]), int(coneData[i][1]), int(zero));
      vtxx[1] = new PVector(int(coneData[i+1][0]), int(coneData[i+1][1]), int(zero));
      vtxx[2] = new PVector(int(zero), int(zero), int(coneTop));

      PVector nor = normalVec(vtxx[0], vtxx[1], vtxx[2]);

      String nml[] = new String[3];
      nml[0] = str(nor.x);
      nml[1] = str(nor.y);
      nml[2] = str(nor.z);

      facet(output, nml[0], nml[1], nml[2]);
      vertex3(output, coneData[i][0], coneData[i][1], zero, coneData[i+1][0], coneData[i+1][1], zero, zero, zero, coneTop);
    }

    output.println("endsolid");
  }

  //Rectangular Solid
  void rectSolid(int w, int d, int h) {
    String W = double2e(w);
    String D = double2e(d);
    String H = double2e(h);
    String zero = "0.000000E+00";
    String pls = "1.000000E+00";
    String mns = "-1.000000E+00";


    facet(output, zero, zero, mns);
    vertex3(output, zero, zero, zero, W, zero, zero, zero, D, zero);
    facet(output, zero, zero, mns);
    vertex3(output, zero, D, zero, W, zero, zero, W, D, zero);


    facet(output, zero, zero, pls);
    vertex3(output, zero, zero, H, W, zero, H, W, D, H);
    facet(output, zero, zero, pls);
    vertex3(output, zero, zero, H, W, D, H, zero, D, H);

    facet(output, zero, mns, zero);
    vertex3(output, zero, zero, zero, W, zero, zero, zero, zero, H);
    facet(output, zero, mns, zero);
    vertex3(output, zero, zero, H, W, zero, zero, W, zero, H); 

    facet(output, zero, pls, zero);
    vertex3(output, zero, D, zero, W, D, zero, W, D, H);
    facet(output, zero, pls, zero);
    vertex3(output, zero, D, zero, W, D, H, zero, D, H);

    facet(output, mns, zero, zero);
    vertex3(output, zero, zero, zero, zero, D, zero, zero, zero, H);
    facet(output, mns, zero, zero);
    vertex3(output, zero, zero, H, zero, D, zero, zero, D, H);

    facet(output, pls, zero, zero);
    vertex3(output, W, zero, zero, W, D, zero, W, D, H);
    facet(output, pls, zero, zero);
    vertex3(output, W, zero, zero, W, D, H, W, zero, H);

    output.println("endsolid");
  }







  //Trigonal Pyramid



  //Sphere
  //
}

