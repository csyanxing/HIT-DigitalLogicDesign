module smg(clk,num,rst,out);
input clk;//ʱ���ź�
input [3:0] num;//����ʮ���������8421BCD��
input rst;//��λ�ź�(��0)
output reg [6:0] out;//����߶�����ܶ�Ӧ��7λ�ź�
always @(posedge clk or posedge rst)
begin
    if(rst)
        out<=7'b1111110;//�յ���λ�źţ�����������0
    else
    begin
        case(num) //��0-9�Ÿ�����ɶ�Ӧ���߶������ȡֵ
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