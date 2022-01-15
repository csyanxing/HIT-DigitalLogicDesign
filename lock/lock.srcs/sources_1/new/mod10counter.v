module mod10counter(clk,rst,start,out);
//mod10����������ʮ����0-9����
input clk;//ʱ���źţ�������ʱ���+1
input rst;//��λ�ź�(��0)
input start;//��ʼ����
output reg [3:0] out;//���������(8421BCD)
always @(posedge clk or posedge rst) //���������ػ�λ�ź�
begin
    if (rst)
        out <= 4'b0000;//set q=4'b0000
    else if(start) //start valid
    begin
        if(out==4'b1001)
            out <=4'b0000;//����9ʱ����̬Ϊ0
        else
            out<=out+4'b0001;//����0-8ʱ�������1
    end
end
endmodule