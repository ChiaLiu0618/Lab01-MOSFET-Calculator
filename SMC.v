//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab01 Exercise		: Supper MOSFET Calculator
//   Author     		: Lin-Hung Lai (lhlai@ieee.org)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SMC.v
//   Module Name : SMC
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################


module SMC(
  // Input signals
  input [1:0] mode,
  input [2:0] W_0, V_GS_0, V_DS_0,
  input [2:0] W_1, V_GS_1, V_DS_1,
  input [2:0] W_2, V_GS_2, V_DS_2,
  input [2:0] W_3, V_GS_3, V_DS_3,
  input [2:0] W_4, V_GS_4, V_DS_4,
  input [2:0] W_5, V_GS_5, V_DS_5, 
  // Output signals
  output reg [7:0] out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
/*input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
output [7:0] out_n;*/         					// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
//output reg [7:0] out_n; 								// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end

//================================================================
//    Wire & Registers 
//================================================================
wire [8:0] out_data_0, out_data_1, out_data_2, out_data_3, out_data_4, out_data_5;


reg [6:0] weighted_0, weighted_1, weighted_2;
reg [8:0] calc_0, calc_1, calc_2;
reg [9:0] sum;

reg [8:0] n0, n1, n2, n3, n4, n5;

//================================================================
//    DESIGN
//================================================================

// --------------------------------------------------
// write your design here
// --------------------------------------------------

Calc C0 (.mode(mode),
         .W_n(W_0), .V_GS_n(V_GS_0), .V_DS_n(V_DS_0),
         .out_data(out_data_0));

Calc C1 (.mode(mode),
         .W_n(W_1), .V_GS_n(V_GS_1), .V_DS_n(V_DS_1),
         .out_data(out_data_1));

Calc C2 (.mode(mode),
         .W_n(W_2), .V_GS_n(V_GS_2), .V_DS_n(V_DS_2),
         .out_data(out_data_2));

Calc C3 (.mode(mode),
         .W_n(W_3), .V_GS_n(V_GS_3), .V_DS_n(V_DS_3),
         .out_data(out_data_3));

Calc C4 (.mode(mode),
         .W_n(W_4), .V_GS_n(V_GS_4), .V_DS_n(V_DS_4),
         .out_data(out_data_4));

Calc C5 (.mode(mode),
         .W_n(W_5), .V_GS_n(V_GS_5), .V_DS_n(V_DS_5),
         .out_data(out_data_5));

// SORT
sort s1(.a(out_data_0), .b(out_data_1), .c(out_data_2), .d(out_data_3), .e(out_data_4), .f(out_data_5), 
        .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5));

// Summing
always @(*) begin
    if(mode[1]) begin
        weighted_0 = n0;
        weighted_1 = n1;
        weighted_2 = n2;
    end
    else begin
        weighted_0 = n3;
        weighted_1 = n4;
        weighted_2 = n5;
    end

end

always @(*) begin
    if(mode[0]) begin
        calc_0 = 3 * weighted_0;
        calc_1 = 4 * weighted_1;
        calc_2 = 5 * weighted_2;
    end
    else begin
        if(mode[1]) begin
            calc_0 = n0;
            calc_1 = n1;
            calc_2 = n2;
        end
        else begin
            calc_0 = n3;
            calc_1 = n4;
            calc_2 = n5;
        end
    end
end

assign sum = calc_0 + calc_1 + calc_2;

// Divide
always @(*) begin
    if(mode[0]) out_n = sum / 12;
    else out_n = sum / 3;
end


endmodule

module Calc (input [1:0] mode,
             input [2:0] W_n, V_GS_n, V_DS_n,
             output [8:0] out_data);

wire [2:0] V_GS_n_1;
wire MOS_mode;      // 1: Triode,   0: Saturation

wire [2:0] squared_cand;
wire [5:0] squared;
reg [5:0] mult;

// V_GS_n - 1
assign V_GS_n_1 = V_GS_n - 1;

// MOS Working Mode
assign MOS_mode = (V_GS_n_1 > V_DS_n);

// Squared
assign squared_cand = MOS_mode ? V_DS_n : V_GS_n_1;     // Triode : Saturation

assign squared = squared_cand * squared_cand;

