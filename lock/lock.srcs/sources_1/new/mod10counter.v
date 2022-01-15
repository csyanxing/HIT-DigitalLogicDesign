module mod10counter(clk,rst,start,out);
//mod10计数器输入十进制0-9数码
input clk;//时钟信号，上升沿时输出+1
input rst;//复位信号(置0)
input start;//开始计数
output reg [3:0] out;//计数器输出(8421BCD)
always @(posedge clk or posedge rst) //遇到上升沿或复位信号
begin
    if (rst)
        out <= 4'b0000;//set q=4'b0000
    else if(start) //start valid
    begin
        if(out==4'b1001)
            out <=4'b0000;//计数9时，次态为0
        else
            out<=out+4'b0001;//计数0-8时，输出加1
    end
end
endmodule