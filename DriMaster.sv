//file: DriMaster.sv

class Driver;
  SeqItem seq_obj1;
  mailbox m_box;
  virtual seq_intf vintf;
   
  	//constructor, getting mailbox handle
  function new(mailbox m_box, virtual seq_intf vintf);
    this.m_box = m_box;
    this.vintf = vintf;
  endfunction
  
  task drive(input int x);
    int count;
    seq_obj1 = new();
    repeat (x) begin
       //getting SeqItem from mailbox
      m_box.get(seq_obj1);
      if (seq_obj1.write==0) begin
        $display($time,"Driver: address=%b data=%b write=%b", seq_obj1.addr_in, seq_obj1.data_in, seq_obj1.write);
      end
      
      else begin
        $display($time,"Driver: address=%b write=%b", seq_obj1.addr_in, seq_obj1.write);
       end
    
    vintf.addr_in = seq_obj1.addr_in;
    vintf.data_in = seq_obj1.data_in;
    vintf.write = seq_obj1.write;
  
    end
    
  endtask

endclass
         