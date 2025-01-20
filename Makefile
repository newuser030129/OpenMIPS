verdo: clean com sim verdi

com:
	vcs -sverilog -R +define+FSDB +v2k -fsdb -debug_all -full64 -f file.list -l com.log -o simv

sim:
	./simv -l sim.log

clean:
	rm -rf *.vpd *.log csrc *.key DVE* simv* *.svf *.vcd *.conf *.rc *.dat *.fsdb verdiLog

dve:
	dve -full64

des:
	design_vision

verdi:
	verdi -nologo -f file.list -ssf *.fsdb
