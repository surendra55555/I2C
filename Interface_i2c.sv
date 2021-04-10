//file: interface_i2c.sv


interface seq_intf (input bit clk_in, input bit reset_in);
  
  //logic reset_in;
  
  logic write;
  logic [6:0] addr_in; 
  logic [7:0] data_in; 
  logic [7:0] read_out;
  logic i2c_scl_out; 
  logic i2c_sda_out; 
  logic sda_in;
  
  /*task print();
    $monitor ("Tmonitored values:time=%0t clk=%0t write_read=%0b addr_in=%0b data_in=%0b scl_out=%0b sda_out=%0b sda_in=0%b ", $time, clk_in, write, addr_in, data_in,  i2c_scl_out, i2c_sda_out, sda_in);
  endtask */
  
endinterface
