module rx_teach #(
    parameter   Sys_clk_frq = 50_000_000,
    parameter   baud_frq    = 115200      ,
    parameter   div_cnt_max = Sys_clk_frq/baud_frq,
    parameter   cnt_width   = $clog2(div_cnt_max)
)(
    input   wire            Sys_clk,
    input   wire            Rst_n  ,
    input   wire            data_in,
    output  reg   [7:0]     data_receive,
    output  reg             rx_done
);
            reg   [cnt_width-1:0]  div_cnt;
            reg                    reg_data_A;
            reg                    reg_data_B;
            reg                    uart_state;
            reg                    receive_flag ;
            reg   [3:0]            bit_cnt   ;
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            {reg_data_A,reg_data_B} <= 2'b00;
        end else begin
            {reg_data_A,reg_data_B} <= {data_in,reg_data_A};
        end
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            rx_done <= 1'b0;
        end else if(bit_cnt == 4'd8 && receive_flag) begin
            rx_done <= 1'b1;
        end else begin
            rx_done <=  1'b0;
        end
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            uart_state <= 1'b0;
        end else if((!reg_data_A)&&(reg_data_B)) begin
            uart_state <= 1'b1;
        end else if(rx_done) begin
            uart_state <= 1'b0;
        end
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            div_cnt <= 'd0;
        end else if(uart_state == 1'b1) begin
            if(div_cnt == div_cnt_max -1'b1) begin
                div_cnt <= 'd0;
            end else begin
                div_cnt <= div_cnt + 1'b1;
            end
        end else begin
            div_cnt <= 'd0;
        end
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            receive_flag <= 1'b0;
        end else if(div_cnt == (div_cnt_max - 1'b1)>>1) begin
            receive_flag <= 1'b1;
        end else begin
            receive_flag <= 1'b0;
        end
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            bit_cnt <= 'd0;
        end else if(bit_cnt == 4'd8 && receive_flag) begin
            bit_cnt <= 'd0;
        end else if(receive_flag) begin
            bit_cnt <= bit_cnt + 1'b1;
        end else
            bit_cnt <= bit_cnt;
    end
    always @(posedge Sys_clk or negedge Rst_n) begin
        if(!Rst_n) begin
            data_receive <= 8'd0;
        end else if(bit_cnt >= 1'b1 &&  receive_flag) begin
            data_receive <= {reg_data_B,data_receive[7:1]};
            // case (bit_cnt)
            //     4'd0:data_receive   <= data_receive;
            //     4'd1:data_receive[0] <= reg_data_B;
            //     4'd2:data_receive[1] <= reg_data_B;
            //     4'd3:data_receive[2] <= reg_data_B;
            //     4'd4:data_receive[3] <= reg_data_B;
            //     4'd5:data_receive[4] <= reg_data_B;
            //     4'd6:data_receive[5] <= reg_data_B;
            //     4'd7:data_receive[6] <= reg_data_B;
            //     4'd8:data_receive[7] <= reg_data_B;
            //     default:data_receive <= data_receive;
            // endcase
        end
    end
endmodule