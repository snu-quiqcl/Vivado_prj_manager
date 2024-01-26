#include "RFSoC_Driver.h"

void EdgeCounter::set_addr(uint64_t addr){
    this->addr          = addr;
    return;
}

void EdgeCounter::flush_fifo(){
    Xil_Out128((this->addr | 0x10), MAKE128CONST(0,1));
}

void EdgeCounter::start_count(){
    Xil_Out128((this->addr),MAKE128CONST(get_timestamp_coarse(),0b0001));
}

void EdgeCounter::stop_count(){
    Xil_Out128((this->addr),MAKE128CONST(get_timestamp_coarse(),0b0010));
}

void EdgeCounter::save_count(){
    Xil_Out128((this->addr),MAKE128CONST(get_timestamp_coarse(),0b0100));
}

void EdgeCounter::reset_count(){
    Xil_Out128((this->addr),MAKE128CONST(get_timestamp_coarse(),0b1000));
}

__uint128_t EdgeCounter::read_count(){
    return Xil_In128(this->addr);
}

__uint128_t EdgeCounter::read_len(){
    return Xil_In128(this->addr|0x10);
}
