
vlib work

vcom ../src/reg_bank.vhd

vcom ../tb/tb_reg_bank.vhd

vsim -voptargs=+acc=lprn -t ns work.tb_reg_bank

add wave -radix binary sim:/tb_reg_bank/*

run -all
