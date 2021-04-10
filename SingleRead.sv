//file: SingleRead.sv 

class SingleRead;
  SeqItem seq_obj;
  mailbox m_box;
  mailbox m_box3;
    
  function new(mailbox m_box, mailbox m_box3);
    this.m_box = m_box;
    this.m_box3 = m_box3;					
  endfunction
  
  task single_rd();
    bit random;
    seq_obj = new();
    random = seq_obj.randomize(addr_in);
    random = seq_obj.randomize(write) with {seq_obj.write==1;};
    m_box.put(seq_obj);
    m_box3.put(seq_obj.addr_in);
    m_box3.put(seq_obj.write);
  endtask
    
endclass
