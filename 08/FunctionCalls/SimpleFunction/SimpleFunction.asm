//funcFK
(SimpleFunction.test)
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
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//not
@SP
A=M-1
M=!M
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
//add
@SP
A=M-1
D=M
A=A-1
M=D+M
@SP
M=M-1
//push argument
@1
D=A
@2
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//sub
@SP
A=M-1
D=M
A=A-1
M=M-D
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
