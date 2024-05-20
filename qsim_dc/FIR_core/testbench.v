//`timescale 1ns / 1ps

//`define sim_b_file "fir_b.input"
//`define sim_x_file "C:\Vivado_project\FIR_core\FIR_core.sim\sim_1\behav\xsim\fir_x.txt"
////`define sim_b_file "fir_b_test.txt"
//`define sim_out_file "fir_com.txt" // the compared file
//`define alu_output_file "output.txt" // the output file of result
//`define sim_address_file "address.txt"

`timescale 1ns / 1ps
`define sim_x_file "./fir_x.txt"
`define sim_b_file "./fir_b.input"
`define sim_com_file "./fir_com.txt" // the compared file
`define alu_output_file "./output.txt" // the output file of result
`define sim_address_file "./address.txt" // the compared file


module testbench(

    );
    parameter ht = 50;
    parameter clk1_period = 50000;
    parameter clk2_period = 500;
    parameter num_of_cof = 64;

    
    // Inputs
    reg clk1;
    reg clk2;
    reg rstn;
    reg [15:0] din;
    reg valid_in;
    reg [15:0] cin;
    reg [5:0] caddr;
    reg [2:0] cload;
    integer x_file; //pointer for x_file
    integer b_file; //pointer for b_file
    integer compare_file; //pointer for compare_file
    integer output_file; //pointer for output_file
    integer address_file;
    reg ret_com;
    // Outputs
    wire [15:0] dout;
    integer i;
    reg ret_b;
    reg ret_addr;
    reg ret_x;
    reg [15:0] y_com;
    integer error_count=0;

    // Instantiate the Unit Under Test (UUT)
    FIR_core uut (
        .clk1(clk1), 
        .clk2(clk2), 
        .rstn(rstn), 
        .din(din), 
        .valid_in(valid_in), 
        .cin(cin), 
        .caddr(caddr), 
        .cload(cload), 
        .dout(dout)
    );

    // Clock generation
    always #clk1_period clk1= ~clk1; // 50MHz clock
    always #clk2_period clk2 = ~clk2; // 50MHz clock

    initial begin
        // Initialize Inputs
        clk1 = 0;
        clk2 = 0;
        rstn = 1;
        valid_in = 0;
        cin = 0;
        caddr = 0;
        cload = 3'b110;
	
	$dumpfile("./FIR_core.vcd");
	$dumpvars(0,testbench.uut);

        // Reset
        #1000;
        rstn = 0;
        #1000000;
        rstn = 1;
        
        // ????

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
		
		compare_file = $fopen(`sim_com_file,"r");
		if (!compare_file) begin
			$display("Couldn't create the compare file.");
			$finish;
		end
		
		address_file = $fopen(`sim_address_file,"r");
		if (!output_file) begin
			$display("Couldn't create the address file.");
			$finish;
		end 
		
		output_file = $fopen(`alu_output_file,"w");
		if (!output_file) begin
			$display("Couldn't create the output file.");
			$finish;
		end
		
		# 1000;
		cload[2:1] = 2'b01;
		//valid_in =1;
		
//		@ (posedge(clk2))begin
//            for(i = 0; i<128; i=i+1)begin
                
//                if(cload[1] == 1)begin
//                    ret_b <= $fscanf(b_file, "%b\n", cin);
//                    ret_addr <= $fscanf(address_file, "%b\n", caddr);
//                end
//                #ht;
//                cload[1] = ~cload[1];
//                @(posedge(clk2));
//            end
            
//        end
        
        @ (posedge(clk2))begin
            for(i = 0; i<(2*num_of_cof + 1); i=i+1)begin
                
                if(cload[1] == 1)begin
                    ret_b = $fscanf(b_file, "%b\n", cin);
                    ret_addr <= $fscanf(address_file, "%b\n", caddr);

                end
                if(i==128)begin
		          #(clk2_period*2 - ht);
		
		          cload[2] = 1;
		          end
		          else begin
		              #ht;
                      cload[1] = ~cload[1];
		          end
                    @(posedge(clk2));
                    end
            
                    end
        
        cload[2:1] = 2'b11;
        $fclose(b_file);
        $fclose(address_file);
        


        #10000;
        b_file = $fopen(`sim_b_file,"r");
		if (!b_file) begin
			$display("Couldn't create the b file.");
			$finish;
		end
		
		address_file = $fopen(`sim_address_file,"r");
		if (!output_file) begin
			$display("Couldn't create the address file.");
			$finish;
		end
		
		
		cload[0] = 1;
		//valid_in = 1;
		
		#(clk2_period*2 + ht);   
        
        caddr = 0;
		cload[1] = 0;
		
		//#10; // Wait for a clock cycle
        //we = 1; // Disable write
         // Wait for a clock cycle
        
        @ (posedge(clk2))begin
            for(i = 0; i<(num_of_cof * 2); i=i+1)begin
                if(cload[1] == 0)begin
                    #ht;
                    ret_addr <= $fscanf(address_file, "%b\n", caddr);
                end
//                else begin
//                    if (Q!=data_com)begin
//                        error = error + 1;
//                    end
//                end
                #ht;
                cload[1] = ~cload[1];
                @(posedge(clk2));
            end
            
        end
        
        @(posedge(clk2))begin
            #ht;
            cload[1] = ~cload[1];
        end
        
//        @ (posedge(clk2))begin
//            for(i = 0; i<128; i=i+1)begin
//                if(cload[1] == 0)begin
//                    ret_addr = $fscanf(address_file, "%b\n", caddr);
//                end
//                #ht;
//                cload[1] = ~cload[1];
//                @(posedge(clk2));
//            end
            
//        end

        #clk2_period;
        
        cload[0] = 0;
        
        
        
        #clk2_period;

        @(posedge(clk2))begin
            #ht;
           valid_in = 1;
        end
        // Test sequence
        // Here you should write your test sequence to simulate
        // different scenarios for your module.
        @(posedge clk1)begin
            for (i=0; i<10000; i=i+1)begin
                $fwrite(output_file, "%b\n", dout);
                ret_com <= $fscanf(compare_file, "%b\n", y_com);
//                if(y_com != y)begin
//                    error_count <= error_count + 1;
//                end
                if(y_com[15:8] != dout[15:8] )begin
                    error_count <= error_count + 1;
                end
                @(posedge clk1);
                
            end
            
        end
        // Test example
        $dumpall;
	$dumpflush;

        // Add more test sequences here...
        $fclose(output_file);
        $fclose(compare_file);
        $fclose(x_file);
        $fclose(address_file);

        // Finish simulation

        $finish;
        end
        
        
        
        always@(posedge clk1)begin
            if(valid_in)begin
                    ret_x = $fscanf(x_file, "%b\n", din);
                    end
                end
endmodule
