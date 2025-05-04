module Data_CB(input clk,Clear,Ballot,Total,Result,Close,Casted,input [3:0]In,output engage_led,output[11:0]count);
    wire a,b,c,d,e,f,g,h,i,j,k,l,m,n,nota,gnd,yout;
    wire [11:0] Count_status,ao,bo,co,do,eo,fo,go,ho,io,jo,ko,lo,mo,no,notao;
    wire [3:0] r;
    buf bu(Ballot,engage_led);
    inc en_d(clk,Clear,Ballot,Close,yout,In,ed,yout);
    dailycount dyc(ed,Clear,Close,Count_status);
    Decoder4_16 dc(In,ed,gnd,a,b,c,d,e,f,g,h,i,j,k,l,m,n,nota);
    register_12bit A(Clear,a,ao);
    register_12bit B(Clear,b,bo);
    register_12bit C(Clear,c,co);
    register_12bit D(Clear,d,do);
    register_12bit E(Clear,e,eo);
    register_12bit F(Clear,f,fo);
    register_12bit G(Clear,g,go);
    register_12bit H(Clear,h,ho);
    register_12bit I(Clear,i,io);
    register_12bit J(Clear,j,jo);
    register_12bit K(Clear,k,ko);
    register_12bit L(Clear,l,lo);
    register_12bit M(Clear,m,mo);
    register_12bit N(Clear,n,no);
    register_12bit Nota(Clear,nota,notao);
    display ds(clk,Total,Result,Clear,Close,r,Count_status,ao,bo,co,do,eo,fo,go,ho,io,jo,ko,lo,mo,no,notao,count,r);
endmodule

module register_12bit(input Clear,pin,output reg[11:0] B);
always @(negedge Clear )
    B=12'b0;
always @(posedge pin)
begin
    if(pin) B=B+1;
    else B=B;
end
endmodule

module inc(input clk,Clear,B,off,bk,input[3:0]pin,output reg r,ret);
    always @(off or negedge Clear)
        begin r=1'b0;ret=1'b0; end
    always @(*)
    begin
        if(~B)ret=1'b0;
        if(~bk & B&(pin[0]|pin[1]|pin[2]) &~off)begin r=1'b1;ret=1'b1;end
        else r=1'b0;ret=ret;
    end
endmodule

module dailycount(input ed,Clear,CLOSE,output reg[11:0] c);
always @(CLOSE or negedge Clear)
     c=12'b0;
always @(posedge ed)
        if(ed) c=c+1;
        else c=c;
endmodule

module Decoder4_16(input[3:0]in,input ed,output reg gnd,a,b,c,d,e,f,g,h,i,j,k,l,m,n,nota);
always @(* )
begin
    gnd=(~in[0])& (~in[1]) & (~in[2])&(~in[3])&ed;
    a=in[0]& (~in[1]) & (~in[2])&(~in[3])&ed ;
    b=(~in[0])& in[1] & (~in[2])&(~in[3])&ed ;
    c=in[0]& in[1] & (~in[2]&(~in[3]))&ed;
    d=((~in[0])& (~in[1]) & in[2])&(~in[3])&ed ;
    e=(in[0]& (~in[1]) & in[2])&(~in[3])&ed ;
    f=((~in[0])& in[1] & in[2])&(~in[3])&ed ;
    g=(in[0]& in[1] & in[2])&(~in[3])&ed;
    h=(~in[0])& (~in[1]) & (~in[2])&(in[3])&ed;
    i=in[0]& (~in[1]) & (~in[2])&(in[3])&ed ;
    j=(~in[0])& in[1] & (~in[2])&(in[3])&ed ;
    k=in[0]& in[1] & (~in[2])&(in[3])&ed;
    l=((~in[0])& (~in[1]) & in[2])&(in[3])&ed ;
    m=(in[0]& (~in[1]) & in[2])&(in[3])&ed ;
    n=((~in[0])& in[1] & in[2])&(in[3])&ed ;
    nota=(in[0]& in[1] & in[2])&(in[3])&ed;
end
endmodule

