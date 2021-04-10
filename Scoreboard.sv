// Scoreboard.sv

class Scoreboard;
  SeqItem seq_obj;
  logic [7:0] derived_output;
  logic [7:0] generated_input;
  
  mailbox m_box2;
  mailbox m_box3;
  virtual seq_intf vintf;
  
  function new(mailbox m_box2, mailbox m_box3);
    this.m_box2 = m_box2;
    this.m_box3 = m_box3;
  endfunction
  
  task score_write(input int x);
    seq_obj = new();
    repeat (x) begin
    
      //Address
      m_box2.get(seq_obj.addr_in);
      derived_output [6:0] = seq_obj.addr_in;
      $display($time, "DUT score addr: %b", seq_obj.addr_in);
      
      m_box3.get(seq_obj.addr_in);
      generated_input [6:0] = seq_obj.addr_in;
      $display($time, "Generated score addr: %b", seq_obj.addr_in);
      
      if (derived_output [6:0] == generated_input [6:0])
        $display("SCOREBOARD addr output is same\n");
      else
        $display("SCOREBOARD addr output is diffrent\n");
      
      // Write
      m_box2.get(seq_obj.write);
      derived_output[0] = seq_obj.write;
      $display($time, "DUT score write: %b", seq_obj.write);
      
      m_box3.get(seq_obj.write);
      generated_input [0] = seq_obj.write;
      $display($time, "Generated score write: %b", seq_obj.write);
      if (derived_output [0] == generated_input[0])
        $display("SCOREBOARD write output is same\n");
      else
        $display("SCOREBOARD write output is diffrent\n");
      
      m_box2.get(seq_obj.data_in);
      derived_output = seq_obj.data_in;
      $display($time, "DUT score data: %b", seq_obj.data_in);
      
      m_box3.get(seq_obj.data_in);
      generated_input = seq_obj.data_in;
      $display($time, "Generated score data: %b", seq_obj.data_in);
      if (derived_output == generated_input)
        $display("SCOREBOARD data output is same\n");
      else begin
        $display("SCOREBOARD data output is diffrent\n");
      end
    end
  endtask
  
  
  task score_read();
    seq_obj = new();
    
    // Address
    m_box2.get(seq_obj.addr_in);
    derived_output [6:0] = seq_obj.addr_in;
    $display($time, "DUT score addr: %b", seq_obj.addr_in);
    
    m_box3.get(seq_obj.addr_in);
    generated_input [6:0] = seq_obj.addr_in;
    $display($time, "Generated score addr: %b", seq_obj.addr_in);
    if (derived_output [6:0] == generated_input[6:0])
      $display("SCOREBOARD addr output is same\n");
    else
      $display("SCOREBOARD addr output is diffrent\n");
    
    // Write
    m_box2.get(seq_obj.write);
    derived_output [0] = seq_obj.write;
    $display($time, "DUT score write: %b", seq_obj.write);
    
    m_box3.get(seq_obj.write);
    generated_input[0] = seq_obj.write;
    $display($time, "Generated score write: %b", seq_obj.write);
    if (derived_output [0] == generated_input[0])
      $display("SCOREBOARD write output is same\n");
    else
      $display("SCOREBOARD write output is diffrent\n");
    
     
    // Data
    m_box2.get(seq_obj.data_in);
    derived_output = seq_obj.data_in;
    $display($time, "DUT score data: %b", seq_obj.data_in);
    
    generated_input = seq_obj.variable;
    $display($time, "Generated score data: %b", seq_obj.variable);
    
    if (derived_output == generated_input)
      $display("SCOREBOARD data output is same\n");
    else begin
      $display("SCOREBOARD data output is diffrent\n");
    end
  endtask
endclass