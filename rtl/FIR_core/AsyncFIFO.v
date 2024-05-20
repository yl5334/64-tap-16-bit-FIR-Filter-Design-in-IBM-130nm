module AsyncFIFO # (
    parameter   ADDR_SIZE = 4,
    parameter   DATA_SIZE = 16
    )
(
    input       [ DATA_SIZE - 1: 0 ]    wdata,
    input                               winc,
    input                               wclk,
    input                               wrst_n,
    input                               rinc,
    input                               rclk,
    input                               rrst_n,
    output      [ DATA_SIZE - 1: 0 ]    rdata,
    output                              wfull,
    output                              rempty
    );
    
    wire        [ ADDR_SIZE - 1: 0 ]     waddr, raddr;
    wire        [ ADDR_SIZE    : 0 ]     wptr, rptr, wq2_rptr, rq2_wptr;
    
    
    sync_r2w # (
    .ADDR_SIZE ( ADDR_SIZE )
)
    I1_sync_r2w (
        .rptr       ( rptr      ),
        .wclk       ( wclk      ),
        .wrst_n     ( wrst_n    ),
        .wq2_rptr   ( wq2_rptr  )
    );
    
    
    sync_w2r # (
    .ADDR_SIZE ( ADDR_SIZE )
)
    I2_sync_w2r (
        .wptr       ( wptr      ),
        .rclk       ( rclk      ),
        .rrst_n     ( rrst_n    ),
        .rq2_wptr   ( rq2_wptr  )
    );
    
    
    DualRAM # (

    .ADDR_SIZE ( ADDR_SIZE ),           
    .DATA_SIZE ( DATA_SIZE )    
    )
        I3_DualRAM (
        .wclken     ( winc      ),     
        .wclk       ( wclk      ),     
        .raddr      ( raddr     ),      
        .waddr      ( waddr     ),     
        .wdata      ( wdata     ),      
        .rdata      ( rdata     )      
    );
    
    
    rptr_empty # (
    .ADDR_SIZE ( ADDR_SIZE )
    )
        I4_rptr_empty (
        .rclk       ( rclk      ),
        .rinc       ( rinc      ),
        .rrst_n     ( rrst_n    ),    
        .rq2_wptr   ( rq2_wptr  ),
        .rempty     ( rempty    ),
        .raddr      ( raddr     ),     
        .rptr       ( rptr      )       
    );
    
    
    wptr_full# (
   .ADDR_SIZE ( ADDR_SIZE )
    )
       I5_wptr_full  (
        .wclk       ( wclk      ),
        .winc       ( winc      ),
        .wrst_n     ( wrst_n    ),    
        .wq2_rptr   ( wq2_rptr  ),
        .wfull      ( wfull     ),
        .waddr      ( waddr     ),    
        .wptr       ( wptr      )    
    );
    
endmodule

module sync_r2w # (
    parameter       ADDR_SIZE = 4
)
(
    input       [ ADDR_SIZE: 0 ]    rptr,  
    input                           wclk,   
    input                           wrst_n,    
    output  reg [ ADDR_SIZE: 0 ]    wq2_rptr    
    );
    
    reg [ ADDR_SIZE: 0 ]    wq1_rptr;           // This register is used to generate the delay for hitting a beat
    
    // two stage synchronizer
    always @ ( posedge wclk or negedge wrst_n ) begin
        if ( !wrst_n )
            { wq2_rptr, wq1_rptr } <= 0;
        else                                           
            { wq2_rptr, wq1_rptr } <= { wq1_rptr, rptr };       // The first cycle gives the address pointer of the null module to the beat register, and the second cycle takes it out and gives it to the output signal.
    end
    
endmodule


module sync_w2r # (
    parameter       ADDR_SIZE = 4
)
(
    input       [ ADDR_SIZE: 0 ]    wptr,       // write gray code from judgement
    input                           rclk,
    input                           rrst_n,
    output  reg [ ADDR_SIZE: 0 ]    rq2_wptr    // write_pointer gray code for read clk
    );
    
    reg [ ADDR_SIZE: 0 ]    rq1_wptr;           // one stage delay
    
    // two stage synchronizer
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n )
            { rq2_wptr, rq1_wptr } <= 0;
        else
            { rq2_wptr, rq1_wptr } <= { rq1_wptr, wptr };   
    end
    
