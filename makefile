all: executa limpa
executa:
	ghdl -a --ieee=synopsys -fexplicit *.vhd
	ghdl -e --ieee=synopsys -fexplicit tb_main_processor 
	./tb_main_processor --stop-time=10ns --vcd=EXECUTA.vcd
	gtkwave EXECUTA.vcd &

limpa:
	@echo "uhul"

	
