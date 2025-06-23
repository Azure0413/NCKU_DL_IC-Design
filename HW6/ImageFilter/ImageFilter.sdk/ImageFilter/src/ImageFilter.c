#include <stdio.h>
#include <stdlib.h>
#include "xil_types.h"
#include "xuartps.h"
#include "xparameters.h"
#include "platform.h"
#include "sleep.h"

#define imageSize 512*512
#define headerSize 1080
#define fileSize imageSize+headerSize

int main(){
    init_platform();
    u8 *imageData;
    imageData = malloc(sizeof(u8)*(fileSize));

    u32 status;
    XUartPs_Config *myUartConfig;
    XUartPs myUart;
    myUartConfig = XUartPs_LookupConfig(XPAR_PS7_UART_0_DEVICE_ID);
    status = XUartPs_CfgInitialize(&myUart, myUartConfig, myUartConfig->BaseAddress);
    if(status != XST_SUCCESS)
        print("Uart initialization failed...\n\r");

    status = XUartPs_SetBaudRate(&myUart, 115200);
    if(status != XST_SUCCESS)
        print("Baudrate init failed...\n\r");

    u32 receivedBytes = 0;
    u32 totalReceivedBytes = 0;
    while(totalReceivedBytes < fileSize){
        receivedBytes = XUartPs_Recv(&myUart, (u8*)&imageData[totalReceivedBytes], 100);
        totalReceivedBytes += receivedBytes;
    }

    for (int i=headerSize; i<fileSize; i++){
        imageData[i] = 255 - imageData[i];
    }

    u32 transmittedBytes = 0;
    u32 totalTransmittedBytes = 0;
    while(totalTransmittedBytes < fileSize){
        transmittedBytes = XUartPs_Send(&myUart, (u8*)&imageData[totalTransmittedBytes], 1);
        totalTransmittedBytes += transmittedBytes;
        usleep(2000);
    }

    cleanup_platform();
    return 0;
}
