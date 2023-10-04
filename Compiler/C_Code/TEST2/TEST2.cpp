#include "RFSoC_Driver.h"
/*#define MAKE128CONST(hi,lo) ((((__uint128_t)hi << 64) | (lo)))

static INLINE void Xil_Out128(UINTPTR Addr, __uint128_t Value)
{
	volatile __uint128_t *LocalAddr = (volatile __uint128_t *)Addr;
	*LocalAddr = Value;
}
*/
int main(){
    TimeController tc;
    TTL_out ttl_0;
    DAC dac_0;
    /*Xil_Out128(tc.addr,MAKE128CONST(0,0));
    Xil_Out128(tc.addr,MAKE128CONST(0,2));
    Xil_Out128(ttl_0.addr,MAKE128CONST(10,1));
    Xil_Out128(tc.addr,MAKE128CONST(0,9));
    */
    tc.auto_stop();
    tc.reset();

    ttl_0.set(0);
    delay_coarse(8);
    dac_0.set_freq(400);

    tc.auto_stop();
    tc.auto_start();

    delay_coarse(1000);

    for(int i = 0; i < 200; i++ ){
        delay_coarse(100000000);
        ttl_0.set(i%2);
    }
}
