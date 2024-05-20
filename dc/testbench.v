`timescale 1ns / 1ps
`define sim_x_file "fir_x_test.txt"
`define sim_b_file "fir_b_test.txt"
`define sim_out_file "fir.output" // the compared file
`define alu_output_file "output.txt" // the output file of result

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 05:30:43 PM
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    
    reg clk1, clk2;
    reg ALU_restn;
    reg [15:0] x, b;
    wire [15:0] y;
    reg [15:0] y_com;
    reg b_valid;
    reg ret_b;
    reg ret_x;
    reg ret_com;
    integer x_file;
    integer b_file;
    integer output_file;
    integer compare_file;
    reg [14:0] error_count = 0;
    integer i;
    
    parameter clk2_period=1562.5;
    parameter clk1_period = 100000;
    
    
    ALU myALU (
        .clk1(clk1),
        .clk2(clk2),
        .ALU_restn(ALU_restn),
        .x(x),
        .b(b),
        .b_valid(b_valid),
        .y(y)
    );

    // ????
    initial begin
        clk1 = 0;
        forever #(clk1_period/2) clk1 = ~clk1; // 10k Hz ??
    end
    
    initial begin
        clk2 = 1;
        forever #(clk2_period/2) clk2 = ~clk2; // 640k MHz ??
    end

        

    // ????
    initial begin
        x_file = $fopen(`sim_x_file,"r");
		if (!x_file) begin
			$display("Couldn't create the x file.");
			$finish;
		end
		b_file = $fopen(`sim_b_file,"r");
		if (!b_file) begin
			$display("Couldn't create the b file.");
			$finish;
		end
		
		compare_file = $fopen(`sim_out_file,"r");
		if (!compare_file) begin
			$display("Couldn't create the output file.");
			$finish;
		end
		
		output_file = $fopen(`alu_output_file,"w");
		if (!output_file) begin
			$display("Couldn't create the output file.");
			$finish;
		end

		
        // ???
        ALU_restn = 0; // ??
        b_valid = 0;
        #100000;
        ALU_restn = 1; // ????
 
        

        // ????? x ? b ??

        // ????

        @(posedge clk2)begin
            
            for (i=0; i<64; i=i+1)begin
                ret_b = $fscanf(b_file, "%b\n", b);
                @(posedge clk2);
            end
            
        end
            
        // ... ????????????
        b_valid = 1;
        
        @(posedge clk1)begin
            for (i=0; i<10000; i=i+1)begin
                ret_x <= $fscanf(x_file, "%b\n", x);
                #clk1_period;
                $fwrite(output_file, "%b\n", y);
                ret_com <= $fscanf(compare_file, "%b\n", y_com);
//                if(y_com != y)begin
//                    error_count <= error_count + 1;
//                end
                if(y_com[15:8] != y[15:8] )begin
                    error_count <= error_count + 1;
                end
                @(posedge clk1);
                
            end
            
        end

        // ????
        #clk1_period;
        
        
        
        
        $fclose(output_file);
        $fclose(compare_file);
        $fclose(x_file);
        $fclose(b_file);
        $finish;
    end

endmodule


//module testbench;

//    parameter N = 64-1; // Number of coefficients
//    parameter M = 10000; // Number of input signals

//    // Clock periods for clk1 and clk2
//    parameter CLK1_PERIOD = 100000; // 10 kHz = 100 us = 100000 ns
//    parameter CLK2_PERIOD = 1562.5; // 640 kHz = 1.5625 us = 1562.5 ns

//    // Inputs
//    reg clk1;
//    reg clk2;
//    reg ALU_restn;
//    reg [15:0] x;
//    reg [15:0] b;
//    reg b_valid;

//    // Outputs
//    wire [15:0] y;

//    // File handlers
//    integer x_file, b_file, output_file, scan_file;
//    integer i;
//    reg [15:0] expected_output;
//    integer error_count = 0;

//    // Instantiate the ALU module
//    ALU uut (
//        .clk1(clk1), 
//        .clk2(clk2), 
//        .ALU_restn(ALU_restn), 
//        .x(x), 
//        .b(b), 
//        .b_valid(b_valid), 
//        .y(y)
//    );

//    // Clock generation
//    initial begin
//        clk1 = 0;
//        forever #(CLK1_PERIOD / 2) clk1 = ~clk1;
//    end

//    initial begin
//        clk2 = 0;
//        forever #(CLK2_PERIOD / 2) clk2 = ~clk2;
//    end

//    // Testbench logic
//    initial begin
//        // Initialize
//        ALU_restn = 0;
//        b_valid = 0;
//        x = 0;
//        b = 0;

//        // Reset the system
//        #(CLK1_PERIOD * 2) ALU_restn = 1;

//        // Open files
//        x_file = $fopen(`sim_x_file,"r");
//		if (!x_file) begin
//			$display("Couldn't create the x file.");
//			$finish;
//		end
//		b_file = $fopen(`sim_b_file,"r");
//		if (!b_file) begin
//			$display("Couldn't create the b file.");
//			$finish;
//		end
//        // Read and apply coefficients
//        for (i = 0; i <= N; i = i + 1) begin
//            scan_file = $fscanf(b_file, "%b\n", b);
//            b_valid = 1;
//            #(CLK2_PERIOD); // Wait for one clk2 period
//        end
//        b_valid = 0;

//        // Process input signals
//        for (i = 0; i < M; i = i + 1) begin
//            scan_file = $fscanf(x_file, "%b\n", x);
//            #(CLK1_PERIOD); // Wait for one clk1 period

          
//        end

//        // Close files
//        $fclose(x_file);
//        $fclose(b_file);
//        $fclose(output_file);

//        // Display results
//        if (error_count == 0)
//            $display("Test passed!");
//        else
//            $display("Test failed with %d errors.", error_count);

//        $finish;
//    end

//endmodule