#!/usr/bin/env python3
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2024 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

import vltest_bootstrap

# Very slow on vltmt, and doesn't test much of value there, so disabled
test.scenarios('vlt')
test.top_filename = test.obj_dir + "/t_emit_memb_limit.v"


def gen(filename, n):
    with open(filename, 'w', encoding="utf8") as fh:
        fh.write("// Generated by t_emit_memb_limit.py\n")
        fh.write("module t (i, clk, o);\n")
        fh.write("  input clk;\n")
        fh.write("  input i;\n")
        fh.write("  output logic o;\n")
        for i in range(0, n + 1):
            fh.write("  logic r" + str(i) + ";\n")
        fh.write("  always @ (posedge clk) begin\n")
        fh.write("    r0 <= i;\n")
        for i in range(1, n):
            fh.write("    r" + str(i + 1) + " <= r" + str(i) + ";\n")
        fh.write("    o <= r" + str(n) + ";\n")
        fh.write('    $write("*-* All Finished *-*\\n");' + "\n")
        fh.write('    $finish;' + "\n")
        fh.write("  end\n")
        fh.write("endmodule\n")


# Current limit is 50, so want to test at least 50*50 cases
gen(test.top_filename, 6000)

test.compile(verilator_flags2=[
    "-x-assign fast --x-initial fast",
    "-Wno-UNOPTTHREADS",
    # The slow V3Partition asserts are just too slow
    # in this test. They're disabled just for performance
    # reasons:
    "--no-debug-partition"
])

test.execute()

test.file_grep(test.obj_dir + "/" + test.vm_prefix + "___024root.h", r'struct \{')

test.passes()