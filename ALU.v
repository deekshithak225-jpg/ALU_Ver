module ALU #(
   parameter CMD_WIDTH = 4,
   parameter WIDTH = 8
)(
   input  wire clk,rst,mode,ce,cin,
   input  wire [1:0] inp_valid,
   input  wire [CMD_WIDTH-1:0] cmd,
   input  wire [WIDTH-1:0] op_a,op_b,
   output reg signed [2*WIDTH-1:0] res,
   output reg err,oflow,cout,g,l,e 
);

    wire clk_new;
    reg start,done;
    reg [WIDTH-1:0] temp_a, temp_b;
    reg [CMD_WIDTH-1:0] prev_cmd;
    reg of;

    assign clk_new = clk & ce;

    always @(posedge clk_new or posedge rst) begin
        if (rst) begin
            res <= 0;
            err <= 0;
            oflow <= 0;
            cout <= 0;
            g <= 0;
            l <= 0;
            e <= 0;
            start <= 1;
            done <= 0;
            prev_cmd <= 14;
        end
        else begin
            err <= 0;
            oflow <= 0;
            cout <= 0;
            g <= 0;
            l <= 0;
            e <= 0;

            prev_cmd <= cmd;

            if(cmd != prev_cmd) begin
                start = 1; 
                done = 0; 
            end 

            if(mode) begin
               case(cmd)
                    0: begin
                        if(inp_valid==2'b11) begin
                            res <= op_a + op_b;
                            cout <= res[WIDTH];
                        end
                        else
                            err <= 1;
                    end

                    1: begin
                        if(inp_valid==2'b11) begin
                            res <= op_a - op_b;
                            oflow <= (op_a < op_b);
                        end
                        else
                            err <= 1;
                    end

                    2: begin
                        if(inp_valid==2'b11) begin
                            res <= op_a + op_b + cin;
                            cout <= res[WIDTH];
                        end
                        else
                            err <= 1;
                    end

                    3: begin
                        if(inp_valid==2'b11) begin
                            res <= op_a - op_b - cin;
                            oflow <= (op_a < (op_b + cin));
                        end
                        else
                            err <= 1;
                    end

                    4: begin
                        if(inp_valid[0]) begin
                            res <= op_a + 1'b1;
                        end
                        else
                            err <= 1;
                    end

                    5: begin
                        if(inp_valid[0]) begin
                            res <= op_a - 1'b1;
                        end
                        else
                            err <= 1;
                    end

                    6: begin
                        if(inp_valid[1]) begin
                            res <= op_b + 1'b1;
                        end
                        else
                            err <= 1;
                    end

                    7: begin
                        if(inp_valid[1]) begin
                            res <= op_b - 1'b1;
                        end
                        else
                            err <= 1;
                    end

                    8: begin
                        if(inp_valid==2'b11) begin
                            if (op_a > op_b)
                                g <= 1;
                            else if (op_a < op_b)
                                l <= 1;
                            else
                                e <= 1;
                        end
                        else
                            err <= 1;
                    end

                    9: begin
                        if(inp_valid==2'b11) begin
                            if(start) begin
                                temp_a <= op_a + 1'b1;
                                temp_b <= op_b + 1'b1;
                                start <= 0;
                                done <= 1;
                            end

                            if(done) begin
                                res <= temp_a * temp_b;
                                done <= 0;
                                start <= 1;
                            end
                        end
                        else
                            err <= 1;
                    end

                    10: begin
                        if (inp_valid==2'b11) begin
                            if(start) begin
                                temp_a <= op_a << 1;
                                temp_b <= op_b;
                                start <= 0;
                                done <= 1;
                            end

                            if(done) begin
                                res <= temp_a * temp_b;
                                done <= 0;
                                start <= 1;
                            end
                        end
                        else
                            err <= 1;
                    end

                    11: begin
                        if (inp_valid==2'b11) begin
                            res <= $signed(op_a) + $signed(op_b);
                            {g,l,e} <= ($signed(op_a) == $signed(op_b)) ? 3'b001 :
                                       ($signed(op_a) > $signed(op_b)) ? 3'b100 :
                                       3'b010;
                            oflow <= of;
                            {g,l,e} <= ($signed(op_a) == $signed(op_b)) ? 3'b001 :
                                       ($signed(op_a) > $signed(op_b)) ? 3'b100 :
                                       3'b010;
                        end
                        else
                            err <= 1;
                    end

                    12: begin
                        if (inp_valid==2'b11) begin
                            res <= $signed(op_a) - $signed(op_b);
                            {g,l,e} <= ($signed(op_a) == $signed(op_b)) ? 3'b001 :
                                       ($signed(op_a) > $signed(op_b)) ? 3'b100 :
                                       3'b010;
                            oflow <= of;
                            {g,l,e} <= ($signed(op_a) == $signed(op_b)) ? 3'b001 :
                                       ($signed(op_a) > $signed(op_b)) ? 3'b100 :
                                       3'b010;
                        end
                        else
                            err <= 1;
                    end
               endcase 
            end
            else begin
                case (cmd)
                    0: begin
                        if(inp_valid==2'b11)
                            res <= op_a & op_b;
                        else
                            err <= 1;
                    end

                    1: begin
                        if(inp_valid==2'b11)
                            res <= ~(op_a & op_b);
                        else
                            err <= 1;
                    end

                    2: begin
                        if(inp_valid==2'b11)
                            res <= op_a | op_b;
                        else
                            err <= 1;
                    end

                    3: begin
                        if(inp_valid==2'b11)
                            res <= ~(op_a | op_b);
                        else
                            err <= 1;
                    end

                    4: begin
                        if(inp_valid==2'b11)
                            res <= op_a ^ op_b;
                        else
                            err <= 1;
                    end

                    5: begin
                        if(inp_valid==2'b11)
                            res <= ~(op_a ^ op_b);
                        else
                            err <= 1;
                    end

                    6: begin
                        if(inp_valid[0])
                            res <= ~op_a;
                        else
                            err <= 1;
                    end

                    7: begin
                        if(inp_valid[1])
                            res <= ~op_b;
                        else
                            err <= 1;
                    end

                    8: begin
                        if(inp_valid[0])
                            res[WIDTH-1:0] <= op_a >> 1;

                        if(inp_valid[0]) begin 
                            res[WIDTH-1:0] <= op_a >> 1;
                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end

                    9: begin
                        if(inp_valid[0])
                            res[WIDTH-1:0] <= op_a << 1;

                        if(inp_valid[0]) begin
                            res[WIDTH-1:0] <= op_a << 1;
                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end

                    10: begin
                        if(inp_valid[1])
                            res[WIDTH-1:0] <= op_b >> 1;

                        if(inp_valid[1]) begin
                            res[WIDTH-1:0] <= op_b >> 1;
                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end

                    11: begin
                        if(inp_valid[1])
                            res[WIDTH-1:0] <= op_b << 1;

                        if(inp_valid[1]) begin
                            res[WIDTH-1:0] <= op_b << 1;
                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end

                    12: begin
                        if (inp_valid==2'b11) begin
                            res[WIDTH-1:0] <= op_a << op_b[$clog2(WIDTH)-1:0] |
                                               op_a >> (WIDTH - op_b[$clog2(WIDTH)-1:0]);

                            if (|op_b[WIDTH-1:$clog2(WIDTH)+1]) begin
                                err <= 1;
                            end

                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end

                    13: begin
                        if(inp_valid==2'b11) begin
                            res[WIDTH-1:0] <= op_a >> op_b[$clog2(WIDTH)-1:0] |
                                               op_a << (WIDTH - op_b[$clog2(WIDTH)-1:0]);

                            if (|op_b[WIDTH-1:$clog2(WIDTH)+1]) begin
                                err <= 1;
                            end

                            res[2*WIDTH-1:WIDTH] <= 0;
                        end
                        else
                            err <= 1;
                    end
                endcase
            end
        end
    end

    always @(*) begin
        if(mode && (cmd == 11)) begin
            of = (op_a[WIDTH-1] == op_b[WIDTH-1]) &&
                 (res[WIDTH-1] != op_a[WIDTH-1]); 
        end
        else if(mode && (cmd == 12)) begin
            of = (op_a[WIDTH-1] != op_b[WIDTH-1]) &&
                 (res[WIDTH-1] != op_a[WIDTH-1]);
        end
        else
            of = 0;
    end

endmodule
