`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 04:37:17 PM
// Design Name: 
// Module Name: ALU
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

//parameter SIZE = 64; // size of fifo


module ALU(
    input clk1,
    input clk2,
    input ALU_restn,
    input signed [15:0] x,
    input signed [15:0] b,
    input b_valid,
    output signed [15:0] y

    );
    
    parameter N = 64-1; // N is the number of coefficient
    parameter M = 10000; // M is the number of input signal
    reg signed [15:0] x_fifo[N:0]; // the fifo of x
    //reg [15:0] y_t; //temp for y
    reg signed [31:0] y_t;
    reg signed [31:0] temp; //the output of the first MAC
    reg signed [31:0] temp1;
    //wire signed [15:0] temp2; //the output of the second MAC
    integer i; // loop parameter for x
    integer j_b = 0; // loop parameter for y
    reg valid_ALU; // the start of ALU
    reg complete = 0;
	reg delete = 0;
    reg [31:0] y_t2;
    integer N_mac; //indicate this is how many bit mac
    //reg [31:0] temp2;
    
    //always@(b)
    (* dont_touch = "true" *)   reg signed [15:0] b_t[63:0];

        
    always@(posedge clk2 or negedge ALU_restn)
        begin
            if(!ALU_restn) begin
                
                b_t[j_b] <= 0;
                if(j_b == 63)
                    j_b <= 0;
                else
                    j_b <= j_b+1;  
                end
            else begin
                if( !complete)begin
		if(!delete)begin
			delete <= delete +1;
		end
		else begin
                    b_t[j_b] <= b;
                    j_b<=j_b+1;
                    if(j_b==63) begin
			b_t[j_b] <= b;
                        complete <= 1;
                        end
                end
		end
            end
            end
    // read b into our memory
 //   always@(posedge clk2 or negedge ALU_restn)begin
//	if
  //      b_t[j_b] <= b;
    //    if(j_b == 63)begin
      //      complete <= 1;
	//	b_t[j_b] <= b;
//            b_t[32] <= b_t[32] + 16'b1;
 //           end
  //      else
   //         j_b <= j_b + 1;
    //    end
         
    
    
    // fifo
    always@(posedge clk1 or negedge ALU_restn)
        begin
        if(!ALU_restn) begin
		valid_ALU <= 0;
            for(i=0; i<=N; i=i+1)
                x_fifo[i]<=0;
            end
        else
            if(complete && b_valid)
                begin
                valid_ALU <= 1;
                x_fifo[0] <= x;
                for(i=0; i<N; i=i+1)begin
                        x_fifo[i+1] <= x_fifo[i];
                    end
                end
    
        end
        
        
    //  ALU multipler
    
//    always@(posedge clk2 or negedge ALU_restn)
//        begin
//        if(!ALU_restn) begin
//            temp <= 0;
//            N_mac <= 0;
//            //temp2 <= 0;
//            end
            
//        else 
//        if(valid_ALU & complete) begin
//                temp <= x_fifo[N_mac] * b_t[N_mac];
//                if(N_mac == 63)
//                    N_mac <= 0;
//                else
//                    N_mac <= N_mac + 1;
//            end
//        end
        
//        assign temp2 = temp[31:15]; //calucula
        
//        always@(posedge clk2 or negedge ALU_restn)begin
//            if(!ALU_restn)
//                y_t <= 0;
//            else
//            begin
//                if(valid_ALU & complete)begin
//                    y_t <= y_t + temp2;
//                    if(N_mac == 0)begin
//                        y <= y_t;
//                        y_t <= 0;
//                    end
//                end
//            end
//            end
            
            
            
            
//        always@(posedge clk2 or negedge ALU_restn)
//        begin
//        if(!ALU_restn) begin
//            temp <= 0;
//            N_mac <= 0;
//            end
            
//        else 
//        if(valid_ALU & complete) begin
//                temp <= x_fifo[N_mac] * b_t[N_mac];
//                if(N_mac == 63)
//                    N_mac <= 0;
//                else
//                    N_mac <= N_mac + 1;
//            end
//        end
        
//        assign temp2 = y_t[31:16];
        
//        always@(posedge clk2 or negedge ALU_restn)begin
//            if(!ALU_restn)
//                y_t <= 0;
//            else
//            begin
//                if(valid_ALU & complete)begin
//                    y_t <= y_t + temp;
//                    if(N_mac == 0)begin
//                        y <= temp2;
//                        y_t <= temp;
//                    end
//                end
//            end
//            end
            
            
            
        always@(posedge clk2 or negedge ALU_restn)
        begin
        if(!ALU_restn) begin
            temp <= 0;
            N_mac <= 0;
            end
            
        else 
        if(valid_ALU && complete) begin
                case(N_mac)
                    63: begin
                    N_mac <=0;
                    end
                    62: begin
                    N_mac <= N_mac + 1;
                    end
                    61: begin
                    N_mac <= N_mac + 1;
                    temp <= x_fifo[62] * b_t[62];
                    temp1 <= x_fifo[63] * b_t[63];
                    end
                    60: begin
                    N_mac <= N_mac + 1;
                    temp <= x_fifo[60] * b_t[60];
                    temp1 <= x_fifo[61] * b_t[61];
                    end
                    default: begin
                    temp <= x_fifo[N_mac] * b_t[N_mac];
                    N_mac <= N_mac + 1;
                    end
                endcase
           end
        end
        
        
        always@(posedge clk2 or negedge ALU_restn)begin
            if(!ALU_restn) begin
                y_t <= 0;
                y_t2 <= 0;
            end
            else
            begin
                if(valid_ALU && complete)begin
                    case(N_mac)
                    63: begin
                    y_t2 <= y_t;
                    y_t <= 0;
                    end
                    62: begin
                    y_t <= y_t + temp + temp1;
                    end
                    61: begin
                    y_t <= y_t + temp + temp1;
                    end
                    default: begin
                    y_t <= y_t + temp;
                    end
                endcase
                end
            end
            end
        
        fix2float uut(.fixed(y_t2), .float(y));                        

                
    
            
            
endmodule



module fix2float (
    input [31:0] fixed,
    output reg [15:0] float  
);

integer i;
reg [4:0] exp;
reg [9:0] mant;
reg break = 0;

always @ (fixed) begin
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



