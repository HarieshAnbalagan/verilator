// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2003 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

module t (clk);
   input clk;

   int side_effect;

   function int f1;
      input int in;
      f1 = in + 1;
      side_effect += in + 1;
   endfunction

   class Cls;
      static function int initialize();
         return 6;
      endfunction
   endclass

   initial begin
      int got;
      side_effect = 1;
      //
      got = f1(10);
      if (got != 11) $stop;
      if (side_effect != 12) $stop;
      // verilator lint_off IGNOREDRETURN
      f1(20);
      // verilator lint_on IGNOREDRETURN
      if (side_effect != 33) $stop;
      //
      void'(f1(30));
      if (side_effect != 64) $stop;
      //
      void'(Cls::initialize());
      //
      $write("*-* All Finished *-*\n");
      $finish;
   end

endmodule
