#include "RFSoC_Driver.h"

void TimeController::reset(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)2);
}

void TimeController::auto_start(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)9);
}

void TimeController::auto_stop(){
    reg128_write(this-> addr,(uint64_t)0,(uint64_t)0);
}
