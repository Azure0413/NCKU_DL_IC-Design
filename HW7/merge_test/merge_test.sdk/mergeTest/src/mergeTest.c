#include "xparameters.h"
#include "xil_io.h"

int main() {
    u32 a[] = {32,25,16,9,6,5,1};
    u32 b[] = {20,12,10,7,5,3};
    u32 c[13];
    u32 Status;

    for(int i=0; i<7; i++) {
        Xil_Out32(XPAR_MERGE_V1_0_0_BASEADDR + 0xC, a[i]);
    }

    for(int i=0; i<6; i++) {
        Xil_Out32(XPAR_MERGE_V1_0_0_BASEADDR + 0x10, b[i]);
    }

    Xil_Out32(XPAR_MERGE_V1_0_0_BASEADDR, 0x1);  // 啟動操作

    Status = Xil_In32(XPAR_MERGE_V1_0_0_BASEADDR + 4);  // 檢查完成旗標
    while(!Status)
        Status = Xil_In32(XPAR_MERGE_V1_0_0_BASEADDR + 4);

    for(int i=0; i<13; i++) {
        c[i] = Xil_In32(XPAR_MERGE_V1_0_0_BASEADDR + 0x8);
        xil_printf("%d\n\r", c[i]);
    }

    return 0;
}
