module lsu #(parameter bits = 32) (
	);

logic i, j;
logic [31:0] addr[0:4];
logic [31:0] d_r2[0:4];
logic w_notr [0:4];

typedef enum logic [2:0] {
    init = 3'b000,
    firstreq = 3'b001,
    lsreq = 3'b010,
    req_send = 3'b011,
    waitstate = 3'b100,
    firstvalid =  3'b101,
    validstate = 3'b110
} state;


state cur_state, next;

always_ff @(posedge clk or posedge rst) begin
    if (rst)
        cur_state <= init;
    else
        cur_state <= next;
end


always_ff @(posedge clk or posedge rst) begin
    case (cur_state) 
        init: begin
              i <= 1'b0;
              j <= 1'b0;
              if (lsinstr == 1)
              	next <= firstreq;
        end
        firstreq: begin
                addr[i] <= ADDR_IN;
                d_r2[i] <= ls_mux;
                w_notr <= ls_mux_sel;
                i++;
                if (lsinstr == 1)
                    next <= lsreq;
        end
        lsreq: begin
             proc_req <= 1'b1;
             ADDR_OUT <= addr[j];
             we <= w_notr[j];
             data_reg <= d_r2[j];
             j++;
             if (mem_rdy == 1 & j != i)
             	next <= waitstate;
             else if (j == 1)
             	next <= lsreq;
         end
        req_send: begin
        	proc_req <= 1'b1;
        	ADDR_OUT <= addr[j];
        	we <= w_notr[j];
        	j++;
        	addr[i] <= ADDR_IN;
        	d_r2[i] <= ls_mux;
        	w_notr[i] <= ls_mux_sel;
        	i++;
        	if (j > i)
        		next <= lsreq;
        end
		firstvalid: begin
			write_out <= Rdata;
			wen <= w_notr[j-1];
			store_ok <= ~(w_notr[j-1]);
			j = 0;
			proc_req = 0;
			if (valid == 1 & i != j)
				next <= validstate;
		end        
		validstate: begin
			write_out <= Rdata;
			wen <= w_notr[j];
			store_ok <= ~w_notr[j];
			if (i == j)
				next <= init;
		end
		
    endcase 
end   
endmodule
