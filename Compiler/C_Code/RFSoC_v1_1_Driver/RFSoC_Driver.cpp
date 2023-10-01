#include "RFSoC_Driver.h"

static current_timestamp = 0;

static int64_t get_full_timestamp(){
    return current_timestamp;
}

static int64_t get_timestamp(){
    return (current_timestamp >> 3);
}

static void delay(int64_t time){
    current_timestamp += time;
}

static void delay_coarse(int64_t time){
    current_timestamp += (time << 3);
}

static void set_timestamp(int64_t time){
    current_timestamp = time;
}

static void set_timestamp_coarse(int64_t time){
    current_timestamp = (time << 3);
}
