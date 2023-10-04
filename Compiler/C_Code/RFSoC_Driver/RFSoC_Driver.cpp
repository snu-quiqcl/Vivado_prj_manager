#include "RFSoC_Driver.h"

static int64_t current_timestamp = 0;

int64_t get_timestamp(){
    return current_timestamp;
}

int64_t get_timestamp_coarse(){
    return (current_timestamp >> 3);
}

void delay(int64_t time){
    current_timestamp += time;
}

void delay_coarse(int64_t time){
    current_timestamp += (time << 3);
}

void set_timestamp(int64_t time){
    current_timestamp = time;
}

void set_timestamp_coarse(int64_t time){
    current_timestamp = (time << 3);
}
