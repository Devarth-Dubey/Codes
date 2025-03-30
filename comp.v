module Vote_CU(input clk,Power,Close,Clear,Ballot,Total,Result,input[3:0]IN, output reg[11:0] out);
    parameter s0=3'b000,s1=3'b001,s2=3'b010,s3=3'b011,s4=3'b100,s5=3'b101,s6=3'b110;
    reg[2:0] n,p;
    reg[3:0]i;
    reg[11:0]count;
    reg[12:0] reg_b[15:0];
    reg lvl,lrl;
    always @(posedge Power)
    p<=s0;
    always @(posedge  clk  )  
    p<=n;
    
    always @(*)
                case(p)
                    s0:begin if(Clear)n<=s5;else begin if(Close)n<=s1;else begin if(Ballot)n<=s2;else begin if(Total)n<=s3; else n<=s0;end end end end
                    s1:begin if(Close) begin if(Result)n<=s4;else n<=s1;end else n<=s0;end
                    s2:begin if(lvl)n<=s2;else n<=s0; end
                    s3:begin if(Total)n<=s3;else n<=s0; end
                    s4:begin  if(Clear) n<=s5;if(~Result)n<=s6;else n<=s4; end
                    s5:n<=s0;
                    s6:if(Result)n<=s4;else n<=s6;
                    default: n<=s0;
                endcase
    always @(posedge clk)
            
        begin 
            case(p)
                s0:begin if(Close)  begin out<=count;end
                            else if(Ballot)lvl<=1'b1;
                            else begin out<=12'b0;lvl<=1'b0;end
                    end
                s1: if(Result)begin i<=4'b0001;lrl<=1'b1; end else begin count<=12'b0;out<=12'b0;end
                s2:if((IN!=4'b0000) & lvl & ~Close )begin 
                                    count++;
                                    case(IN)
                                    4'b0000:out<=12'b0;
                                    4'b0001:reg_b[0]<=reg_b[0]+1;
                                    4'b0010:reg_b[1]<=reg_b[1]+1;
                                    4'b0011:reg_b[2]<=reg_b[2]+1;
                                    4'b0100:reg_b[3]<=reg_b[3]+1;
                                    4'b0101:reg_b[4]<=reg_b[4]+1;
                                    4'b0110:reg_b[5]<=reg_b[5]+1;
                                    4'b0111:reg_b[6]<=reg_b[6]+1;
                                    4'b1000:reg_b[7]<=reg_b[7]+1;
                                    4'b1001:reg_b[8]<=reg_b[8]+1;
                                    4'b1010:reg_b[9]<=reg_b[9]+1;
                                    4'b1011:reg_b[10]<=reg_b[10]+1;
                                    4'b1100:reg_b[11]<=reg_b[11]+1;
                                    4'b1101:reg_b[12]<=reg_b[13]+1;
                                    4'b1110:reg_b[14]<=reg_b[14]+1;
                                    4'b1111:reg_b[15]<=reg_b[15]+1;
                                    endcase
                                
                            lvl<=1'b0;
                            out<=2'd00; end
                        else out<=12'b0;
                s3:out<=count;
                s4:begin case(i)
                    4'b0001:out<=reg_b[0];
                    4'b0010:out<=reg_b[1];
                    4'b0011:out<=reg_b[2];
                    4'b0100:out<=reg_b[3];
                    4'b0101:out<=reg_b[4];
                    4'b0110:out<=reg_b[6];
                    4'b0111:out<=reg_b[7];
                    4'b1000:out<=reg_b[8];
                    4'b1001:out<=reg_b[9];
                    4'b1010:out<=reg_b[10];
                    4'b1011:out<=reg_b[11];
                    4'b1100:out<=reg_b[12];
                    4'b1101:out<=reg_b[13];
                    4'b1110:out<=reg_b[14];
                    4'b1111:out<=reg_b[15];
                    default i<=4'b0001;
                    endcase 
                    if(lrl) 
                    i++;
                    else i<=i;
                    lrl<=1'b0;           
                    end
                s5:begin reg_b[0]<=12'b0;
                reg_b[0]<=12'b0;
                reg_b[1]<=12'b0;
                reg_b[2]<=12'b0;
                reg_b[3]<=12'b0; 
                reg_b[4]<=12'b0;
                reg_b[5]<=12'b0;
                reg_b[6]<=12'b0;
                reg_b[7]<=12'b0;
                reg_b[8]<=12'b0;
                reg_b[9]<=12'b0;
                reg_b[10]<=12'b0;
                reg_b[11]<=12'b0;
                reg_b[12]<=12'b0;
                reg_b[13]<=12'b0;
                reg_b[14]<=12'b0;
                reg_b[15]<=12'b0;
                count<=12'b0; out<=12'b0;i<=4'b0000;lvl<=1'b0;lrl=1'b0;
                end
                s6:begin lrl<=1'b1; out<=out;end
            endcase
        end
      
endmodule




