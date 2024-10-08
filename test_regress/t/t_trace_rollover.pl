#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2013 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(vlt_all => 1);

top_filename("t_trace_cat.v");

compile(
    make_top_shell => 0,
    make_main => 0,
    v_flags2 => ["--trace --exe $Self->{t_dir}/t_trace_rollover.cpp"],
    );

execute(
    );

system("cat $Self->{obj_dir}/simrollover_cat*.vcd "
       . " > $Self->{obj_dir}/simall.vcd");

vcd_identical("$Self->{obj_dir}/simall.vcd",
              $Self->{golden_filename});

file_grep_not("$Self->{obj_dir}/simrollover_cat0000.vcd", qr/^#/);
file_grep("$Self->{obj_dir}/simrollover_cat0001.vcd", qr/^#/);
file_grep("$Self->{obj_dir}/simrollover_cat0002.vcd", qr/^#/);

ok(1);
1;
