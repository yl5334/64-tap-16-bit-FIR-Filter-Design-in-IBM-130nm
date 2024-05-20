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

    .ADDR_SIZE ( ADDR_SIZE ),           // FIFO地址深度
    .DATA_SIZE ( DATA_SIZE )            // 数据位宽
    )
        I3_DualRAM (
        .wclken     ( winc      ),      // 写使能
        .wclk       ( wclk      ),      // 写时钟
        .raddr      ( raddr     ),      // 读时钟
        .waddr      ( waddr     ),      // 写地址
        .wdata      ( wdata     ),      // 写入RAM的数据
        .rdata      ( rdata     )       // 从RAM读出的数据
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
        .raddr      ( raddr     ),      // 输出到RAM的读地址
        .rptr       ( rptr      )        // 输出到写时钟域的格雷码    
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
        .waddr      ( waddr     ),      // 输出到RAM的读地址
        .wptr       ( wptr      )        // 输出到写时钟域的格雷码     
    );
    
endmodule


module DualRAM #(
parameter           ADDR_SIZE = 4,
parameter           DATA_SIZE = 16      // 数据位宽
)(
input                       wclken,
input                       wclk,
input  [ADDR_SIZE - 1: 0]   raddr,
input  [ADDR_SIZE - 1: 0]   waddr,
input  [DATA_SIZE - 1: 0]   wdata,
output [DATA_SIZE - 1: 0]   rdata
);

localparam RAM_DEPTH = 1 << ADDR_SIZE;   // RAM深度，最高位存放判定空满信号指针

reg [DATA_SIZE-1: 0] mem [0:RAM_DEPTH-1];// 开辟内存

always @ ( posedge wclk ) begin
if ( wclken == 1'b1 ) begin 
mem[ waddr ] <= wdata;           // 写使能信号为高，将数据写入
end

else begin
mem[ waddr ] <= mem[ waddr ];    // 写使能没来，保持
end
end

assign      rdata   =  mem [ raddr ];    // 读地址来，直接给出数据
endmodule


module rptr_empty # (
    parameter   ADDR_SIZE = 4
)
(
    input                           rclk,
    input                           rinc,       // 读使能信号，每给一个读使能信号，读地址加一
    input                           rrst_n,
    input       [ ADDR_SIZE    :0 ] rq2_wptr,   // 同步模块传入的写指针格雷码
    output reg                      rempty,
    output      [ ADDR_SIZE - 1:0 ] raddr,      // 输出到RAM的读地址
    output reg  [ ADDR_SIZE    :0 ] rptr        // 输出到写时钟域的格雷码: 比地址多一位，最高位用来判断空满状态   
    );
    
    reg     [ ADDR_SIZE: 0 ]    rbin;           // 二进制地址
    wire    [ ADDR_SIZE: 0 ]    rgraynext, rbinnext;    // 二进制和格雷码地址
    wire                        rempty_val;
    
    //---------- 地址逻辑 -------------//
    
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n ) begin
            rbin <= 0;
            rptr <= 0;
        end
        else begin
            rbin <= rbinnext;       // 时钟来，更新二进制地址
            rptr <= rgraynext;      // 更新对应地址的格雷码
        end 
    end
    
    // 地址产生逻辑
    assign rbinnext = !rempty ? ( rbin + rinc ): rbin;      // 二进制地址更新逻辑： 若FIFO非空， 地址为当前地址 ＋ 读使能（即地址加一）； FIFO空则地址不更新
    assign rgraynext = ( rbinnext >> 1 ) ^ ( rbinnext );    // 格雷码地址产生：二进制右移一位后异或
    assign raddr = rbin[ ADDR_SIZE - 1: 0 ];                // 读地址传入 RAM
    
    // FIFO 判空
    assign rempty_val = ( rgraynext == rq2_wptr );          // 判空逻辑：写指针的格雷码和读指针的格雷码完全一样，则空
    
    
    // 判空信号rempty判断时序
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n )
            rempty <= 1'b1;                 // 复位时，FIFO为空
        else
            rempty <= rempty_val;           // 需要再用一个信号 rempty_val写入时序逻辑
    end
    
endmodule

module sync_r2w # (
    parameter       ADDR_SIZE = 4
)
(
    input       [ ADDR_SIZE: 0 ]    rptr,       // 判空模块传入的格雷码地址指针
    input                           wclk,       // 外部传入的写时钟信号
    input                           wrst_n,     // 外部传入的写复位信号
    output  reg [ ADDR_SIZE: 0 ]    wq2_rptr    // 输出到判满模块的格雷码地址指针
    );
    
    reg [ ADDR_SIZE: 0 ]    wq1_rptr;           // 该寄存器用于生成打一拍的延迟
    
    // D触发器，两级同步
    always @ ( posedge wclk or negedge wrst_n ) begin
        if ( !wrst_n )
            { wq2_rptr, wq1_rptr } <= 0;
        else                                                    // 相当于将输入的地址延迟一个时钟周期：
            { wq2_rptr, wq1_rptr } <= { wq1_rptr, rptr };       // 第一个周期把判空模块的地址指针给到打拍寄存器，第二个周期再取出给输出信号
    end
    
endmodule

// 写指针同步到读时钟模块
module sync_w2r # (
    parameter       ADDR_SIZE = 4
)
(
    input       [ ADDR_SIZE: 0 ]    wptr,       // 判满模块产生的写地址格雷码
    input                           rclk,
    input                           rrst_n,
    output  reg [ ADDR_SIZE: 0 ]    rq2_wptr    // 输出到读时钟域的写地址格雷码
    );
    
    reg [ ADDR_SIZE: 0 ]    rq1_wptr;           // 打一拍的延迟
    
    // D触发器，两级同步
    always @ ( posedge rclk or negedge rrst_n ) begin
        if ( !rrst_n )
            { rq2_wptr, rq1_wptr } <= 0;
        else
            { rq2_wptr, rq1_wptr } <= { rq1_wptr, wptr };       // 相当于将输入的地址延迟一个时钟周期
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
    output      [ ADDR_SIZE - 1:0 ] waddr,      // 输出到RAM的读地址
    output reg  [ ADDR_SIZE    :0 ] wptr        // 输出到写时钟域的格雷码    
    );
    
    reg     [ ADDR_SIZE: 0 ]    wbin;           // 二进制地址
    wire    [ ADDR_SIZE: 0 ]    wgraynext, wbinnext;    // 二进制和格雷码地址
    wire                        wfull_val;
    
    //---------- 地址逻辑 -------------//
    
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
    
    // 地址产生逻辑
    assign wbinnext = !wfull ? ( wbin + winc ): wbin;
    assign wgraynext = ( wbinnext >> 1 ) ^ ( wbinnext );
    assign waddr = wbin[ ADDR_SIZE - 1: 0 ];
    
    // FIFO 判满
    assign wfull_val = ( wgraynext == { ~wq2_rptr [ ADDR_SIZE: ADDR_SIZE - 1 ], wq2_rptr [ ADDR_SIZE-2: 0 ] } );//最高两位取反，然后再判断
    
    always @ ( posedge wclk or negedge wrst_n ) begin
        if ( !wrst_n )
            wfull <= 1'b0;
        else
            wfull <= wfull_val;
    end
endmodule
