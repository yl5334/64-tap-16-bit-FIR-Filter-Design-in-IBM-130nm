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
