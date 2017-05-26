#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"

// Address definitions
#define BA 0x40000000
#define AO_IN_0  0x0
#define AO_OUT_0 0x4
#define AO_ENB_0 0x8
#define AO_IN_1  0xC
#define AO_OUT_1 0x10
#define AO_ENB_1 0x14

int main()
{
    u32 volatile value;

    init_platform();

    // set GPIO_1 to output
    Xil_Out32(BA + (AO_ENB_1), 0xFF);

    while(1){
    	print("Display SW3:0 on LED3:0\n\r");
    	// read in value of SW/BTN
    	value =	Xil_In32(BA + (AO_IN_0));
    	// display on LED
    	Xil_Out32(BA + (AO_OUT_1), value);
    }

    cleanup_platform();
    return 0;
}
