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

input clk;//系统时钟
input clk0,clk1,clk2,clk3;//右侧4个拨码按键模拟的时钟信号，用于给数码+1
input rst;//左1拨码按键的复位信号
input setpw;//左数第3个拨码按键，设置密码状态
input judge;//左数第2个拨码开关，输入密码模式

output reg [3:0] pos;//右侧右侧4个数码管位选
output [6:0] led;//右侧4个数码管段选，表示当前数码管显示的数字字形
output [6:0] led_countdown;//左侧4个数码管段选，显示倒计时数码
output reg pos_countdown;//左1数码管位选，用于显示倒计时
output reg staus;//右1LED，表示开锁状态
output reg g_rst; //左1LED，表示复位状态

integer clock_led,clock_countdown;//计算上升沿数量，用于分频
wire [3:0] q0,q1,q2,q3;//存储当前输入的四个数码
reg [3:0] pw0,pw1,pw2,pw3;//存储当前保存的四位密码
reg [3:0] num;//存储当前位选下数码管显示的数字
reg timeout;//分频给数码管动态显示
reg [3:0] countdown;//倒计时，这里设为5s倒计时
reg input_start,input_rst;

initial
begin
    countdown=4'b0101; //初始时设倒计时为5s
    pos=4'b0001; //右侧四个数码管位选先选到最右侧一个数码管
    timeout=0;
    clock_led=0;//分频，使数码管能动态显示
    clock_countdown=0; //计数，控制倒计时
    pos_countdown=1; //左侧4个数码管段选始终选到最左侧一个
    staus=1; //开锁状态先打开
    g_rst = 0;  //先不处于复位状态
end

//右侧四个拨码按键的输入，通过模10计数器输入十进制0~9数码
mod10counter u0(clk0,input_rst,input_start,q0);
mod10counter u1(clk1,input_rst,input_start,q1);
mod10counter u2(clk2,input_rst,input_start,q2);
mod10counter u3(clk3,input_rst,input_start,q3);

//右侧四个数码管显示4位密码，led为右侧数码管段选
smg s0(clk,num,input_rst,led);

//左1数码管显示倒计时,led_countdown为左侧数码管段选
smg s1(clk,countdown,0,led_countdown);

always @(posedge clk) //输入控制模块
begin
    if(countdown==4'b0000)//5s倒计时结束，电路复位
    begin
        input_start<=0; //停止拨码按键输入
        input_rst<=1; //数码管复位信号置1，令所有数码管显示0
        g_rst <= 1; //复位信号置1
    end
    else
    begin
        g_rst <= 0; //正常情况下复位信号置0
    	input_start<=setpw|judge; //要么处于重置密码状态，要么处于输入密码状态，都是处于输入状态
    	input_rst<=rst|((~judge)&(~setpw)); //电路总复位信号为1或同时打开输入和重置密码状态，令电路输入复位
    end

    //分频
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

    
    if(judge&&countdown!=4'b0000&&~staus) //处于开锁状态
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
    else if(~judge) //未处于开锁状态，倒计时置5
    begin
        countdown<=4'b0101;
        clock_countdown<=0;
    end

    //重置密码模块
    if(setpw && staus)//只有当锁打开时才能重置密码
    begin
        pw0<=q0;
        pw1<=q1;
        pw2<=q2;
        pw3<=q3;
    end

end

//扫描显示右侧4个七段数码管
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

//判断开锁模块
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
