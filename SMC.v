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

wire mode_0, mode_1, mode_2, mode_3, mode_4, mode_5;
wire [2:0] neo_VGS_0, neo_VGS_1, neo_VGS_2, neo_VGS_3, neo_VGS_4, neo_VGS_5;
parameter triode = 0;
parameter saturation = 1;
wire [10:0] I_D_t0, I_D_t1, I_D_t2, I_D_t3, I_D_t4, I_D_t5;
wire [10:0] I_D_s0, I_D_s1, I_D_s2, I_D_s3, I_D_s4, I_D_s5;
reg [10:0] I_D_0, I_D_1, I_D_2, I_D_3, I_D_4, I_D_5;
wire [7:0] g_m_t0, g_m_t1, g_m_t2, g_m_t3, g_m_t4, g_m_t5;
wire [7:0] g_m_s0, g_m_s1, g_m_s2, g_m_s3, g_m_s4, g_m_s5;
reg [10:0] g_m_0, g_m_1, g_m_2, g_m_3, g_m_4, g_m_5;
reg [10:0] a, b, c, d, e, f;
reg [10:0] n0, n1, n2, n3, n4, n5;
reg [9:0] n0_div, n1_div, n2_div, n3_div, n4_div, n5_div;
//================================================================
//    DESIGN
//================================================================

// --------------------------------------------------
// write your design here
// --------------------------------------------------


/*Calculate Id or gm*/
    //  @@calculate 0
triode_apply MOS_t0(.width(W_0), .neo_VGS(neo_VGS_0), .V_DS(V_DS_0), .I_D(I_D_t0), .g_m(g_m_t0));
saturation_apply MOS_s0(.width(W_0), .neo_VGS(neo_VGS_0), .I_D(I_D_s0), .g_m(g_m_s0));

