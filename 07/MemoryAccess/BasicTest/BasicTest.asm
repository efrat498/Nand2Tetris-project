//push constant
@10
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
M=D
@SP
M=M-1
//push constant
@21
D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant
@22
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop argument
@SP
A=M-1
D=M
@2
A=M
A=A+1
A=A+1
M=D
@SP
M=M-1
//pop argument
@SP
A=M-1
D=M
@2
A=M
A=A+1
M=D
@SP
M=M-1
//push constant
@36
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop this
@SP
A=M-1
D=M
@3
A=M
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
M=D
@SP
M=M-1
//push constant
@42
D=A
@SP
A=M
M=D
@SP
M=M+1
//push constant
@45
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop that
@SP
A=M-1
D=M
@4
A=M
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
M=D
@SP
M=M-1
//pop that
@SP
A=M-1
D=M
@4
A=M
A=A+1
A=A+1
M=D
@SP
M=M-1
//push constant
@510
D=A
@SP
A=M
M=D
@SP
M=M+1
//pop temp
@SP
A=M-1
D=M
@5
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
A=A+1
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
//push that
@5
D=A
@4
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
@ 1
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
//push this
@6
D=A
@3
A=M+D
D=M
@SP
A=M
M=D
@SP
M=M+1
//push this
@6
D=A
@3
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
//sub
@SP
A=M-1
D=M
A=A-1
M=M-D
@SP
M=M-1
//push temp
@6
D=A
@5
A=A+D
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
