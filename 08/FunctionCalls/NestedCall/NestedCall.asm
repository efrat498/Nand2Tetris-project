//funcFK
(Sys.init)
//push constant
@4000	//
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@3
M=D
@SP
M=M-1
//push constant
@5000
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@4
M=D
@SP
M=M-1
//push return-adress
@Sys.main.ReturnAdress0
D=A
@SP
A=M
M=D
@SP
M=M+1
//push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//push this
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//push that
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//ARG=SP-n-5
@0
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//LCL = SP
@SP
D=M
@LCL
M=D
//goto new func
@Sys.main
0;JMP
//label return-adress
(Sys.main.ReturnAdress0)
//pop temp
@SP
A=M-1
D=M
@5
A=A+1
M=D
@SP
M=M-1
//label
(Sys.LOOP)
//goto
@Sys.LOOP
0;JMP
//funcFK
(Sys.main)
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
@0
D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant
@4001
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@3
M=D
@SP
M=M-1
//push constant
@5001
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@4
M=D
@SP
M=M-1
//push constant
@200
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop local
@SP
A=M-1
D=M
@1
A=M
A=A+1
M=D
@SP
M=M-1
//push constant
@40
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop local
@SP
A=M-1
D=M
@1
A=M
A=A+1
A=A+1
M=D
@SP
M=M-1
//push constant
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop local
@SP
A=M-1
D=M
@1
A=M
A=A+1
A=A+1
A=A+1
M=D
@SP
M=M-1
//push constant
@123
D=A
@SP
A=M
M=D
@SP
M=M+1
//push return-adress
@Sys.add12.ReturnAdress1
D=A
@SP
A=M
M=D
@SP
M=M+1
//push LCL
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
//push ARG
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
//push this
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
//push that
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
//ARG=SP-n-5
@1
D=A
@5
D=D+A
@SP
D=M-D
@ARG
M=D
//LCL = SP
@SP
D=M
@LCL
M=D
//goto new func
@Sys.add12
0;JMP
//label return-adress
(Sys.add12.ReturnAdress1)
//pop temp
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
//push local
@0
D=A
@1
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push local
@1
D=A
@1
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push local
@2
D=A
@1
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push local
@3
D=A
@1
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push local
@4
D=A
@1
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//FRAME = LCL
@LCL
D=M
//RET = *(FRAME - 5)
//RAM[13]=[LCL-5]
@5
A=D-A
D=M
@13
M=D
//*ARG = pop
@SP
A=M-1
D=M
@ARG
A=M
M=D
//SP = ARG + 1
@ARG
D= M+1
@SP
M=D
//THAT =*(FRAME -1)
@LCL
A=M-1
D=M
@THAT
M=D
//THIS = *(FRAME-2)
@LCL
A=M-1
A=A-1
D=M
@THIS
M=D
//ARG = *(FRAME-3)
@LCL
A=M-1
A=A-1
A=A-1
D=M
@ARG
M=D
//LCL = *(FRAME-4)
@LCL
A=M-1
A=A-1
A=A-1
A=A-1
D=M
@LCL
M=D
//goto RET
@13
A=M
0;JMP
//funcFK
(Sys.add12)
//push constant
@4002
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@3
M=D
@SP
M=M-1
//push constant
@5002
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop pointer
@SP
A=M-1
D=M
@4
M=D
@SP
M=M-1
//push argument
@0
D=A
@2
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push constant
@12
D=A
@SP
A=M
M=D
@SP
M=M+1
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//FRAME = LCL
@LCL
D=M
//RET = *(FRAME - 5)
//RAM[13]=[LCL-5]
@5
A=D-A
D=M
@13
M=D
//*ARG = pop
@SP
A=M-1
D=M
@ARG
A=M
M=D
//SP = ARG + 1
@ARG
D= M+1
@SP
M=D
//THAT =*(FRAME -1)
@LCL
A=M-1
D=M
@THAT
M=D
//THIS = *(FRAME-2)
@LCL
A=M-1
A=A-1
D=M
@THIS
M=D
//ARG = *(FRAME-3)
@LCL
A=M-1
A=A-1
A=A-1
D=M
@ARG
M=D
//LCL = *(FRAME-4)
@LCL
A=M-1
A=A-1
A=A-1
A=A-1
D=M
@LCL
M=D
//goto RET
@13
A=M
0;JMP
