// Code your design here
//************************************************************/
// I2C controller Design for write and  read operation
// class based environment in SV
// File Name      : i2c_master.v
// Description    : To design the I2C controller
/************************************************************/

module i2c_master(
                     addr_in,
                     data_in,
                     write,
                     clk_in,
                     reset_in,
                     sda_in,
                     i2c_sda_out,
                     i2c_scl_out,
                     read_out
                  );
  input        clk_in;
  input        reset_in;
  input	       [6:0]addr_in;
  input        [7:0]data_in;
  output reg   i2c_sda_out;
  output reg   i2c_scl_out;
  output reg   [7:0]read_out;
  reg          [2:0]acount;
  reg          [2:0]dcount;
  reg          sda_en;
  reg          sda_out;
  input        write;
  reg          scl_en;
  input        sda_in;
  reg          [2:0]state;
  reg          [2:0]next_state;
  reg          [7:0]i2c_slave_in;
  //Parameter state definitions
  parameter IDLE      =0;
  parameter START     =1;
  parameter ADDRESS   =2;
  parameter READ_WRITE=3;
  parameter ADDR_ACK  =4;
  parameter DATA      =5;
  parameter DATA_ACK  =6;
  parameter STOP      =7;
    

  //Present state logic
  always@(negedge clk_in)begin
    if(reset_in)begin
      state<=IDLE;
      read_out=0;
      i2c_slave_in=0;
    end
    else begin
      state<=next_state;
      if(state==ADDRESS)
        acount<=acount-1;
      else if(state==DATA)
        dcount<=dcount-1;
    end
  end
   
  
  //Next state logic
  always@(state,addr_in,data_in,dcount,acount)begin
      case (state)
      IDLE    :begin
                 scl_en=0;
                 sda_out=1;
                 sda_en=1;
                 acount=6;
                 dcount=7;
                 if(addr_in!=0) begin
                   next_state=START;
                 end
                 else begin
                   next_state=IDLE;
                 end
               end
               
      START   :begin
                 scl_en=0;
                 sda_out=0;
                 sda_en=1;
                 next_state=ADDRESS;
               end
              
               
      ADDRESS :begin
                 scl_en=1;
                 sda_en=1;
                 sda_out=addr_in[acount];
                 if(acount!=0)begin
                   next_state=ADDRESS;
                 end
                 else if(acount==0) begin
                   next_state=READ_WRITE;
                 end 
               end
      READ_WRITE:begin
                   scl_en=1;
                   sda_en=1;
                   if(write==0)begin
                     sda_out=1'b0;
                     next_state=ADDR_ACK;
                   end
                   else if(write==1)begin
                     sda_out=1'b1;
                     next_state=ADDR_ACK;
                   end  
                   else begin
                     sda_out=1'b1;
                     next_state=ADDR_ACK;
                   end
                 end
      ADDR_ACK  :begin
                   scl_en=1;
                   if(sda_in==0)begin
                     sda_en=0;
                     next_state=DATA;
                   end
                   else begin
                     sda_en=1;
                     next_state=STOP;
                   end
                 end
      DATA       :begin
                    if(write==0)begin
                    scl_en=1;
                    sda_en=1;
                    sda_out=data_in[dcount];
                    if(dcount!=0)begin;
                      next_state=DATA;
                    end
                    else if(dcount==0) begin
                      next_state=DATA_ACK;
                    end
                  end
                  if(write==1)begin
                    scl_en=1;
                    sda_en=0;
                     sda_out=sda_in;
                      i2c_slave_in[dcount]=sda_in;
                      if(dcount!=0)begin;
                        next_state=DATA;
                      end
                      else if(dcount==0&&next_state!=DATA_ACK) begin
                        next_state=DATA_ACK;
                      end
                    end
                  end
      
                      
      DATA_ACK   :begin
                     scl_en=1;
                     if(write==0)begin
                       if(sda_in==0)begin
                         sda_en=0;
                         next_state=STOP;
                       end
                       else begin
                         sda_en=1;
                         next_state=STOP;
                       end
                     end
                     else if(write==1)begin
                       sda_out=0;
                       if(sda_out==1)begin
                         sda_en=1;
                         next_state=STOP;
                       end
                       else begin
                         sda_en=1;
                         next_state=STOP;
                       end
                     end
                   end
      STOP       :begin
                    read_out=i2c_slave_in;
                    scl_en=0;
                    sda_out=0;
                    next_state=IDLE;
                    sda_en=1;
                  end
    endcase
  end   
  
  assign i2c_scl_out=(scl_en)?clk_in:1'b1;
  assign i2c_sda_out=(sda_en)?sda_out:sda_in;
      
endmodule             