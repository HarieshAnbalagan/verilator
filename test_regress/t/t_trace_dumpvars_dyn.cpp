// -*- mode: C++; c-file-style: "cc-mode" -*-
//
// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2022 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

#include <verilated.h>
#if VM_TRACE_FST
#include <verilated_fst_c.h>
#define TRACE_FILE_NAME "simx.fst"
#define TRACE_CLASS VerilatedFstC
#elif VM_TRACE_VCD
#include <verilated_vcd_c.h>
#define TRACE_FILE_NAME "simx.vcd"
#define TRACE_CLASS VerilatedVcdC
#elif VM_TRACE_SAIF
#include <verilated_saif_c.h>
#define TRACE_FILE_NAME "simx.saif"
#define TRACE_CLASS VerilatedSaifC
#endif

#include <memory>

#include VM_PREFIX_INCLUDE

unsigned long long main_time = 0;
double sc_time_stamp() { return (double)main_time; }

const unsigned long long dt_2 = 3;

int main(int argc, char** argv) {
    Verilated::debug(0);
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);

    std::unique_ptr<VM_PREFIX> top{new VM_PREFIX{"top"}};

    std::unique_ptr<TRACE_CLASS> tfp{new TRACE_CLASS};

#if defined(T_TRACE_DUMPVARS_DYN_VCD_0) || defined(T_TRACE_DUMPVARS_DYN_FST_0) \
    || defined(T_TRACE_DUMPVARS_DYN_SAIF_0)
    tfp->dumpvars(0, "");
#elif defined(T_TRACE_DUMPVARS_DYN_VCD_1) || defined(T_TRACE_DUMPVARS_DYN_FST_1) \
    || defined(T_TRACE_DUMPVARS_DYN_SAIF_1)
    tfp->dumpvars(99, "t");  // This should not match "top."
    tfp->dumpvars(1, "top.t.cyc");  // A signal
    tfp->dumpvars(1, "top.t.sub1a");  // Scope
    tfp->dumpvars(2, "top.t.sub1b");  // Scope
#else
#error "Bad test"
#endif

    top->trace(tfp.get(), 99);
    tfp->open(VL_STRINGIFY(TEST_OBJ_DIR) "/" TRACE_FILE_NAME);
    top->clk = 0;

    while (main_time <= 20) {
        top->eval();
        tfp->dump((unsigned int)(main_time));
        ++main_time;
        top->clk = !top->clk;
    }
    tfp->close();
    top->final();
    tfp.reset();
    top.reset();
    printf("*-* All Finished *-*\n");
    return 0;
}