endmodule

module DualRAM #(
parameter           ADDR_SIZE = 4,
parameter           DATA_SIZE = 16   
)(
input                       wclken,
input                       wclk,
input  [ADDR_SIZE - 1: 0]   raddr,
input  [ADDR_SIZE - 1: 0]   waddr,
input  [DATA_SIZE - 1: 0]   wdata,
output [DATA_SIZE - 1: 0]   rdata
);

localparam RAM_DEPTH = 1 << ADDR_SIZE;   // RAM depth

reg [DATA_SIZE-1: 0] mem [0:RAM_DEPTH-1];

always @ ( posedge wclk ) begin
if ( wclken == 1'b1 ) begin 
mem[ waddr ] <= wdata;           // write operation
end

else begin
mem[ waddr ] <= mem[ waddr ];    // hold
end
end

assign      rdata   =  mem [ raddr ];    // read
endmodule


module rptr_empty # (
    parameter   ADDR_SIZE = 4
)
(
    input                           rclk,
    input                           rinc,       
    input                           rrst_n,
    input       [ ADDR_SIZE    :0 ] rq2_wptr,  
    output reg                      rempty,
    output      [ ADDR_SIZE - 1:0 ] raddr,     
    output reg  [ ADDR_SIZE    :0 ] rptr      
    );
    
    reg     [ ADDR_SIZE: 0 ]    rbin;
    wire    [ ADDR_SIZE: 0 ]    rgraynext, rbinnext;   
    wire                        rempty_val;
    
    
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n ) begin
            rbin <= 0;
            rptr <= 0;
        end
        else begin
            rbin <= rbinnext; 
            rptr <= rgraynext;  
        end 
    end
    
    assign rbinnext = !rempty ? ( rbin + rinc ): rbin;      // If the FIFO is not empty, the address is the current address + read enable (i.e., address plus one); if the FIFO is empty, the address is not updated
    assign rgraynext = ( rbinnext >> 1 ) ^ ( rbinnext );    
    assign raddr = rbin[ ADDR_SIZE - 1: 0 ];            
    
    // 
    assign rempty_val = ( rgraynext == rq2_wptr );          // Judgment null logic: write pointer Gray code and read pointer Gray code is exactly the same, then null
    
    
    // Empty signal rempty judgment timing
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n )
            rempty <= 1'b1;          
        else
            rempty <= rempty_val;     
    end
    
endmodule

module wptr_full# (
    parameter   ADDR_SIZE = 4
)
(
    input                           wclk,
    input                           winc,
    input                           wrst_n,
    input       [ ADDR_SIZE    :0 ] wq2_rptr,
    output reg                      wfull,
    output      [ ADDR_SIZE - 1:0 ] waddr,      // address for RAM
    output reg  [ ADDR_SIZE    :0 ] wptr        // gray code for write   
    );
    
    reg     [ ADDR_SIZE: 0 ]    wbin;      
    wire    [ ADDR_SIZE: 0 ]    wgraynext, wbinnext;    // gray code
    wire                        wfull_val;
 
    always @ ( posedge wclk or negedge wrst_n ) begin
        if ( !wrst_n ) begin
            wbin <= 0;
            wptr <= 0;
        end
        else begin
            wbin <= wbinnext;
            wptr <= wgraynext;
        end 
    end
    
    assign wbinnext = !wfull ? ( wbin + winc ): wbin;
    assign wgraynext = ( wbinnext >> 1 ) ^ ( wbinnext );
    assign waddr = wbin[ ADDR_SIZE - 1: 0 ];
    
    // judgement of full
    assign wfull_val = ( wgraynext == { ~wq2_rptr [ ADDR_SIZE: ADDR_SIZE - 1 ], wq2_rptr [ ADDR_SIZE-2: 0 ] } );
    
    always @ ( posedge wclk or negedge wrst_n ) begin
        if ( !wrst_n )
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end
endmodule
