`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 12:24:41 PM
// Design Name: 
// Module Name: FIR_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIR_core(
    input clk1, // input clock
    input clk2, // core clock
    input rstn,
    input signed [15:0] din, // input of x
    input valid_in, // flag for the input
    input signed [15:0] cin, // input of y
    input [5:0] caddr, // the addr of the coefficent
    input [2:0] cload, // cload[0] means the write of coefficent start 
    //cload[1] is chip enable, cload[2] is write enable. Both of them are negative
    output signed [15:0] dout
    );
    
    parameter num_of_coe = 64;
    
    wire [15:0] Q; //output of memory
    reg signed [15:0] b [63:0]; // local coefficient register 
    reg signed [31:0] y_shi [63:0]; // shifter register of y
    integer b_c; //counter for the reading of b
    reg signed [15:0] x_local;
    wire signed [15:0] fifo_x;
    //wire x_test;
    reg signed [15:0] b_local; // local b parameter in the ALU
    reg signed [31:0] y_former; // y[i-1]
    wire [31:0] ALU_out;
    reg alu_done;
    reg out_done;
    wire ALU_en;
	wire fifo_full;
	wire fifo_empty;
    wire Cload1;
    wire Cload2;
    reg [2:0] S;
    reg [2:0] s;
    //reg flag;
    reg rd_en;
    reg signed [31:0] y;
    wire signed [15:0] y_float; //the float of y
    integer i_b; //counter for load parameter b
    reg read_done;
    integer i_shi; // counter for initiation of y_shi
    //reg [15:0] Q_out;
    //reg [5:0] caddr_reg [63:0];
    //wire [5:0] 
    //integer caddr_c = 0; //counter for the read of address
    
    parameter S1 = 3'b000, S2 = 3'b001, S3 = 3'b010, S4 = 3'b011, S5 = 3'b100;
    integer i; // adder counter
    integer j; // hifter counter

    //Sram  
    sram cmem(.Q(Q),.clk(clk2),.CEN(Cload1),.WEN(Cload2),.A(caddr),.D(cin));
    //dual_fifo
    //dual_fifo FIFO( .wr_data(din), .clk1(clk1),  .wr_rstn(rstn), .wr_en(valid_in), .clk2(clk2),
    //.rd_rstn(rstn), .rd_en(rd_en), .fifo_full(fifo_full), .fifo_empty(fifo_empty),
    //.rd_data(x_local));
    
    AsyncFIFO # (
    .ADDR_SIZE(4),
   .DATA_SIZE(16)
    )
    async_fifo(
 .wdata(din),
 .winc(valid_in),
 .wclk(clk1), .wrst_n(rstn), .rinc(rd_en),
    .rclk(clk2), .rrst_n(rstn), .rdata(fifo_x), .wfull(fifo_full), .rempty(fifo_empty)
    );
    
        ALU adder_multipe(.clk(clk2), .rstn(rstn), .ALU_Enable(ALU_en), .x(x_local), 
     .ALU_in(y_former), .b(b_local), .ALU_out(ALU_out));
    
    assign ALU_en = (s == S4)?1:0;
    assign dout = y_float;
    assign Cload1 = cload[1];
    assign Cload2 = cload[2];
    always@(rd_en)
    begin
        if(rd_en)
            begin
                x_local <= fifo_x;
            end
        end
        
   always@(fifo_empty)begin
        if(!fifo_empty)
            rd_en <= 1;
        else
            rd_en <= 0;
        end


//        always@(posedge clk2 or negedge rstn)
//            begin: caddr_register
//                if(!cload[2])begin
//                    caddr                        
    
    
    //implement add and multiple ALU

    
//    always@(posedge clk2)
//        begin
//        Q_out <= Q;
//        end
    
    //flip 
    always@(cload[0], valid_in, read_done, alu_done, out_done)
        begin: State_table
            case(s)
            S1 : if(cload[0]==1'b1) S=S2;
                else if(valid_in) S=S3;
                else S = S1;
            S2 : if(!cload[0]) S = S1;
            S3 : if(read_done) S = S4;
            S4 : if(alu_done) S = S5;
            S5 : if(out_done) S = S1;
            endcase
        end
        
    always@(posedge clk2 or negedge rstn)
        begin: State_flipflops
            if (!rstn) begin
                s <= 2'b00;
                end
                else begin
                s <= S;
                end
            end
        
        
        
            
    
    always@(posedge clk2 or negedge rstn)
        begin: load_coefficient
            if(!rstn) begin
                b_c<=63;
                i_b<=0;
                //b[b_c] <= 0;
//                b[b_c] <= 1;
//                if(b_c == 63)
//                    b_c <= 0;
//                else
//                    b_c <= b_c+1;  
                end
            else if(s == S2)
            begin
                if(cload[2] && cload[1])begin 
                        b[63]<=Q;
                        for(b_c = 62; b_c>=0; b_c = b_c -1)begin
                        b[b_c]<=b[b_c+1];
                        i_b <= i_b+1;
                        //b[b_c] <= Q;         
                      
                       // b[b_c]<=b[b_c+1];
                        //b_c <=b_c+1;
                        end
                        end
                        
//                else if(i_b == 65)
//                    begin
//                        b[63]<=Q;
//                        for(b_c = 62; b_c>=0; b_c = b_c -1)begin
//                        b[b_c]<=b[b_c+1];
//                        //b[b_c] <= Q;         
                      
//                       // b[b_c]<=b[b_c+1];
//                        //b_c <=b_c+1;
//                        end
                        
//                    end
            end        
        end
        
    always@(posedge clk2 or negedge rstn)
        begin: FIFO
        if(!rstn) begin
                read_done <= 0;

            end
         else if(S==S3) begin
                if(rd_en)begin
                    read_done <= 1;
                end
                else begin
                    read_done <= 0;
                    end
                   
                    
            end
        end

        
    always@(posedge clk2 or negedge rstn)
        begin : ALU
            if(!rstn) begin
                i <= 0;
                alu_done <= 1;
                b_local <= 0;
                for (i_shi=0; i_shi <64; i_shi = i_shi +1)
                    begin
                        y_shi[i_shi] <= 0;
                    end

            end
            else if(s == S4)begin
                    alu_done <= 0;
                    if(i==0) begin
			for(j=63; j>0; j=j-1)begin
                       y_shi[j-1] <= y_shi[j];
                        end
                        y_shi[63] <= 0;
                        y_former <= 0;
                        b_local <= b[0];
                        i <= i+1;
                    end
                    else if(i<66) begin
                        if(i==1)begin
                            y_former <= y_shi[i-1];
                            b_local <= b[i];
                            i <= i+1;
                        end
                        else begin
                        if(i>=64)begin
                            b_local <= 0;
                            y_former <= 0;
                            y_shi[i-2]<=ALU_out;
                            i<=i+1;
                        end
                        else begin
                        y_former <= y_shi[i-1];
                         b_local <= b[i];
                        
                        y_shi[i-2]<=ALU_out;
                        i <= i+1;
                        end
                        end
                    end
                    else
                        begin
                        alu_done <= 1;
                        i <= 0;
                        
                    end
                    end
            end
        
        always@(posedge clk2 or negedge rstn)
            begin:shifter_register
               if(!rstn) begin
                   y <= 0;
                   out_done <= 0;
               end
               else if(s == S5) begin
                   if(out_done)begin
                        out_done <= 0;
                        y <= y_shi[0];
                    end
                    else begin
                   
                   out_done <= 1;
                   end
               end
                             
       
            end
        
        fix2float ff(.clk(clk2), .fixed(y), .float(y_float));
                
endmodule




module ALU(clk, rstn, ALU_Enable, x, b, ALU_in, ALU_out);
    
    input clk, rstn, ALU_Enable;
    input signed [15:0] x, b;
    input signed [31:0] ALU_in;
    output [31:0] ALU_out;
    
    
    reg signed [31:0] psum;
    reg [31:0] ALU_out_t;
    
    always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		psum = 0;
	end
        else if(ALU_Enable)begin
            psum = x*b;
            ALU_out_t = psum + ALU_in;
        end
    end
    assign ALU_out = ALU_out_t;
    
    
    
endmodule

module fix2float (input clk,
input signed [31:0] fixed,
    output reg signed [15:0] float  
    
);

integer i;
reg [4:0] exp;
reg [9:0] mant;
reg break = 0;

always@(posedge clk) begin
    //sign bit
    if (fixed == 32'b0) begin
        float = 16'b0;
    end
    else begin
    float[15] = fixed[31];
    break = 0;

    exp = 0;

    for (i = 30; i >= 0 && !break; i=i-1) begin
        if (fixed[i] == 1'b1) begin
            exp = i - 30;
            break = 1'b1;
        end
    end
    
    mant = fixed << (-exp +1);

    exp = exp + 15; 

    


    float[14:10] = exp[4:0];
    float[9:0] = mant[9:0];
    end
end

endmodule

