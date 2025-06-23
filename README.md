# NCKU_DL_IC-Design  
#### Overview the HW Link
[Homework Link](https://docs.google.com/document/d/1HVf9E9Ei0QdzfQmIFr2N6z5zCAZ3CHaZF7I0mxWH9cg/edit?tab=t.0)  
## Final Project  
#### The project aims to migrate the computationally intensive parts of the YOLOv2 neural network to the programmable logic (PL) part of the FPGA for hardware acceleration, while the processor system (PS) runs software to control the process and handle the remaining tasks.  
![image](https://github.com/Azure0413/NCKU_DL_IC-Design/blob/main/src/Final.png)  
## Homework 1：Approximate Average  
#### Please design a computational system whose transfer function is defined as follows. A series of 8-bit positive integers is generated as the input of the computational system by the test bench. The output value Y is a 10-bit positive integer, which is calculated according to equations (1), (2), (3) and (4).    
![image](https://github.com/Azure0413/NCKU_DL_IC-Design/blob/main/src/HW1.png)  

## Homework 2：Vivado軟硬體開發環境教學
#### 本作業的目的為熟悉 Vivado 的開發環境，Vivado為 Xilinx 公司的全新開發軟體，專用於Xilinx FPGA的軟硬體整合開發，同學需要根據以下步驟逐步完成作業，藉此來了解Vivado開發工具的使用。  

## Homework 3: A running LED Display  
#### 本作業的目的為熟悉如何設置自己的xdc來配合PYNQ-Z2板子上的LED燈，還有如何創建一個clock，在兩者的配合下來實現像是跑馬燈的功能。  

## Homework 4: In-System Debugging Using ILA Core  
#### In-System Debugging是FPGA設計中必要使用方式，目的在於快速設計內部訊號及波形，以發現潛在的錯誤、優化設計並提高系統性能。Vivado內建的ILA Core（Integrated Logic Analyzer）即是一常用In-System Debugging工具。  
#### 1. 透過本作業理解ILA Core的運作原理，學習如何進行信號採樣、波形觀察。  
#### 2. 學習設定ILA Core相關參數，包含設定取樣率、觀察訊號和設定觸發條件。  
#### 3. 通過實際操作ILA Core，在 FPGA運行時分析信號波形，從而快速定位和解決潛在的問題。  
#### 4. 使用Vivado中提供的波形分析工具，檢視和分析信號波形，了解設計運作情況。  

## Homework 5: A Simple Voting Machine using FPGAs with Verilog HDL  
#### 本作業的目標為利用 button 和 switch 來實現投票的效果。同學需要透過板子上的switch和button來完成一個具有投票和開票功能的機器。button 按超過1秒時，LED會閃爍，並會投票給對應的候選人。switch1 用於 reset。switch0 用於切換成投票模式或者是開票模式。投票模式會紀錄票數，在開票模式下按下對應按鈕會利用LED還表示共有幾個人投給對應候選人。  

## Homework 6: Data Transfer between PC and PYNQ-Z2 through UART Interface  
#### In this work, we are going to learn how to communicate between PC and PYNQ using UART. PC will transfer a image to PYNQ through UART. PYNQ will convert the original image to a negative image. Finally, the image will be sent back to the PC.  

## Homework 7: Designing a custom IP for Merge Operation with Xilinx Fifo Generator  
#### 本作業需將Merge Operation的硬體電路包成Vivado的ip，以便放入軟硬整合的系統中，並完成對應的軟體設計來驗證系統的功能。本作業已提供硬體的Verilog code，請同學根據下面的教學完成包裝ip的工作，並使用sdk以及teraterm，來完成系統建置和對應sdk軟體的撰寫。目標 : 將兩個已排序好的陣列合併成一個排序好的陣列，設計一個merge operation的IP，陣列資料由處理器傳輸,合併完成的陣列也必須讀回處理器，Merge Operation(由大到小排列)  

## Homework 8：CDMA系統建立與資料傳輸  
#### 本作業須使用Xilinx IP和自製的IP來完成一套乘法的系統，此系統由CDMA搬運資料至Block memory，由硬體計算完畢後再由CDMA將資料搬回ZYNQ，本作業提供mul16.v，請同學自行包成Vivado 可用的ip，並完成系統建置和jupyter軟體設計。  

## Homework 9：設計Convolution運算系統 
#### 此作業同學必須自行完成convolution運算，作業會提供input和golden，其中input有包含input、weight和bias等資訊，同學必須自行放入系統，而golden則是正確答案給同學參考。這個作業的目的是讓同學先用 ASIC flow 實作 convolution 為之後在 FPGA 上合成做準備。ASIC合成工具會不計任何代價根據使用者的要求合成所需的硬體，FPGA 上硬體設計的自由度沒有那麼高，需要使用者配合底層的架構來設計。因為 FPGA 上合成的條件比較嚴苛，建議同學在這個作業中，一個 cycle 只進行一次乘加運算，如果在FPGA上的同一個cycle進行多個乘加運算，會超過FPGA的cycle time constraint，因此建議同學在設計架構的時候就將這點納入考慮。  

## Homework 10：FPGA實作Convolution運算系統  
#### 此作業同學必須自行完成convolution運算的ip，並用此ip來完成一個系統，作業會提供input.hex和golden.hex(至HW10_submission下載)，同學須自行將input.hex內容讀入系統，而golden.hex則是正確答案給同學參考，此作業的軟體部分需自行將運算後的結果與golden.hex比對，結果必須完全一樣，才算是功能正確，軟體端除了搬運資料外，不得有太多運算，全部的convolution運算必須在convolution ip中完成。  
![image](https://github.com/Azure0413/NCKU_DL_IC-Design/blob/main/src/hw10.png)
