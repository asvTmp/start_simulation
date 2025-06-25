# Печать в консоль запускаемых команд.
transcript on

proc external_editor {filename linenumber} {
    exec {*}[auto_execok start] c:/progs/vscode/code.exe --goto $filename:$linenumber
    return
}
set PrefSource(altEditor) external_editor

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

# Добавить временную диаграму для входного сигнала i_clk.
add wave /tb_counter/clk

# Добавить временную диаграму для выходного сигнала o_count, при этом сигнал отображается в формате UNSIGNED !
add wave -radix UNSIGNED /tb_counter/count

# Шкала времени в ns.
configure wave -timelineunits ns

# Добавить все сигналы тестбенсча в окно временных диаграм (здесь не используется, оставлено для примера).
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
