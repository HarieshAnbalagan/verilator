#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2020 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

# Test tracing with two models instanced
scenarios(vlt_all => 1);

top_filename("t_trace_two_a.v");

compile(
    make_main => 0,
    verilator_make_gmake => 0,
    top_filename => 't_trace_two_b.v',
    vm_prefix => 'Vt_trace_two_b',
    verilator_flags2 => ['-trace'],
    );

run(
    logfile => "$Self->{obj_dir}/make_first_ALL.log",
    cmd => ["make", "-C", "$Self->{obj_dir}", "-f", "Vt_trace_two_b.mk", "Vt_trace_two_b__ALL.cpp"]
    );

compile(
    make_main => 0,
    top_filename => 't_trace_two_a.v',
    verilator_flags2 => ['-exe', '-trace', "$Self->{t_dir}/t_trace_two_cc.cpp"],
    v_flags2 => ['+define+TEST_DUMP'],
    );

execute(
    );

if ($Self->{vlt_all}) {
    file_grep("$Self->{obj_dir}/simx.vcd", qr/\$enddefinitions/);
    vcd_identical("$Self->{obj_dir}/simx.vcd", $Self->{golden_filename});
}

ok(1);
1;
