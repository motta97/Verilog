module parity;
  reg[31:0] addr;
  reg parity;
  
  
  always @(addr)begin
    parity = calc_parity(addr);
    $display("Parity calculated = %b", parity );
  end
  function calc_parity;
    input [31:0] address;
    calc_parity = ^address;
  endfunction
endmodule