always @(*) begin
    if(mode_0 == triode) begin
        I_D_0 = I_D_t0;
        g_m_0 = {3'b0, g_m_t0};
    end
    else begin
        I_D_0 = I_D_s0;
        g_m_0 = {3'b0, g_m_s0};
    end
end

    //  @@calculate 1
triode_apply MOS_t1(.width(W_1), .neo_VGS(neo_VGS_1), .V_DS(V_DS_1), .I_D(I_D_t1), .g_m(g_m_t1));
saturation_apply MOS_s1(.width(W_1), .neo_VGS(neo_VGS_1), .I_D(I_D_s1), .g_m(g_m_s1));

always @(*) begin
    if(mode_1 == triode)begin
        I_D_1 = I_D_t1;
        g_m_1 = {3'b0, g_m_t1};
    end
    else begin
        I_D_1 = I_D_s1;
        g_m_1 = {3'b0, g_m_s1};
    end
end

    //  @@calculate 2
triode_apply MOS_t2(.width(W_2), .neo_VGS(neo_VGS_2), .V_DS(V_DS_2), .I_D(I_D_t2), .g_m(g_m_t2));
saturation_apply MOS_s2(.width(W_2), .neo_VGS(neo_VGS_2), .I_D(I_D_s2), .g_m(g_m_s2));

always @(*) begin
    if(mode_2 == triode) begin
        I_D_2 = I_D_t2;
        g_m_2 = {3'b0, g_m_t2};
    end
    else begin
        I_D_2 = I_D_s2;
        g_m_2 = {3'b0, g_m_s2};
    end
end

    //  @@calculate 3
triode_apply MOS_t3(.width(W_3), .neo_VGS(neo_VGS_3), .V_DS(V_DS_3), .I_D(I_D_t3), .g_m(g_m_t3));
saturation_apply MOS_s3(.width(W_3), .neo_VGS(neo_VGS_3), .I_D(I_D_s3), .g_m(g_m_s3));

always @(*) begin
    if(mode_3 == triode) begin
        I_D_3 = I_D_t3;
        g_m_3 = {3'b0, g_m_t3};
    end
    else begin
        I_D_3 = I_D_s3;
        g_m_3 = {3'b0, g_m_s3};
    end
end

    //  @@calculate 4
triode_apply MOS_t4(.width(W_4), .neo_VGS(neo_VGS_4), .V_DS(V_DS_4), .I_D(I_D_t4), .g_m(g_m_t4));
saturation_apply MOS_s4(.width(W_4), .neo_VGS(neo_VGS_4), .I_D(I_D_s4), .g_m(g_m_s4));

always @(*) begin
    if(mode_4 == triode) begin
        I_D_4 = I_D_t4;
        g_m_4 = {3'b0, g_m_t4};
    end
    else begin
        I_D_4 = I_D_s4;
        g_m_4 = {3'b0, g_m_s4};
    end
end

    //  @@calculate 5
triode_apply MOS_t5(.width(W_5), .neo_VGS(neo_VGS_5), .V_DS(V_DS_5), .I_D(I_D_t5), .g_m(g_m_t5));
saturation_apply MOS_s5(.width(W_5), .neo_VGS(neo_VGS_5), .I_D(I_D_s5), .g_m(g_m_s5));

always @(*) begin
    if(mode_5 == triode) begin
        I_D_5 = I_D_t5;
        g_m_5 = {3'b0, g_m_t5};
    end
    else begin
        I_D_5 = I_D_s5;
        g_m_5 = {3'b0, g_m_s5};
    end
end


/*Sort*/
always @(*) begin
    if(mode[0]) begin   //1: I_D  0: g_m
        a = I_D_0;
        b = I_D_1;
        c = I_D_2;
        d = I_D_3;
        e = I_D_4;
        f = I_D_5;
    end
    else begin
        a = g_m_0;
        b = g_m_1;
        c = g_m_2;
        d = g_m_3;
        e = g_m_4;
        f = g_m_5;
    end
end
sort s1(.a(a), .b(b), .c(c), .d(d), .e(e), .f(f), 
        .n0(n0), .n1(n1), .n2(n2), .n3(n3), .n4(n4), .n5(n5));

/*Select according to mode*/
    //  @@identify 0
assign neo_VGS_0 = V_GS_0 - 1'b1;
assign mode_0 = (neo_VGS_0 > V_DS_0) ? triode : saturation;

    //  @@identify 1
assign neo_VGS_1 = V_GS_1 - 1'b1;    
assign mode_1 = (neo_VGS_1 > V_DS_1) ? triode : saturation;

    //  @@identify 2
assign neo_VGS_2 = V_GS_2 - 1'b1;
assign mode_2 = (neo_VGS_2 > V_DS_2) ? triode : saturation;

    //  @@identify 3
assign neo_VGS_3 = V_GS_3 - 1'b1;
assign mode_3 = (neo_VGS_3 > V_DS_3) ? triode : saturation;

    //  @@identify 4
assign neo_VGS_4 = V_GS_4 - 1'b1;
assign mode_4 = (neo_VGS_4 > V_DS_4) ? triode : saturation;

    //  @@identify 5
assign neo_VGS_5 = V_GS_5 - 1'b1;
assign mode_5 = (neo_VGS_5 > V_DS_5) ? triode : saturation;

/*Output*/
always @(*) begin
    n0_div = n0 / 3;
    n1_div = n1 / 3;
    n2_div = n2 / 3;
    n3_div = n3 / 3;
    n4_div = n4 / 3;
    n5_div = n5 / 3;

    case(mode[1:0])
        2'b00: out_n = (n3_div + n4_div + n5_div) / 3;
        2'b01: out_n = (3*n3_div + 4*n4_div + 5*n5_div) / 12;
        2'b10: out_n = (n0_div + n1_div + n2_div) / 3;
        2'b11: out_n = (3*n0_div + 4*n1_div + 5*n2_div) / 12;
    endcase
end

endmodule


module triode_apply (
    input [2:0] width, neo_VGS, V_DS,
    output [10:0] I_D,
    output [7:0] g_m
);
    assign I_D = (width * (2 * neo_VGS * V_DS - V_DS * V_DS));
    assign g_m = (2 * width * V_DS);
    
endmodule

module saturation_apply (
    input [2:0] width, neo_VGS,
    output [10:0] I_D,
    output [7:0] g_m
);
    assign I_D = (width * neo_VGS * neo_VGS);
    assign g_m = (2 * width * neo_VGS);
endmodule

module sort (
    input [10:0] a, b, c, d, e, f,
    output reg [10:0] n0, n1, n2, n3, n4, n5
);
    reg [10:0] temp;
    reg [10:0] array [5:0];

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
