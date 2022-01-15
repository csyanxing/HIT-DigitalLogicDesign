//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 20:42:07
// Design Name: 
// Module Name: main
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
module main(clk,clk0,clk1,clk2,clk3,rst,setpw,judge,pos,led,pos_countdown,led_countdown,staus,g_rst);

input clk;//ϵͳʱ��
input clk0,clk1,clk2,clk3;//�Ҳ�4�����밴��ģ���ʱ���źţ����ڸ�����+1
input rst;//��1���밴���ĸ�λ�ź�
input setpw;//������3�����밴������������״̬
input judge;//������2�����뿪�أ���������ģʽ

output reg [3:0] pos;//�Ҳ��Ҳ�4�������λѡ
output [6:0] led;//�Ҳ�4������ܶ�ѡ����ʾ��ǰ�������ʾ����������
output [6:0] led_countdown;//���4������ܶ�ѡ����ʾ����ʱ����
output reg pos_countdown;//��1�����λѡ��������ʾ����ʱ
output reg staus;//��1LED����ʾ����״̬
output reg g_rst; //��1LED����ʾ��λ״̬

integer clock_led,clock_countdown;//�������������������ڷ�Ƶ
wire [3:0] q0,q1,q2,q3;//�洢��ǰ������ĸ�����
reg [3:0] pw0,pw1,pw2,pw3;//�洢��ǰ�������λ����
reg [3:0] num;//�洢��ǰλѡ���������ʾ������
reg timeout;//��Ƶ������ܶ�̬��ʾ
reg [3:0] countdown;//����ʱ��������Ϊ5s����ʱ
reg input_start,input_rst;

initial
begin
    countdown=4'b0101; //��ʼʱ�赹��ʱΪ5s
    pos=4'b0001; //�Ҳ��ĸ������λѡ��ѡ�����Ҳ�һ�������
    timeout=0;
    clock_led=0;//��Ƶ��ʹ������ܶ�̬��ʾ
    clock_countdown=0; //���������Ƶ���ʱ
    pos_countdown=1; //���4������ܶ�ѡʼ��ѡ�������һ��
    staus=1; //����״̬�ȴ�
    g_rst = 0;  //�Ȳ����ڸ�λ״̬
end

//�Ҳ��ĸ����밴�������룬ͨ��ģ10����������ʮ����0~9����
mod10counter u0(clk0,input_rst,input_start,q0);
mod10counter u1(clk1,input_rst,input_start,q1);
mod10counter u2(clk2,input_rst,input_start,q2);
mod10counter u3(clk3,input_rst,input_start,q3);

//�Ҳ��ĸ��������ʾ4λ���룬ledΪ�Ҳ�����ܶ�ѡ
smg s0(clk,num,input_rst,led);

//��1�������ʾ����ʱ,led_countdownΪ�������ܶ�ѡ
smg s1(clk,countdown,0,led_countdown);

always @(posedge clk) //�������ģ��
begin
    if(countdown==4'b0000)//5s����ʱ��������·��λ
    begin
        input_start<=0; //ֹͣ���밴������
        input_rst<=1; //����ܸ�λ�ź���1���������������ʾ0
        g_rst <= 1; //��λ�ź���1
    end
    else
    begin
        g_rst <= 0; //��������¸�λ�ź���0
    	input_start<=setpw|judge; //Ҫô������������״̬��Ҫô������������״̬�����Ǵ�������״̬
    	input_rst<=rst|((~judge)&(~setpw)); //��·�ܸ�λ�ź�Ϊ1��ͬʱ���������������״̬�����·���븴λ
    end

    //��Ƶ
    if(clock_led==200000)
    begin
        timeout<=1;
        clock_led<=0;
    end
    else
    begin
        timeout<=0;
        clock_led<=clock_led+1;
    end

    
    if(judge&&countdown!=4'b0000&&~staus) //���ڿ���״̬
    begin
        if(clock_countdown!=1250000000)
        begin
            clock_countdown<=clock_countdown+1;
        end
        case(clock_countdown)
            1250000000:
                countdown<=4'b0000;
            1000000000:
                countdown<=4'b0001;
            750000000:
                countdown<=4'b0010;
            500000000:
                countdown<=4'b0011;
            250000000:
                countdown<=4'b0100;
            0:
                countdown<=4'b0101;
        endcase
    end
    else if(~judge) //δ���ڿ���״̬������ʱ��5
    begin
        countdown<=4'b0101;
        clock_countdown<=0;
    end

    //��������ģ��
    if(setpw && staus)//ֻ�е�����ʱ������������
    begin
        pw0<=q0;
        pw1<=q1;
        pw2<=q2;
        pw3<=q3;
    end

end

//ɨ����ʾ�Ҳ�4���߶������
always @(posedge timeout)
begin
    if (pos==4'b0001)
    begin
        pos<=4'b0010;
        num<=q1;
    end
    else if(pos==4'b0010)
    begin
        pos<=4'b0100;
        num<=q2;
    end
    else if(pos==4'b0100)
    begin
        pos<=4'b1000;
        num<=q3;
    end
    else if(pos==4'b1000)
    begin
        pos<=4'b0001;
        num<=q0;
    end
end

//�жϿ���ģ��
always @(*)
begin
    if(judge)
    begin
        if(pw0==q0&&pw1==q1&&pw2==q2&&pw3==q3&&countdown!=4'b0000)
            staus<=1;
        else
            staus<=0;
    end
end

endmodule
