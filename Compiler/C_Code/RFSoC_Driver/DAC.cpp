#include "RFSoC_Driver.h"

/*
always @( posedge clk ) begin
    if( reset == 1'b1 ) begin
        freq <= 48'h0;
        amp <= 14'h0;
        phase <= 14'h0;
        amp_offset <= 14'h0;
        time_offset <= 64'h0;
        timestamp <= 64'h0;
    end
    
    else begin
        if( selected == 1'b1 ) begin
            timestamp <= gpo_out[127:64];
            case( gpo_out[63:60] )
                4'b0000: begin
                    freq[47:16] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b0001: begin
                    freq[47:0] <= gpo_out[47:0];
                end
                
                4'b0010: begin
                    freq[47:2] <= gpo_out[45:0];
                    amp <= gpo_out[59:46];
                end
                
                4'b0011: begin
                    freq[47:2] <= gpo_out[45:0];
                    phase <= gpo_out[59:46];
                end
                
                4'b0100: begin
                    time_offset[59:0] <= gpo_out[59:0];
                end
                
                4'b0101: begin
                    amp_offset <= gpo_out[13:0];
                end
                
                4'b1000: begin
                    freq[45:14] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1001: begin
                    freq[43:12] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1010: begin
                    freq[41:10] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1011: begin
                    freq[39:8] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1100: begin
                    freq[37:6] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1101: begin
                    freq[35:4] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1110: begin
                    freq[33:2] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1111: begin
                    freq[31:0] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
            endcase
        end
    end
end
*/

void DAC::set_addr(uint64_t addr = (uint64_t) XPAR_DAC_CONTROLLER_0_BASEADDR ){
    this->addr = addr;
    return;
}

void DAC::set_freq(uint64_t freq){
    this->freq          = ((uint64_t)(((long double)freq/(long double)(this->sample_freq))*(((uint64_t)1<<48)-(uint64_t)1))) & MASK48BIT;
    Xil_Out128(this-> addr,MAKE128CONST( get_timestamp_coarse() , (uint64_t)((uint64_t)1 << 60) | (uint64_t)(this->freq) ));
    xil_printf("%llx\r\n",(uint64_t)((uint64_t)1 << 60) | (uint64_t)(this->freq) );
    return;
}

void DAC::set_amp(long double amp){
    this->amp           = ((uint64_t)(amp * ((1 << 15) - 1))) & MASK14BIT;
    Xil_Out128(this-> addr,MAKE128CONST(get_timestamp_coarse(), ((uint64_t)2 << 60) | (uint64_t)((uint64_t)(this->amp) << 46) | (uint64_t)( (uint64_t)(this->freq >> 2) & MASK46BIT) ));
    xil_printf("%llx\r\n",((uint64_t)2 << 60) | (uint64_t)((uint64_t)(this->amp) << 46) | (uint64_t)( (uint64_t)(this->freq >> 2) & MASK46BIT) );
    return;
}

void DAC::set_config(long double amp, uint64_t freq, long double phase, uint64_t shift = 0){
    this->amp           = ((uint64_t)(amp * ((1 << 15) - 1))) & MASK14BIT;
    this->freq          = ((uint64_t)(((long double)freq/(long double)(this->sample_freq))*(((uint64_t)1<<48)-(uint64_t)1))) & MASK48BIT;
    this->phase         = ((uint64_t)(phase * ((1 << 15) - 1))) & MASK14BIT;
    if( shift == 0 ){
        Xil_Out128(this-> addr,MAKE128CONST(get_timestamp_coarse(), (0x0 << 60) | ((this->amp) << 46) | ((this->phase) << 32) | ( (this->freq >> 16) & MASK32BIT) ));
    }
    else{
        Xil_Out128(this-> addr,MAKE128CONST(get_timestamp_coarse(), (0x1 << 63) | (((shift-1) & MASK3BIT) << 60) | ((this->amp) << 46) | ((this->phase) << 32) | ( (this->freq >> ((8 - shift) * 2)) & MASK32BIT) ));
    }
    return;
}

void DAC::flush_fifo(){
    Xil_Out128((this->addr | 0x10),MAKE128CONST(0,1));
}