// Mult
always @(*) begin
    case({mode[0], MOS_mode})
        2'b00: mult = (V_GS_n_1) << 1;
        2'b01: mult = V_DS_n << 1;
        2'b10: mult = squared;
        2'b11: mult = ((V_GS_n_1 * V_DS_n) << 1) - squared;
    endcase
end

// 1/3 W
assign out_data = (W_n * mult) / 3;


endmodule

module sort (
    input [8:0] a, b, c, d, e, f,
    output reg [8:0] n0, n1, n2, n3, n4, n5
);
    reg [8:0] temp;
    reg [8:0] array [5:0];

    always @(*) begin
        array[5] = a;
        array[4] = b;
        array[3] = c;
        array[2] = d;
        array[1] = e;
        array[0] = f;

        //search: list of sorting networks
        //4, 2
        if(array[4] < array[2]) begin
            temp = array[4];
            array[4] = array[2];
            array[2] = temp;
        end
        else begin
            array[4] = array[4];
            array[2] = array[2];
        end

        //5, 0
        if(array[5] < array[0]) begin
            temp = array[5];
            array[5] = array[0];
            array[0] = temp;
        end
        else begin
            array[5] = array[5];
            array[0] = array[0];
        end

        //3, 1
        if(array[3] < array[1]) begin
            temp = array[3];
            array[3] = array[1];
            array[1] = temp;
        end
        else begin
            array[3] = array[3];
            array[1] = array[1];
        end

        //4, 3
        if(array[4] < array[3]) begin
            temp = array[4];
            array[4] = array[3];
            array[3] = temp;
        end
        else begin
            array[4] = array[4];
            array[3] = array[3];
        end

        //2, 1
        if(array[2] < array[1]) begin
            temp = array[2];
            array[2] = array[1];
            array[1] = temp;
        end
        else begin
            array[2] = array[2];
            array[1] = array[1];
        end

        //5, 2
        if(array[5] < array[2]) begin
            temp = array[5];
            array[5] = array[2];
            array[2] = temp;
        end
        else begin
            array[5] = array[5];
            array[2] = array[2];
        end

        //3, 0
        if(array[3] < array[0]) begin
            temp = array[3];
            array[3] = array[0];
            array[0] = temp;
        end
        else begin
            array[3] = array[3];
            array[0] = array[0];
        end

        //5, 4
        if(array[5] < array[4]) begin
            temp = array[5];
            array[5] = array[4];
            array[4] = temp;
        end
        else begin
            array[5] = array[5];
            array[4] = array[4];
        end

        //3, 2
        if(array[3] < array[2]) begin
            temp = array[3];
            array[3] = array[2];
            array[2] = temp;
        end
        else begin
            array[3] = array[3];
            array[2] = array[2];
        end

        //1, 0
        if(array[1] < array[0]) begin
            temp = array[1];
            array[1] = array[0];
            array[0] = temp;
        end
        else begin
            array[1] = array[1];
            array[0] = array[0];
        end

        //4, 3
        if(array[4] < array[3]) begin
            temp = array[4];
            array[4] = array[3];
            array[3] = temp;
        end
        else begin
            array[4] = array[4];
            array[3] = array[3];
        end

        //2, 1
        if(array[2] < array[1]) begin
            temp = array[2];
            array[2] = array[1];
            array[1] = temp;
        end
        else begin
            array[2] = array[2];
            array[1] = array[1];
        end

        n0 = array[5];   //largest
        n1 = array[4];
        n2 = array[3];
        n3 = array[2];
        n4 = array[1];
        n5 = array[0];   //smallest
    end
endmodule



// module BBQ (meat,vagetable,water,cost);
// input XXX;
// output XXX;
// 
// endmodule

// --------------------------------------------------
// Example for using submodule 
// BBQ bbq0(.meat(meat_0), .vagetable(vagetable_0), .water(water_0),.cost(cost[0]));
// --------------------------------------------------
// Example for continuous assignment
// assign out_n = XXX;
// --------------------------------------------------
// Example for procedure assignment
// always@(*) begin 
// 	out_n = XXX; 
// end
// --------------------------------------------------
// Example for case statement
// always @(*) begin
// 	case(op)
// 		2'b00: output_reg = a + b;
// 		2'b10: output_reg = a - b;
// 		2'b01: output_reg = a * b;
// 		2'b11: output_reg = a / b;
// 		default: output_reg = 0;
// 	endcase
// end
// --------------------------------------------------
