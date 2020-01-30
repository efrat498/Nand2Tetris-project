//initialize sp to 256
@256
D=A
@SP
M=D
//push return-adress
@Sys.init.ReturnAdress3
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
@Sys.init
0;JMP
//label return-adress
(Sys.init.ReturnAdress3)
//funcFK
(Main.fibonacci)
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
@2
D=A
@SP
A=M
M=D
@SP
M=M+1
//lt
@SP 
A=M-1
D=M
A=A-1
D=M-D
@IF_LT0
D;JLT
D=0
@SP
A=M-1
A=A-1
M=D
@END0
0;JMP
(IF_LT0)
D=-1
@SP
A=M-1
A=A-1
M=D
(END0)
@SP
M=M-1
//if-goto
@SP
M=M-1
A=M
D=M
@Main.IF_TRUE
D;JNE
//goto
@Main.IF_FALSE
0;JMP
//label
(Main.IF_TRUE)
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
//label
(Main.IF_FALSE)
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
@2
D=A
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
//push return-adress
@Main.fibonacci.ReturnAdress0
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
@Main.fibonacci
0;JMP
//label return-adress
(Main.fibonacci.ReturnAdress0)
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
@1
D=A
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
//push return-adress
@Main.fibonacci.ReturnAdress1
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
@Main.fibonacci
0;JMP
//label return-adress
(Main.fibonacci.ReturnAdress1)
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
(Sys.init)
//push constant
@4
D=A
@SP
A=M
M=D
@SP
M=M+1
//push return-adress
@Main.fibonacci.ReturnAdress2
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
@Main.fibonacci
0;JMP
//label return-adress
(Main.fibonacci.ReturnAdress2)
//label
(Sys.WHILE)
//goto
@Sys.WHILE
0;JMP
