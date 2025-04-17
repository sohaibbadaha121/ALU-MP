
module alu (opcode, a, b, result );
//opcode to decide what process we want to do
input [5:0] opcode;
//data A,B 
input signed [31:0] a, b;  

//Result or output	
output reg signed [31:0] result;	 
//this always for make the process by opcode
//
always @(opcode or a or b)
	begin
    case (opcode)
      6'b000100: result = a + b ;  
      6'b001110: result = a - b ;
      6'b001000: result = a < 0 ? -a : a ;//|a| 
      6'b001011: result = -a ;
      6'b001010: result = a > b ?  a : b ; //max(a,b)
      6'b000001: result = a < b ?  a : b ; //min(a,b)
      6'b001101: result = ( a + b ) / 2 ;  //avg(a,b)
      6'b000110: result = ~a ;//not(a)
      6'b001001: result = a|b;// a or  b 
      6'b000101: result = a&b;// a and b 
      6'b000111: result = a^b;// a xor b  
    endcase
	end
endmodule




module reg_file (clk, valid_opcode, addr1, addr2, addr3, in , out1, out2);
//for syncroize the data	
input clk;		  
//if the opcode valid or not 
input valid_opcode;
//adresses of  reqest data 
input [4:0] addr1, addr2, addr3; 
// result of micro processer are want to store  it 
input [31:0] in;
//request data
output reg [31:0] out1, out2; 

//data
 
reg [31:0] memory [0:31]='{
32'h00000000,
32'h00003FAE,
32'h00000BB2,
32'h0000067A,
32'h00001562,
32'h00001A80,
32'h00002A54,
32'h00001228,
32'h0000020C,
32'h00002FA8,
32'h00000CD6,
32'h0000398E,
32'h00002AF6,
32'h00001144,
32'h00002232,
32'h00000CAE,
32'h00002350,
32'h0000220A,
32'h00002EE8,
32'h000003EE,
32'h00001A44,  
32'h000031CA,	
32'h00001556,	 
32'h00002E22,	 
32'h00001DA6,	   
32'h00001110,		
32'h00002876,
32'h00003B94,
32'h00002EB2,
32'h00003588,
32'h000005C6,			 
32'h00000000			  
};						   

//1- check if valid opcode give him data
//2- give data and wait for syncroize the data and dont take wrong data by use some delays	
 always@(posedge clk or valid_opcode )
	begin
	   if(valid_opcode)
		   begin 
			 out1 <= memory[addr1] ;
			 
			 out2 <= memory[addr2];
			 #10;
			 memory[addr3] <=  in;
			 #10;
		   end
	   else $display ("invalid opcode");
	end
 
 	
	

     
 
	
endmodule


module mp_top (clk, instruction , result ); 
//for syncroize the data	
input clk;
//to give some order or some instruction
input [31:0] instruction;
//to recive result of micro processer 
output reg [31:0] result;
//check validity of opcode  
reg   valid_opcode	;	   
//input and output wires
wire [31:0] aout , ram_out1 ,ram_out2 ; 
//opcode 
reg [5:0] oc=instruction[5:0];
//for restart Dflip flop ()for opcode 
reg reset=1'b1;


	//check validity of opcode
	 always @(instruction [5:0])
     case (instruction [5:0])
       6'b000100: valid_opcode = 1'b1 ;
       6'b001110: valid_opcode = 1'b1 ;
       6'b001000: valid_opcode = 1'b1 ; 
       6'b001011: valid_opcode = 1'b1 ;
       6'b001010: valid_opcode = 1'b1 ; 
       6'b000001: valid_opcode = 1'b1 ;
       6'b001101: valid_opcode = 1'b1 ;
       6'b000110: valid_opcode = 1'b1 ;
       6'b001001: valid_opcode = 1'b1 ;
       6'b000101: valid_opcode = 1'b1 ;
       6'b000111: valid_opcode = 1'b1 ;
	   default  : valid_opcode = 1'b0 ;  
     endcase  

	 
	 
//call alu for make calculation	 

alu ALU( instruction [5:0] , ram_out1 , ram_out2 , aout );



//to be sure the opcode arrive with the data 
always @(posedge clk or reset) 
	begin
	if (reset)
	begin
      oc <= 6'bx;
	  reset=1'b0;
	end 
	else 
	begin
      oc <=instruction[31:26];         
    end
	
	
	end		


	
	
//call ram file for take datat and store data 	
reg_file RAM( clk , 
valid_opcode ,
instruction[10:6] ,
instruction[15:11] ,
instruction[20:16] ,
aout ,
ram_out1 , 
ram_out2 ) ;


 //store result in result module 
 assign result=	aout; 



endmodule 




module mp_top_tb;
reg clk  ;
reg [31:0] 	instruction; 

reg signed [31:0] HCresult;


wire signed [31:0] MPresult;

mp_top MP(clk , instruction , MPresult );



initial
begin
	
    $monitor("   Time= %0t  MPresult= %0d   HCresult = %0d (%s) \n", $time,MPresult , HCresult ,(MPresult == HCresult ?  "pass":"fail"));
end
   
always #10 clk = ~clk;

initial
begin

clk = 1 ;	


// 16302 + 2994;


instruction=32'b00000000000111110001000001000100;  


HCresult=(32'd16302 +32'd2994);


#20;


// 19296 & 19296  


instruction=32'b00000000000100001111111111000101;


HCresult=32'd19296 & 32'd19296;   


#20;	

 
//524 -	12200;


instruction=32'b00000000000100010100101000001110; 


HCresult=32'd524-32'd12200 ;	 


#20;


//|1006| 


instruction=32'b00000000000101010001010011001000;


HCresult = (32'd1006 < 0 ? -(32'd1006) : 32'd1006 );	 


#20; 


//-1478	


instruction=32'b00000000000100010000011110001011;



HCresult = -(32'd1478) ;


#20;


// max(13704 ,11954)


instruction=32'b00000000000100011110011101001010; 


HCresult =32'd13704 > 32'd11954 ?  32'd13704: 32'd11954 ; 


#20;


// min(13704 ,11954) 


instruction=32'b00000000000100011110011101000001; 


HCresult =32'd13704 < 32'd11954 ?  32'd13704: 32'd11954 ;


#20;


//not(1478)	 


instruction=32'b00000000000000000000011110000110;	   


HCresult =~(32'd1478);	 


#20;


//6784|5474


instruction=32'b00000000000101010010100100001001; 


HCresult =(32'd5474|32'd6784);	   


#20;


//32'd11954^32'd1478	


instruction=32'b00000000000101011110011110000111;


HCresult =(32'd11954^32'd1478);	


#20;


// avg(4648 ,4648) 


instruction=32'b00000000000000000011100111001101; 


HCresult =(32'd4648 + 32'd4648)>>1 ; 


#20; 	 

 
  
 $finish;
end
endmodule