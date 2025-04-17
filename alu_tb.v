module alu_tb;
	
reg [5:0] opcode;
reg [31:0] a, b;
  
wire signed  [31:0]result;

  alu ALU ( opcode , a , b , result );


  
  initial begin
    $monitor("Time=%0t   opcode=%d    a=%0d   b=%0d   result=%0d  \n", $time, opcode, a, b, result);
  end

  
  initial begin
    // a+b
    opcode = 6'b000100;
    a = 32'h00003FAE;
	b = 32'h00000BB2; 
	
    
    #10; 
    
    // a-b
    opcode = 6'b001110;
    a = 32'h00003FAE;
	b = 32'h00000BB2; 
    
    #10;
	
	
	
	// |a|
	opcode = 6'b001000;
    a = 32'h00003FAE;
	b = 32'h00000BB2; 
	
	
	#10;
	
	  
	  
	// -a
	opcode = 6'b001011;
    a = 32'h00003FAE;
	b = 32'h00000BB2;
	
	#10;
	
	
    $finish;
  end

  

endmodule
