module reg_file_tb;
	
reg clk;
reg valid_opcode;
reg [4:0] addr1 ; 
reg [4:0] addr2 ;
reg [4:0] addr3 ;
reg [31:0] in   ;

wire[31:0] out1 ;
wire[31:0] out2 ;

reg_file RAM (clk,valid_opcode,addr1,addr2,addr3,in,out1,out2);

always #5 clk = ~clk;	
	
initial begin
    
    clk = 1;
    valid_opcode = 1;
    addr1 = 5;
    addr2 = 10;
    addr3 = 0;
    in = 32'h12345678;
	

	
  
    $monitor("Time=%0t  valid_opcode=%b   addr1=%h   addr2=%h   addr3=%h   in=%h   out1=%h   out2=%h  \n",
             $time, valid_opcode, addr1, addr2, addr3, in, out1, out2);

	 	#10;
		
        addr1 = 3;
        addr2 = 4;
        addr3 = 0;
        in = 32'hA5A5A5A5;
	
	
	#10 $finish;
  end




endmodule