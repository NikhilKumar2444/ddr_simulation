module ddr_bank #(
	parameter int tRCD = 4,
	parameter int tCL = 4,
	parameter int tRP = 4,
	parameter int tRAS = 8
)(
	input logic clk,
	input logic rst,
	input logic act,
	input logic rd,
	input logic pre,
	input logic [7:0] row_addr,
	output logic ready,
	output logic data_valid
);
typedef enum logic [1:0] {IDLE, ACTIVE, PRECHARGE} state_t;
state_t state;
logic [7:0] open_row;
int rcd_cnt, cl_cnt, ras_cnt, rp_cnt;
always_ff @(posedge clk or negedge rst) begin
	if(!rst) begin
		state <= IDLE;
		open_row <= '0;
		rcd_cnt <= 0;
		cl_cnt <= 0;
		ras_cnt <= 0;
		rp_cnt <= 0;
		data_valid <= 0;
	end else begin
		data_valid <= 0;
		if(rcd_cnt > 0) rcd_cnt--;
		if(cl_cnt > 0 ) cl_cnt --;
		if(ras_cnt > 0) ras_cnt --;
		if(rp_cnt >  0) rp_cnt --;
		case(state)
			IDLE: begin 
				if(act) begin
					state <= ACTIVE;
					open_row <= row_addr;
					rcd_cnt <= tRCD;
					ras_cnt <= tRAS;
				end
				end
			ACTIVE: begin
				  if(rd && rcd_cnt == 0) begin
					cl_cnt <= tCL;
				  end 
				  if(cl_cnt == 1)begin
					data_valid <= 1;
				  end
				  if(pre && ras_cnt == 0) begin
					state <= PRECHARGE;
					rp_cnt <= tRP;
				  end
				end
			PRECHARGE: begin
					if(rp_cnt == 0) state <= IDLE;
				   end
		endcase 
	end
end 
endmodule
