// Monitor.sv

class Monitor;
  logic [3:0] count;
  SeqItem  seq_obj;
  mailbox m_box2;
  virtual seq_intf vintf;
  
  function new(mailbox m_box2, virtual seq_intf vintf);
    this.m_box2 = m_box2;
    this.vintf=vintf;
  endfunction
  
  task mon(input int x);
    seq_obj = new();
    repeat (x) begin
      if(vintf.write==0) begin
    
        //Address
        @ (negedge vintf.i2c_scl_out); 
        for(count=0; count<7; count=count+1) begin
          @ (negedge vintf.i2c_scl_out);
          seq_obj.addr_in[count] = vintf.i2c_sda_out;
          $display("monitor:count=%d addr=%b time=%0t", count, seq_obj.addr_in, $time);
        end
        
        $display($time,"Monitor: addr=%b", seq_obj.addr_in);
        m_box2.put(seq_obj.addr_in);
        
        //Write
        @ (negedge vintf.i2c_scl_out);
        seq_obj.write = vintf.i2c_sda_out;
        $display($time,"Monitor: write=%b", seq_obj.write);
        m_box2.put(seq_obj.write);
        
        @ (negedge vintf.i2c_scl_out); //ack delay
        
        //Data
        @ (negedge vintf.i2c_scl_out);
        for(count=8; count>0; count=count-1) begin
          seq_obj.data_in[count-1] = vintf.i2c_sda_out;
          $display("monitor:count=%d data=%b time=%0t", count, seq_obj.data_in, $time);
          @ (negedge vintf.i2c_scl_out);
        end
        
        m_box2.put(seq_obj.data_in);
        $display($time,"Monitor: data=%b", seq_obj.data_in);
      end
      
      else if(vintf.write==1) begin
        
        //Address
        @ (negedge vintf.i2c_scl_out); 
        for(count=0; count<7; count=count+1) begin
          @ (negedge vintf.i2c_scl_out);
          seq_obj.addr_in[count] = vintf.i2c_sda_out;
          $display("monitor:count=%d addr=%b time=%0t", count, seq_obj.addr_in, $time);
        end
        
        $display("Monitor: addr=%b", seq_obj.addr_in);
        m_box2.put(seq_obj.addr_in);
        
        //Write
        @ (negedge vintf.i2c_scl_out);
        seq_obj.write = vintf.i2c_sda_out;
        $display("Monitor: write=%b", seq_obj.write);
        m_box2.put(seq_obj.write);
        
        @ (negedge vintf.i2c_scl_out); //ack delay
        
        //Data
        @ (negedge vintf.i2c_scl_out);
        for(count=8; count>0; count=count-1) begin
          seq_obj.data_in[count-1] = vintf.i2c_sda_out;
          $display("monitor: count=%d data=%b time=%0t", count, seq_obj.data_in, $time);
          @ (negedge vintf.i2c_scl_out);
        end
        
        m_box2.put(seq_obj.data_in);
        $display("Monitor: data=%b", seq_obj.data_in);
      end
      
    end
    
  endtask
  
endclass  