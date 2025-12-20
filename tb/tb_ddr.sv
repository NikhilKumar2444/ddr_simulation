module tb_ddr;

	logic clk,rst;
	logic req_valid;
	logic [15:0] addr;

	ddr_top dut(.clk(clk),
		.rst(rst),
		.req_valid(req_valid),
		.addr(addr)
	);

	initial clk = 0;
	always #5 clk = ~clk;

	initial begin
		rst = 0;
		req_valid = 0;
		addr = 0;
		#20 rst = 1;

		addr = 16'h1234;
		req_valid = 1;
		#10 req_valid = 0;
		#200;
		req_valid = 1;
		#10 req_valid = 0;
		#500 $finish;
	end	

endmodule