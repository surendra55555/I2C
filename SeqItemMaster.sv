// SeqItem

class SeqItem;  // Transaction /SeqItem
  //bit clk_in, reset_in;
  rand logic write;
  rand logic [6:0] addr_in; 
  rand logic [7:0] data_in; 
  logic [7:0] read_out;
  logic i2c_sda_out, i2c_scl_out, sda_in;
  
  static logic [0:7] variable = $random;
  
  constraint addr_in_con { addr_in inside {
    7'b0001001, 7'b0010010, 7'b0011011, 7'b0100100 };}
 
endclass
