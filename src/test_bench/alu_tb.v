module tb_alu;

parameter N = 8;
parameter CMD_WIDTH = 4;

integer file_id;

reg CLK;
reg RST;
reg [1:0] INP_VALID;
reg MODE;
reg [CMD_WIDTH-1:0] CMD;
reg CE;
reg [N-1:0] OPA, OPB;
reg CIN;

wire ERR;
wire [(2*N)-1:0] RES;
wire OFLOW;
wire COUT;
wire G,L,E;

ALU #(
    .WIDTH(N),
    .CMD_WIDTH(CMD_WIDTH)
) dut (
    .clk(CLK),
    .rst(RST),
    .mode(MODE),
    .ce(CE),
    .cin(CIN),
    .inp_valid(INP_VALID),
    .cmd(CMD),
    .op_a(OPA),
    .op_b(OPB),
    .res(RES),
    .err(ERR),
    .oflow(OFLOW),
    .cout(COUT),
    .g(G),
    .l(L),
    .e(E)
);

always #5 CLK = ~CLK;

task DRIVE_INPUT;
    input t_rst;
    input t_ce;
    input [N-1:0] t_opa;
    input [N-1:0] t_opb;
    input t_mode;
    input [CMD_WIDTH-1:0] t_cmd;
    input t_cin;
    input [1:0] t_valid;

    begin
        @(negedge CLK);

        RST= t_rst;
        CE= t_ce;
        OPA= t_opa;
        OPB= t_opb;
        MODE= t_mode;
        CMD= t_cmd;
        CIN = t_cin;
        INP_VALID=t_valid;

        #1;
    end
endtask

task nop;
begin
    @(posedge CLK);
end
endtask

task SCORECARD;
begin
    #1;

    $display("--------------------------------------------------");
    $display("TIME= %0t", $time);
    $display("MODE= %0d", MODE);
    $display("CMD= %0d", CMD);
    $display("OPA= %0d", OPA);
    $display("OPB= %0d", OPB);
    $display("CIN= %0d", CIN);
    $display("INP_VALID= %b", INP_VALID);
    $display("CE= %0d", CE);
    $display("RST= %0d", RST);

    $display("RESULTS:");
    $display("RES= %0d", RES);
    $display("ERR= %0d", ERR);
    $display("COUT= %0d", COUT);
    $display("OFLOW= %0d", OFLOW);
    $display("G= %0d", G);
    $display("L= %0d", L);
    $display("E= %0d", E);

    $display("--------------------------------------------------\n");

    $fdisplay(file_id,"--------------------------------------------------");
    $fdisplay(file_id,"TIME= %0t", $time);
    $fdisplay(file_id,"MODE= %0d", MODE);
    $fdisplay(file_id,"CMD= %0d", CMD);
    $fdisplay(file_id,"OPA= %0d", OPA);
    $fdisplay(file_id,"OPB= %0d", OPB);
    $fdisplay(file_id,"CIN= %0d", CIN);
    $fdisplay(file_id,"INP_VALID= %b", INP_VALID);
    $fdisplay(file_id,"CE = %0d", CE);
    $fdisplay(file_id,"RST= %0d", RST);

    $fdisplay(file_id,"RESULTS:");
    $fdisplay(file_id,"RES= %0d", RES);
    $fdisplay(file_id,"ERR= %0d", ERR);
    $fdisplay(file_id,"COUT= %0d", COUT);
    $fdisplay(file_id,"OFLOW= %0d", OFLOW);
    $fdisplay(file_id,"G = %0d", G);
    $fdisplay(file_id,"L= %0d", L);
    $fdisplay(file_id,"E= %0d", E);

    $fdisplay(file_id,"--------------------------------------------------\n");
end
endtask

initial begin

file_id = $fopen("report.txt","w");

CLK = 0;
RST = 1;
CE = 0;
MODE = 0;
CMD = 0;
OPA = 0;
OPB = 0;
CIN = 0;
INP_VALID = 0;

#15;

