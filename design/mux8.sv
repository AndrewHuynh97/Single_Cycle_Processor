module mux8
    #(parameter WIDTH = 32)
     (input logic [WIDTH-1:0] d0,d1,d2,d3,d4,d5,d6,d7,
      input logic [2:0] sel,
      output logic [WIDTH-1:0] y);
 
 logic [WIDTH-1:0] o1,o2;
 
mux4 m1(d0,d1,d2,d3,sel[1:0],o1);
mux4 m2(d4,d5,d6,d7,sel[1:0],o2);
mux2 m3 (o1,o2,sel[2],y);
 
 
 endmodule
