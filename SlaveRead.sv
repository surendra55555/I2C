//SlaveRead.sv

class SlaveRead;
  logic [3:0] count;
  SeqItem seq_obj2;
  virtual seq_intf vintf;
  int i;
  
  function new(virtual seq_intf vintf);
   this.vintf = vintf;
  endfunction
  
  task slvread();
    seq_obj2 = new();
    
    //Address wait
    for(count=0; count<8; count=count+1) begin
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = 1;
    end
    
    //Address ack
    @ (negedge vintf.i2c_scl_out);
    vintf.sda_in = 0;
    
    //Data input
    for(int i=0; i<8; i=i+1) begin
      @ (negedge vintf.i2c_scl_out);
      vintf.sda_in = seq_obj2.variable[i];
    end
    
    
    //Data ack
    @ (negedge vintf.i2c_scl_out);
    vintf.sda_in=0;
    
    @ (negedge vintf.i2c_scl_out);
    vintf.sda_in=1;
    
    
    //Reseting
    //@ (negedge vintf.i2c_scl_out);
    vintf.addr_in = 0;
    vintf.data_in = 0;
    vintf.reset_in=1;
    
    //@ (negedge vintf.i2c_scl_out);
    vintf.reset_in = 0;
    
    //Display statements
    $display("sda_in random var: %b", seq_obj2.variable);
    
  endtask
  
endclass
