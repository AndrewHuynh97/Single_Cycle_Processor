
module mux4
   #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] d0,d1,d2,d3,
     input logic [1:0] sel,
     output logic [WIDTH-1:0] y);

logic [WIDTH-1:0] o1,o2;

mux2 #(WIDTH) m1(d0,d1,sel[0],o1);
mux2 #(WIDTH) m2(d2,d3,sel[0],o2);
mux2 #(WIDTH) m3(o1,o2,sel[1], y);



endmodule




