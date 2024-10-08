#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2022 by Antmicro Ltd. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(simulator => 1);

$Self->{main_time_multiplier} = 1e-8 / 1e-9;

top_filename("t/t_order.v");

compile(
    timing_loop => 1,
    verilator_flags2 => ["--timescale 10ns/1ns --timing"],
    );

execute(
    );

ok(1);
1;
