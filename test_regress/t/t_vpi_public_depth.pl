#!/usr/bin/env perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2010 by Wilson Snyder. This program is free software; you
# can redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
# SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0

scenarios(simulator => 1);

skip("Known compiler limitation")
    if $Self->cxx_version =~ /\(GCC\) 4.4/;

compile(
    make_top_shell => 0,
    make_main => 0,
    make_pli => 1,
    iv_flags2 => ["-g2005-sv"],
    verilator_flags2 => ["+define+USE_DOLLAR_C32 --exe --vpi --no-l2name $Self->{t_dir}/t_vpi_public_depth.cpp --public-depth 3"],
    make_flags => 'CPPFLAGS_ADD=-DTEST_VPI_PUBLIC_DEPTH',
    );

execute(
    use_libvpi => 1,
    v_flags2,
    );

ok(1);
1;
