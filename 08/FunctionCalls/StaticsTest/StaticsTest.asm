//initialize sp to 256
@256
D=A
@SP
M=D
//push return-adress
@Sys.init.ReturnAdress4
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
(Sys.init.ReturnAdress4)
//funcFK
(Class1.set)
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
//pop static
@SP
A=M-1
D=M
@Class1.0
M=D
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
//pop static
@SP
A=M-1
D=M
@Class1.1
M=D
@SP
M=M-1
//push constant
@0
D=A
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
//funcFK
(Class1.get)
//push static
@Class1.0
D=M
@SP
A=M
M=D
@SP
M=M+1
//push static
@Class1.1
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
//funcFK
(Class2.set)
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
//pop static
@SP
A=M-1
D=M
@Class2.0
M=D
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
//pop static
@SP
A=M-1
D=M
@Class2.1
M=D
@SP
M=M-1
//push constant
@0
D=A
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
//funcFK
(Class2.get)
//push static
@Class2.0
D=M
@SP
A=M
M=D
@SP
M=M+1
//push static
@Class2.1
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
//funcFK
(Sys.init)
//push constant
@6
D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant
@8
D=A
@SP
A=M
M=D
@SP
M=M+1
//push return-adress
@Class1.set.ReturnAdress0
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
@2
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
@Class1.set
0;JMP
//label return-adress
(Class1.set.ReturnAdress0)
//pop temp
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
//push constant
@23
D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant
@15
D=A
@SP
A=M
M=D
@SP
M=M+1
//push return-adress
@Class2.set.ReturnAdress1
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
@2
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
@Class2.set
0;JMP
//label return-adress
(Class2.set.ReturnAdress1)
//pop temp
@SP
A=M-1
D=M
@5
M=D
@SP
M=M-1
//push return-adress
@Class1.get.ReturnAdress2
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
@Class1.get
0;JMP
//label return-adress
(Class1.get.ReturnAdress2)
//push return-adress
@Class2.get.ReturnAdress3
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
@Class2.get
0;JMP
//label return-adress
(Class2.get.ReturnAdress3)
//label
(Sys.WHILE)
//goto
@Sys.WHILE
0;JMP
