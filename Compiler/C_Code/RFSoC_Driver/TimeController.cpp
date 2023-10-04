#include "RFSoC_Driver.h"

void TimeController::reset(){
    Xil_Out128(this-> addr, MAKE128CONST((uint64_t)0,(uint64_t)2));
}

void TimeController::auto_start(){
    Xil_Out128(this-> addr, MAKE128CONST((uint64_t)0,(uint64_t)9));
}

void TimeController::auto_stop(){
    Xil_Out128(this-> addr, MAKE128CONST((uint64_t)0,(uint64_t)0));
}
