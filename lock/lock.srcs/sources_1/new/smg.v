module smg(clk,num,rst,out);
input clk;//时钟信号
input [3:0] num;//输入十进制数码的8421BCD码
input rst;//复位信号(置0)
output reg [6:0] out;//输出七段数码管对应的7位信号
always @(posedge clk or posedge rst)
begin
    if(rst)
        out<=7'b1111110;//收到复位信号，数码管输出置0
    else
    begin
        case(num) //将0-9九个数译成对应的七段数码管取值
            4'b0000:
                out <= 7'b1111110;
            4'b0001:
                out <= 7'b0110000;
            4'b0010:
                out <= 7'b1101101;
            4'b0011:
                out <= 7'b1111001;
            4'b0100:
                out <= 7'b0110011;
            4'b0101:
                out <= 7'b1011011;
            4'b0110:
                out <= 7'b1011111;
            4'b0111:
                out <= 7'b1110000;
            4'b1000:
                out <= 7'b1111111;
            4'b1001:
                out <= 7'b1111011;
            default:
                out <= 7'b1111110;
        endcase
    end
end
endmodule