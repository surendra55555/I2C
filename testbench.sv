/*----------------------------
File Name : I2C_CL_TB_GS_EX5
Description : I2C 
Date		:02-11-2020
Author      : surendra
-----------------------------*/

`define N 3

`include "Interface_i2c.sv"
`include "SeqItemMaster.sv"    // Transaction / SeqItem
`include "GenMaster.sv"			//  Single write Generator
`include "DriMaster.sv"			// Driver _ Master
`include "SingleRead.sv"		// Single Read
`include "DriSlave.sv"			// Slave Driver
`include "SlaveRead.sv"			// Slave Read
`include "Monitor.sv"
`include "Scoreboard.sv"
import uvm_pkg::*;

  import i2c_pkg::*;

module i2c_master_tb();
  
  bit clk_in, reset_in;
  seq_intf intf (clk_in, reset_in);
  
  SingleWrite s_wr_obj;
  SingleRead s_rd_obj;
  Driver d_obj;
  DrvSlaveWr slv_d_wr_obj;
  SlaveRead slv_d_rd_obj;
  Monitor m_obj;
  Scoreboard s_obj;
  mailbox m_box;
  mailbox m_box2;
  mailbox m_box3;
  
  
  //clock generation
  initial clk_in=0; 
  always #1 clk_in=~clk_in;	
    
    //Instance for design
  i2c_master inst_i2c( 
    				.addr_in(intf.addr_in),
    				.data_in(intf.data_in),
    				.write(intf.write),
    				.clk_in(clk_in),
                    .reset_in(reset_in),
    				.sda_in(intf.sda_in),
    				.i2c_sda_out(intf.i2c_sda_out),
    				.i2c_scl_out(intf.i2c_scl_out),
    				.read_out(intf.read_out)
  					);
  
  
  initial begin
    reset_in = 1;
    #2 reset_in = 0;
    m_box = new();
    m_box2 = new();
    m_box3 = new();
    s_wr_obj = new(m_box,m_box3);
    s_rd_obj = new(m_box,m_box3);
    d_obj = new(m_box, intf);
    slv_d_wr_obj = new(intf);
    slv_d_rd_obj = new(intf);
    m_obj = new(m_box2, intf);
    s_obj = new(m_box2, m_box3);
    
    test1(); // Write operation task
    test2();  //  Read operation task
    
  end
 
  task test1();      // Read operation
      fork
        s_wr_obj.single_wr(`N);
        d_obj.drive(`N);
        slv_d_wr_obj.drvslave(`N);
        m_obj.mon(`N);
        s_obj.score_write(`N);
      join
    endtask
    
    task test2();  // Read operation
      fork
        s_rd_obj.single_rd();
        d_obj.drive(`N);
        slv_d_rd_obj.slvread();
        m_obj.mon(`N);
        s_obj.score_read();
      join
    endtask 	
  
  initial begin //Waveform generation
    $dumpfile("dump.vcd");
    $dumpvars();
    
     #200 $finish();
  end
  
endmodule
  
