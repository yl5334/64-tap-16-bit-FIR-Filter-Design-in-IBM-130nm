module dual_fifo(
    input          [15 : 0] wr_data,
    input                   clk1,  //write clock
    input                   wr_rstn,
    input                   wr_en,
    input                   clk2,  //read clock
    input                   rd_rstn,
    input                   rd_en,
    output            reg   fifo_full,
    output            reg   fifo_empty,
    output  reg    [15 : 0] rd_data
);
    //Defining read and write pointers
    reg [2 : 0]  wr_ptr, rd_ptr;

    reg [15 : 0] fifo    [3 : 0];

    //write operation
    always @ (posedge clk1 or negedge wr_rstn) begin
        if(!wr_rstn)
            wr_ptr <= 0;
        else if(wr_en && !fifo_full) begin
            fifo[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
        else
            wr_ptr <= wr_ptr;
    end

    //read operation
    always @ (posedge clk2 or negedge rd_rstn) begin
        if(!rd_rstn) begin
            rd_ptr <= 0;
            rd_data <= 0;
        end
        else if(rd_en && !fifo_empty) begin
            rd_data <= fifo[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
        else
            rd_ptr <= rd_ptr;
    end

    //Define read/write pointer Gray code
    wire [2 : 0] wr_ptr_g;
    wire [2 : 0] rd_ptr_g;

    //Read and write pointers converted to Gray code
    assign wr_ptr_g = wr_ptr ^ (wr_ptr >>> 1);
    assign rd_ptr_g = rd_ptr ^ (rd_ptr >>> 1);


    //Define two stage delay Gray code
    reg [2 : 0] wr_ptr_gr, wr_ptr_grr;
    reg [2 : 0] rd_ptr_gr, rd_ptr_grr;

    //Write pointer synchronization to read clock field
    always @ (posedge clk2 or negedge rd_rstn) begin
        if(!rd_rstn) begin
            wr_ptr_gr <= 0;
            wr_ptr_grr <= 0;
        end
        else begin
            wr_ptr_gr <= wr_ptr_g;
            wr_ptr_grr <= wr_ptr_gr;
        end
    end

    //Read pointer synchronized to write clock field
    always @ (posedge clk1 or negedge wr_rstn) begin
        if(!wr_rstn) begin
            rd_ptr_gr <= 0;
            rd_ptr_grr <= 0;
        end
        else begin
            rd_ptr_gr <= rd_ptr_g;
            rd_ptr_grr <= rd_ptr_gr;
        end
    end



    //Full Judgment
    always @ (posedge clk1 or negedge wr_rstn) begin
        if(!wr_rstn)
            fifo_full <= 0;
        else if((wr_ptr_g[2] != rd_ptr_grr[2]) && (wr_ptr_g[2 - 1] != rd_ptr_grr[2 - 1]) && (wr_ptr_g[2 - 2 : 0] == rd_ptr_grr[2 - 2 : 0]))
            fifo_full <= 1;
        else
            fifo_full <= 0;
    end

    //Empty Judgment
    always @ (posedge clk2 or negedge rd_rstn) begin
        if(!rd_rstn)
            fifo_empty <= 0;
        else if(wr_ptr_grr[2 : 0] == rd_ptr_g[2 : 0])
            fifo_empty <= 1;
        else
            fifo_empty <= 0;
    end
endmodule