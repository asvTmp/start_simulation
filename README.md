# Создание и моделирование проектов на verilog в ModelSim(QuestaSim)
## Создать следующие файлы
### 1. Исходный файл проекта на языке verilog ``counter.v``.
```verilog
`timescale 1ns / 1ns
module counter (
    input wire clk, 
    input wire reset,
    output wire [7:0] count
);

    reg [7:0] count_r;
    always @ (posedge clk or posedge reset)
        if (reset)
            count_r = 8'h00;
        else
            count_r <= count_r + 8'h01;
    
    assign count = count_r;

endmodule
```
### 2. Исходный файл test-bench - тестовых воздействий на языке system verilog ``tb_counter.sv``.
```verilog
`timescale 1ns / 1ns
module tb_counter;

logic clk, reset;
logic [7:0] count;

counter dut (
    .clk(clk),
    .reset(reset),
    .count(count)
);

initial // Clock generator
  begin
    clk = 0;
    forever #10 clk = !clk;
  end
  
initial	// Test stimulus
  begin
    reset = 0;
    #5 reset = 1;
    #49 reset = 0;
    #1;
    #200;
    $stop();
  end
  
initial
    $monitor("[$monitor] time=%0t reset=%b clk=%b count=0x%02h" ,$stime, reset, clk, count); 
    
endmodule 
```
### 3. Файл скрипта, DO - файл, с командами для запуска моделирования в Modelsim, без создания проекта. ``start.do``
```bash
# Печать в консоль запускаемых команд.
transcript on

# Удаление директории и библиотеки, если существует.
if {[file exists work]} { 
	vdel -lib work -all
}

# Создание библиотеки
vlib work

# Компиляция исходника счетчика.
vlog -work work counter.v

# Компиляция тестового файла.
vlog -work work tb_counter.sv

# Запуск симуляции, tb - имя модкля теста.
vsim -t 1ps -L work -voptargs="+acc"  tb_counter

# Добавить временную диаграму для входного сигнала clk.
add wave /tb_counter/clk

# Добавить временную диаграму для выходного сигнала count, при этом сигнал отображается в формате UNSIGNED !
add wave -radix UNSIGNED /tb_counter/count

# Шкала времени в ns.
configure wave -timelineunits ns

# Добавить все сигналы тестбенсча в окно временных диаграм.
add wave -divider TOP
add wave *

# Просмотр структуры проекта
# view structure

# Просмотр сигналов проекта
# view signals

# Запуск 
run 500 ns

# Показать временные диаграмы по всей длинне окна. 
wave zoom full

```


## Запуск моделирования   
1. Перейти в деректорию с файлами.  
2. Запустить скрипт.  
    ```bash
    [QUESTASIM_DIR]/win64/questasim.exe -do start.do
    ```