$display("--- STARTING TESTS ---");

DRIVE_INPUT(1'b0,1'b1,8'd2,8'd2,1'b1,4'd0,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd0,8'd0,1'b1,4'd0,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd255,8'd255,1'b1,4'd0,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd2,1'b1,4'd0,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd2,1'b1,4'd0,1'd0,2'd10);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd2,1'b1,4'd0,1'd0,2'd01);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd3,8'd2,1'b1,4'd1,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd0,8'd0,1'b1,4'd1,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd255,8'd255,1'b1,4'd1,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd1,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd1,1'd0,2'd01);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd1,1'd0,2'd10);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd3,8'd2,1'b1,4'd3,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd0,8'd0,1'b1,4'd3,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd255,8'd255,1'b1,4'd3,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd3,1'd0,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd3,1'd0,2'd01);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd3,1'd0,2'd10);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd3,8'd2,1'b1,4'd2,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd0,8'd0,1'b1,4'd2,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd255,8'd255,1'b1,4'd2,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd2,8'd8,1'b1,4'd2,1'd1,2'd11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd253,8'd1,1'b1,4'd2,1'd1,2'd10);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd253,8'd1,1'b1,4'd2,1'd1,2'd01);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd0, 1'b1, 4'd4, 1'b0, 2'b11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0, 1'b1, 8'd0, 8'd0, 1'b1, 4'd4, 1'b0, 2'b11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0, 1'b1, 8'd255, 8'd0, 1'b1, 4'd4, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd0, 1'b1, 4'd5, 1'b0, 2'b11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0, 1'b1, 8'd0, 8'd0, 1'b1, 4'd5, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd0, 8'd15, 1'b1, 4'd6, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd0, 8'd15, 1'b1, 4'd7, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd15, 1'b1, 4'd8, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd5, 8'd4, 1'b1, 4'd9, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd20, 8'd4, 1'b1, 4'd10, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd5, 1'b1, 4'd11, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd5, 1'b1, 4'd12, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd0, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd1, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd2, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd3, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd4, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b01010101, 1'b0, 4'd5, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'd0, 1'b0, 4'd6, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd0, 8'b01010101, 1'b0, 4'd7, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd20, 8'd10, 1'b0, 4'd8, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd20, 8'd10, 1'b0, 4'd9, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'd20, 8'd10, 1'b0, 4'd10, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd5, 1'b0, 4'd11, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b10110011, 8'd1, 1'b0, 4'd12, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00000001, 8'd1, 1'b0, 4'd13, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b0, 8'b10110011, 8'd2, 1'b0, 4'd13, 1'b0, 2'b10);
SCORECARD();
DRIVE_INPUT(1'b1, 1'b1, 8'b10110011, 8'd2, 1'b0, 4'd13, 1'b0, 2'b10);
SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd25,8'd10,1'b1,4'd4,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd25,8'd10,1'b1,4'd5,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd25,8'd10,1'b1,4'd6,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd25,8'd10,1'b1,4'd7,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd25,8'd10,1'b1,4'd8,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd7,8'd3,1'b1,4'd9,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd12,8'd5,1'b1,4'd10,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd127,8'd1,1'b1,4'd11,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd128,8'd1,1'b1,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd0,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd1,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd2,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd3,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd4,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd5,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd6,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd7,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd8,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd9,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd10,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd11,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd16,1'b0,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd16,1'b0,4'd13,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd3,1'b0,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd3,1'b0,4'd13,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd50,8'sd50,1'b1,4'd11,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd50,8'sd20,1'b1,4'd11,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd20,8'sd50,1'b1,4'd11,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd50,8'sd50,1'b1,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd20,8'sd50,1'b1,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'sd50,8'sd20,1'b1,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd127,8'd1,1'b1,4'd11,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd128,8'd255,1'b1,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd10,8'd10,1'b1,4'd0,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd10,1'b1,4'd11,1'b0,2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd10,1'b1,4'd12,1'b0,2'b00);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'b10000000,8'd7,1'b0,4'd12,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b00000001,8'd7,1'b0,4'd13,1'b0,2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd15,8'd3,1'b0,4'd2,1'b0,2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd15,8'd3,1'b1,4'd2,1'b0,2'b11);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0,1'b1,8'd10,8'd10,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd20,8'd10,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd20,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd10,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd120,8'd10,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd130,8'd130,1'b1,4'd11,1'b0,2'b11);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd250,8'd10,1'b1,4'd12,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd250,1'b1,4'd12,1'b0,2'b11);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd10,8'd20,1'b1,4'd0,1'b0,2'b01);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd20,1'b1,4'd2,1'b0,2'b10);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd20,1'b1,4'd11,1'b0,2'b00);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd10,8'd20,1'b1,4'd12,1'b0,2'b00);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'b10101010,8'd12,1'b0,4'd12,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b10101010,8'd15,1'b0,4'd13,1'b0,2'b11);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd0,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd1,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd2,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd3,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd4,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd5,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd6,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd7,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd8,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd9,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd10,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'd55,8'd22,1'b0,4'd11,1'b0,2'b11);
nop(); SCORECARD();


DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd16,1'b0,4'd12,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd16,1'b0,4'd13,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd3,1'b0,4'd12,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0,1'b1,8'b11001100,8'd3,1'b0,4'd13,1'b0,2'b11);
nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'd5, 8'd4, 1'b1, 4'd9, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd3, 1'b1, 4'd10, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b10101010, 8'b11110000, 1'b0, 4'd1, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'sd120, 8'sd10, 1'b1, 4'd11, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'sd120, 8'h81, 1'b1, 4'd12, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd10, 1'b1, 4'd11, 1'b0, 2'b01);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'd10, 8'd10, 1'b1, 4'd12, 1'b0, 2'b10);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'sd64, 8'sd64, 1'b1, 4'd11, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, -8'sd64, 8'sd64, 1'b1, 4'd12, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00000101, 8'b00000100, 1'b1, 4'b1001, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00000011, 1'b1, 4'b1010, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b0, 8'b10101010, 8'b11110000, 1'b0, 4'b0001, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b01111000, 8'b00001010, 1'b1, 4'b1011, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b10001000, 8'b00001010, 1'b1, 4'b1100, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1011, 1'b0, 2'b01);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1100, 1'b0, 2'b10);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b01000000, 8'b01000000, 1'b1, 4'b1011, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b11000000, 8'b01000000, 1'b1, 4'b1100, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1101, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00000101, 1'b1, 4'b1000, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00000101, 8'b00000101, 1'b1, 4'b1000, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b0000, 1'b0, 2'b01);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b0001, 1'b0, 2'b10);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1001, 1'b0, 2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1101, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1110, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b1111, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b0000, 1'b0, 2'b00);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b0, 4'b1110, 1'b0, 2'b11);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b0, 4'b0000, 1'b0, 2'b00);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b0000, 1'b0, 2'b00);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b11110110, 1'b1, 4'b1011, 1'b0, 2'b11);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b11000001, 8'b11111000, 1'b1, 4'b1001, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00000000, 8'b00000000, 1'b1, 4'b1001, 1'b0, 2'b11);
nop(); nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00001010, 8'b00001010, 1'b1, 4'b0001, 1'b0, 2'b00);
nop(); nop(); SCORECARD();

DRIVE_INPUT(1'b0, 1'b1, 8'b00000000, 8'b00000000, 1'b1, 4'b0010, 1'b0, 2'b01);
nop(); nop(); SCORECARD();


DRIVE_INPUT(1'b0, 1'b1, 8'b00000000, 8'b00000000, 1'b1, 4'b0011, 1'b0, 2'b10);
nop(); nop(); SCORECARD();
DRIVE_INPUT(1'b0, 1'b1, 8'b00000000, 8'b00000000, 1'b1, 4'b0100, 1'b0, 2'b00);
nop(); nop(); SCORECARD();

$finish;
end

endmodule

