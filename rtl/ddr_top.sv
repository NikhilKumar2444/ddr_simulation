module ddr_top(
	input logic clk,
	input logic rst,
	input logic req_valid,
	input logic [15:0] addr
);

logic [3:0] act, rd, pre;
logic [3:0] data_valid;

ddr_controller(
	.clk(clk),
	.rst(rst),
	.req_valid(req_valid),
	.addr(addr),
	.act(act),
	.rd(rd),
	.pre(pre)
);

genvar i;
generate 
	for(i =0;i<4;i++) begin: BANKS
		ddr_bank bank(
			.clk(clk),
			.rst(rst),
			.act(act[i]),
			.rd(rd[i]),
			.pre(pre[i]),
			.row_addr(addr[15:8]),
			.ready(),
			.data_valid(data_valid[i])
		);
	end
endgenerate

endmodule
