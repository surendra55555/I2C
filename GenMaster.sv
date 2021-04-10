//file: GenMaster.sv for single write

// randomize the properties and send to driver


class SingleWrite;  //  Single write Generator
  SeqItem seq_obj;
  mailbox m_box;
  mailbox m_box3;
  
  //constructor, getting mailbox handle
  
  function new(mailbox m_box, mailbox m_box3);
    this.m_box = m_box;
    this.m_box3 = m_box3;
  endfunction
  
  task single_wr(input int x);
    logic random;
    seq_obj= new();
    repeat (x) begin
      random = seq_obj.randomize() with {seq_obj.write==0;};
      m_box.put(seq_obj);
      m_box3.put(seq_obj.addr_in);
      m_box3.put(seq_obj.write);
      m_box3.put(seq_obj.data_in);
      #44;
     end
    
  endtask
  
endclass  
    