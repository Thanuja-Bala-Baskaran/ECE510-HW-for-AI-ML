#include "Vmfcc_top_tb.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <chrono>
#include <iostream>
#include <fstream>
#include <cstdint>
#include "input_array.h"

#define MAX_CYCLES 20000

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vmfcc_top_tb* top = new Vmfcc_top_tb;

    vluint64_t main_time = 0;
    top->clk = 0;
    top->rst = 1;
    top->start = 0;
    top->valid_in = 0;
    top->input_sample = 0;

    // Reset pulse
    for (int i = 0; i < 5; ++i) {
        top->clk = !top->clk;
        top->eval();
        main_time++;
    }
    top->rst = 0;

    // Send start pulse
    top->start = 1;
    top->clk = !top->clk;
    top->eval(); main_time++;
    top->clk = !top->clk;
    top->eval(); main_time++;
    top->start = 0;

auto start = std::chrono::high_resolution_clock::now();

    // Feed 512 samples
    for (int i = 0; i < 512; ++i) {
        top->input_sample = input_frame[i];
        top->valid_in = 1;
        top->clk = !top->clk; top->eval(); main_time++;
        top->clk = !top->clk; top->eval(); main_time++;
    }
    top->valid_in = 0;

    // Wait for done
    while (!top->done && main_time < MAX_CYCLES) {
        top->clk = !top->clk;
        top->eval();
        main_time++;
    }

auto end = std::chrono::high_resolution_clock::now();
std::chrono::duration<double, std::milli> duration = end - start;
std::cout << "\n[INFO] Simulation time = " << duration.count() << " ms\n";


    // Print output
    std::cout << "\n==== MFCC Output Coefficients ====\n";
    std::cout << "MFCC 0  = " << top->mfcc_out_0 << std::endl;
    std::cout << "MFCC 1  = " << top->mfcc_out_1 << std::endl;
    std::cout << "MFCC 2  = " << top->mfcc_out_2 << std::endl;
    std::cout << "MFCC 3  = " << top->mfcc_out_3 << std::endl;
    std::cout << "MFCC 4  = " << top->mfcc_out_4 << std::endl;
    std::cout << "MFCC 5  = " << top->mfcc_out_5 << std::endl;
    std::cout << "MFCC 6  = " << top->mfcc_out_6 << std::endl;
    std::cout << "MFCC 7  = " << top->mfcc_out_7 << std::endl;
    std::cout << "MFCC 8  = " << top->mfcc_out_8 << std::endl;
    std::cout << "MFCC 9  = " << top->mfcc_out_9 << std::endl;
    std::cout << "MFCC 10 = " << top->mfcc_out_10 << std::endl;
    std::cout << "MFCC 11 = " << top->mfcc_out_11 << std::endl;
    std::cout << "MFCC 12 = " << top->mfcc_out_12 << std::endl;

    delete top;
    return 0;
}
