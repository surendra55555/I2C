// DriSlave.sv  Slave Driver

class DrvSlaveWr;  // Slave Driver
  logic [3:0] count;
  SeqItem seq_obj2;
  virtual seq_intf vintf;
  
  function new (virtual seq_intf vintf);
    this.vintf = vintf;
  endfunction
  
  task drvslave(input int x);
    seq_obj2 = new();
    repeat (x) begin
      
      //Address ack
      
      for(count=0; count<8; count=count+1) begin
        @ (negedge vintf.i2c_scl_out);
        vintf.sda_in = 1;
      end
      
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = 0;
      
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = 1;
      
      //Data ack
      for(count=0; count<7; count=count+1) begin
        @ (negedge vintf.i2c_scl_out);
        vintf.sda_in = 1;
      end
      
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = 0;
      
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = 1;
      
      //Reseting 
      @ (negedge vintf.i2c_scl_out);
      vintf.addr_in = 0;
      vintf.data_in = 0;
      vintf.reset_in = 1;
      
      @ (negedge vintf.i2c_scl_out);
      vintf.reset_in = 0;
      
    end
    
  endtask
    

endclass