module display(input clk,Total,Result,clear,close,input[3:0] r,input[11:0]count,a,b,c,d,e,f,g,h,i,j,k,l,m,n,nota,output reg [11:0]out ,output reg[3:0]y);
    always @(close or negedge clear )
        begin y=3'b0;out=12'b0; end
    always @(posedge clk )
        
        if(Total)out=count;
        else out=out; 
    always @(posedge Result)
    begin
     case(r)
            4'b0001: out=a;
            4'b0010: out=b;
            4'b0011: out=c;
            4'b0100: out=d;
            4'b0101: out=e;
            4'b0110: out=f;
            4'b0111: out=g;
            4'b1000: out=h;
            4'b1001: out=i;
            4'b1010: out=j;
            4'b1011: out=k;
            4'b1100: out=l;
            4'b1101: out=m;
            4'b1110: out=n;
            4'b1111: out=nota;
            default: begin y=4'b0001; out=a;end
        endcase
   y++;
    end
        
endmodule

module CountrolPath_CU(input clk,Close,Clear,Ballot,Total,Result);
    parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100,s5=3'b101;
    reg[2:0] n,p;
    always @(negedge Clear or posedge clk)
        begin
           if(~Clear) p=s0;
           else p=n;
        end
    always @(*)
        begin
            case(p)
                s0:begin if(Clear)n=s5;else if(Close)n=s1;else if(Ballot)n=s2;else if(Total)n=s3; else n=s0;end
                s1:begin if(Close)n=s1;if(Result)n=s4;else n=s0;end
                s2:begin if(Ballot)n=s2;else n=s0; end
                s3:begin if(Total)n=s3;else n=s0; end
                s4:begin if(Clear) n=s5;else n=s4; end
                s5:n=s0;
                default: n=s0;
            endcase
        end
endmodule


module t;
    reg [3:0]In;
    reg clk,Clear,Close,Total,Ballot,Result,Casted;
    wire enable;
    wire[11:0]dis;
    Data_CB dp(clk,Clear,Ballot,Total,Result,Close,Casted,In,enable,dis);
    CountrolPath_CU cp(clk,Close,Clear,Ballot,Total,Result);
    always #5 clk=~clk;
    initial
    begin
        Clear=1'b1;In=3'b000;Close=1'b0;Total=1'b0;Result=1'b0;clk=1'b0;        
        #10 Clear=1'b0;#10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #10 Ballot=1'b1;#10 In=3'b001;#10 In=3'b001;#10 In=3'b001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1010;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0110;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b1111;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0100;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0111;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0011;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b1101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0101;#10 In=4'b0101;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0011;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0110;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0111;#10 In=4'b1000;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0001;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0001;#10 In=4'b0100;#10 Ballot=1'b0;
        #200 Ballot=1'b1; In=4'b0010;#10 In=4'b0001;#10 Ballot=1'b0;
        #50 Total=1'b1;#10 Total=1'b0;
        #10 Close=1'b1;#10 Ballot=1'b1; In=3'b011;#10 In=3'b001;#10 Ballot=1'b0; #50 Close=1'b0;
        #10 Close=1'b1;#10 Ballot=1'b1; #10 In=4'b0001;#10 Ballot=1'b0; #50 Close=1'b0;
        #10 Close=1'b1;#10 Ballot=1'b1; #10 In=4'b0011;#10 Ballot=1'b0; #50 Close=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #10 Result=1'b1;# 20 Result=1'b0;
        #20 Clear=1'b1; #20 Clear=1'b0;
        #200 Ballot=1'b1; In=3'b011;#10 In=3'b001;#10 Ballot=1'b0;
        #10 Total=1'b1; #20 Total=1'b0;
        #300 $finish;
end
    initial begin
        $dumpfile("Vote.vcd");
        $dumpvars(0,t);
        $monitor("Time=%d,DISPLAY=%d",$time,dis);
    end
endmodule 
// 
//
//                   | IN |BA EN|
// __________________|____|_____|_____________
// |                                         |
// |                              *O* CASTED |
// |_________________________________________|
// |  O  Clear                               |
// |                                         |__ __ __
// |  O CLOSE                                |
// |                                         | DISPLAY
// |  O TOTAL                                |__ __ __
// |                                         |
// |  O RESULT                               |
// |                                         |
// |                                         |
// |_________________________________________|
// |                            O BALLOT     |
// |                                         |
// |                                         |
// |_________________________________________|
