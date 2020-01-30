module tar2 #Chgit Refaeli Efrat  Shabtay 206732752
import java.lang.Integer
import java.util.LinkedList
import java.io.FileWriter
import java.io.FileReader
import java.io.BufferedReader

import java.io.File

function label = |fileName, x|{
 let labelCommand = "//label" + "\n" +
                    "(" + fileName + "." + x + ")" + "\n"
 return labelCommand
}
function goto = |fileName, x|{
let gotoCommand = "//goto" + "\n" +
                  "@" + fileName + "." + x + "\n" +
                  "0;JMP" + "\n"
return gotoCommand
}
function ifGoto = |fileName, x|{
 let ifGotoCommand = "//if-goto" + "\n" + #if topmost stack element not zero jump
                     "@SP" + "\n" +
                     "M=M-1" + "\n" + #update sp after pop
                     "A=M" + "\n" +
                     "D=M" + "\n" + #topmost stack element\
                     "@" + fileName + "." + x + "\n" +
                     "D;JNE" + "\n"  #if D == 0 jump to ROM[A]
 return ifGotoCommand
}
function funcFK = |f,k|{
 var funcFKCommand = "//funcFK" + "\n" +
                     "(" + f + ")" + "\n"
 var numLocals = k
 while(numLocals > 0){
 funcFKCommand = funcFKCommand +"@0" + "\n" +	#register A = 7
                                "D=A" + "\n" +	#save the value of A in register D, D = 7
                                "@SP"	+ "\n" +	#SP is Stack Pointer: points to the top of the stack (next free location of the stack). SP = 0 and points to RAM[0]. #suppose the stack top points to RAM[256] so SP = RAM[0]=256 #current command is: A=0
                                "A=M" + "\n" +	#M is shortcut name to RAM[A]. #since A=0 from the previous command #then current command is: A = RAM[A] = RAM[0] = 256. => A=256
                                "M=D" 	+ "\n" + #RAM[A]= D. RAM[256]=7. #meaning: push 7 to the top of the stack, which is now RAM[256].
                                "@SP" + "\n" +	#after pushing 7 to the stack, we want to increment the stack pointer. #current command is: A=0
                                "M=M+1" + "\n" #RAM[A]=RAM[A]+1 => RAM[0] = RAM[0] + 1 => RAM[0] = 256+1 = 257. #so now the stack pointer, saved in RAM[0], points to RAM[257]
  numLocals = numLocals - 1
  }
  return funcFKCommand
}

function call = |nameFunc ,arguments ,countL|{
  var callCommand = "//push return-adress" + "\n" +
                    "@" + nameFunc + ".ReturnAdress" + countL + "\n" + #The return label
                    "D=A" + "\n" +
                    "@SP" + "\n" +
                    "A=M" + "\n" +
                    "M=D" + "\n" + #push the return adress into the stack
                    "@SP" + "\n" +
                    "M=M+1" + "\n" +
                    "//push LCL" + "\n" +
                    "@LCL" + "\n" +
                    "D=M" + "\n" + #D = RAM[LCL] , D is the the adrees points to the local segment
                    "@SP" + "\n" +
                    "A=M" + "\n" +
                    "M=D" + "\n" +
                    "@SP" + "\n" +
                    "M=M+1" + "\n" +
                    "//push ARG" + "\n" +
                    "@ARG" + "\n" +
                    "D=M" + "\n" + #D = RAM[ARG] , D is the the adrees points to the argument segment
                    "@SP" + "\n" +
                    "A=M" + "\n" +
                    "M=D" + "\n" +
                    "@SP" + "\n" +
                    "M=M+1" + "\n" +
                    "//push this" + "\n" +
                    "@THIS" + "\n" +
                    "D=M" + "\n" + #D = RAM[THIS] , D is the the adrees points to THIS segment
                    "@SP" + "\n" +
                    "A=M" + "\n" +
                    "M=D" + "\n" +
                    "@SP" + "\n" +
                    "M=M+1" + "\n" +
                    "//push that" + "\n" +
                    "@THAT" + "\n" +
                    "D=M" + "\n" + #D = RAM[THAT] , D is the the adrees points to THAT argument segment
                    "@SP" + "\n" +
                    "A=M" + "\n" +
                    "M=D" + "\n" +
                    "@SP" + "\n" +
                    "M=M+1" + "\n" +
                    "//ARG=SP-n-5" + "\n" +
                    "@" + arguments + "\n" +
                    "D=A" + "\n" +
                    "@5" + "\n" +
                    "D=D+A" + "\n" +
                    "@SP" + "\n" +
                    "D=M-D" + "\n" +
                    "@ARG" + "\n" +
                    "M=D" + "\n" +
                    "//LCL = SP" + "\n" + #The local of the new function
                    "@SP" + "\n" +
                    "D=M" + "\n" +
                    "@LCL" + "\n" +
                    "M=D" + "\n" + #The address of the local segment now is sp
                    "//goto new func" + "\n" +
                    "@" + nameFunc + "\n" +
                    "0;JMP" + "\n" +
                    "//label return-adress" + "\n" +
                    "(" + nameFunc + ".ReturnAdress" + countL + ")" + "\n"
  return callCommand
  }
function returnAddress = {
  let returnAdrCommand = "//FRAME = LCL" + "\n" +
                         "@LCL" + "\n" +
                         "D=M" + "\n" + #saving the address of the current  function local segment
                         "//RET = *(FRAME - 5)" + "\n" + #saving the return value in RET
                         "//RAM[13]=[LCL-5]" + "\n" + #
                         "@5" + "\n" +
                         "A=D-A" + "\n" + # A = address of the current  function local segment - 5 = pionts to the return address value
                         "D=M" + "\n" + # D = the return address value
                         "@13" + "\n" +
                         "M=D" + "\n" + # saving the return address value in thr general purpose register
                         "//*ARG = pop" + "\n" +
                         "@SP" + "\n" +
                         "A=M-1" + "\n" +
                         "D=M" + "\n" + #D = the return value
                         "@ARG" + "\n" +
                         "A=M" + "\n" +
                         "M=D" + "\n" + # Push the return value up to the arguments (the sp at the end)
                         "//SP = ARG + 1" + "\n" +
                         "@ARG" + "\n" +
                         "D= M+1" + "\n" + # D = The address of the return value place in the stack
                         "@SP" + "\n" +
                         "M=D" + "\n" + # increment the sp to the address of the return value place in the stack
                         "//THAT =*(FRAME -1)" + "\n" +
                         "@LCL" + "\n" +
                         "A=M-1" + "\n" + # A = RAM[LCL] - 1 = The address of saved THAT
                         "D=M" + "\n" + # D = The address of the THAT segment of the calling function
                         "@THAT" + "\n" +
                         "M=D" + "\n" + # update the THAT segment address in the stack
                         "//THIS = *(FRAME-2)" + "\n" +
                         "@LCL" + "\n" +
                         "A=M-1" + "\n" + # A = RAM[LCL] - 1 = The address of saved THAT
                         "A=A-1" + "\n" + # A = The address of saved THIS
                         "D=M" + "\n" + # D = The address of the THIS segment of the calling function
                         "@THIS" + "\n" +
                         "M=D" + "\n" + # update the THIS segment address in the stack
                         "//ARG = *(FRAME-3)" + "\n" +
                         "@LCL" + "\n" +
                         "A=M-1" + "\n" + # A = RAM[LCL] - 1 = The address of saved THAT
                         "A=A-1" + "\n" + # A = The address of saved THIS
                         "A=A-1" + "\n" + # A = The address of saved ARG
                         "D=M" + "\n" + # D = The address of the ARG segment of the calling function
                         "@ARG" + "\n" +
                         "M=D" + "\n" + # update the ARG segment address in the stack
                         "//LCL = *(FRAME-4)" + "\n" +
                         "@LCL" + "\n" +
                         "A=M-1" + "\n" + # A = RAM[LCL] - 1 = The address of saved THAT
                         "A=A-1" + "\n" + # A = The address of saved THIS
                         "A=A-1" + "\n" + # A = The address of saved ARG
                         "A=A-1" + "\n" + # A = The address of saved LCL
                         "D=M" + "\n" + # D = The address of the ARG segment of the calling function
                         "@LCL" + "\n" +
                         "M=D" + "\n" + # update the LCL segment address in the stack
                         "//goto RET" + "\n" +
                         "@13"  + "\n" + # the return address value in thr general purpose register
                         "A=M" + "\n" +
                         "0;JMP" + "\n"  #jump to the address ROM[13] , jump to the return address
  return returnAdrCommand
}

function main = |args| {
    let dir = args: get(0) #the input path
    let file = File(dir)   #create file of the input path
    let delimiter = "\\\\"
    let namePathArr = dir:split(delimiter)
    let folderName = namePathArr: get((namePathArr: length()) - 1)
    var countVmFiles = 0
    let listOfFiles = file: list() #array of string with names of files/directory
    var new = ""
    var fullCommand = ""
    var countReturn = 0
    for(var i = 0, i < listOfFiles: size(), i = i+1){
           let nameF = listOfFiles: get(i)
           let fileLen = nameF: length() #length of filename
           if(nameF: substring(fileLen - 3, fileLen) == ".vm" ){ #chaeck if the file ends with vm
               countVmFiles = countVmFiles + 1
               new = nameF: substring(0,fileLen - 3) #the vm filename without .vm
               let file1 = File(dir + "/" + nameF) #get into the file
               let buff = BufferedReader(FileReader(file1))
               var line = buff: readLine()
               var count = 0
               while line isnt null{
                    if(line: startsWith("label")){
                        let tempArray = line:split(" ")
                        let labelName = tempArray: get(1)
                        fullCommand = fullCommand + label(new,labelName)
                    }
                    if(line: startsWith("goto")){
                        let tempArray = line:split(" ")
                        let labelName = tempArray: get(1)
                        fullCommand = fullCommand + goto(new,labelName)
                    }
                    if(line: startsWith("if-goto")){
                        let tempArray = line:split(" ")
                        let labelName = tempArray: get(1)
                        fullCommand = fullCommand + ifGoto(new,labelName)
                    }
                   if(line: startsWith("function")){
                        let tempArray = line:split(" ")
                        let functionName = tempArray: get(1)
                        let kLocals = Integer(tempArray: get(2))
                        let str = funcFK(functionName,kLocals)
                        fullCommand = fullCommand + str
                   }
                   if(line: startsWith("call")){
                        let tempArray = line:split(" ")
                        let functionName = tempArray: get(1)
                        let nArguments = Integer(tempArray: get(2))
                        fullCommand = fullCommand + call(functionName,nArguments,countReturn)
                        countReturn = countReturn + 1
                   }
                   if(line: startsWith("return")){
                        fullCommand = fullCommand + returnAddress()
                   }
                   if(line: startsWith("add")){
                        let commandAdd =  "//add" + "\n" +
                                          "@SP" + "\n" +	# A = 0
                                          "A=M-1"	+ "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                          "D=M" + "\n" +	#D = RAM[A] = RAM[257] = 8 D saves the second item in the stack
                                          "A=A-1"	+ "\n" + #A = 257-1 = 256
                                          "M=D+M" + "\n" + #RAM[A] = D+RAM[A] => RAM[256] = 8+RAM[256] = 8+7 = 15 ,save the add result in the place of the first item on the stack this is equal to:  pop second item, pop first item, push the result of their addition to the stack.
                                          "@SP" + "\n" + #after pushing the result to the stack, we want to decrement the stack pointer. current command is: A=0
                                          "M=M-1" + "\n" #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]"
                       fullCommand = fullCommand + commandAdd
                   }
                   if(line: startsWith("sub")){
                        let commandSub =  "//sub" + "\n" +
                                          "@SP" + "\n" +	 #A = 0
                                          "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                          "D=M"  + "\n" +  #D = RAM[A] = RAM[257] = 5 D saves the second item in the stack
                                          "A=A-1" + "\n" + #A = 257-1 = 256   RAM[256] = 2
                                          "M=M-D" + "\n" + #RAM[A] = RAM[A]-D => RAM[256] = RAM[256]-5 = 2-5 = -3 save the sub result in the place of the first item on the stack this is equal to:  pop second item, pop first item, push the result of their subrtaction to the stack.
                                          "@SP"	+ "\n" + #after pushing the result to the stack, we want to decrement the stack pointer current command is: A=0
                                          "M=M-1" + "\n"	#RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257 so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandSub
                   }
                   if(line: startsWith("neg")){
                        let commandNeg = "//neg" + "\n" +
                                         "@SP" + "\n" + #A = 0
                                         "A=M-1" + "\n" +	#A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                         "D=M" + "\n" +	  #D = RAM[A] = RAM[257] = 5 D saves the second item in the stack
                                         "@0"	+ "\n" + #A=0
                                         "D=A-D" + "\n" +	#D = 0-5= -5
                                         "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                         "M=D" + "\n" 	  #RAM[A]=D => RAM[257]= -5  this is equal to:  pop the item, give it the negative value and push it back.
                        fullCommand = fullCommand + commandNeg
                   }
                   if(line: startsWith("eq")){
                        let commandEq = "//eq" + "\n" +
                                        "@SP"  + "\n" +  #A = 0
                                        "A=M-1"  + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "D=M"  + "\n" +  #D = RAM[A] = RAM[257] = 8
                                        "A=A-1"  + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=256
                                        "D=D-M"   + "\n" +  #D = D-RAM[A] = 8-RAM[256] = 0 (?)
                                        "@IF_TRUE" + count + "\n" + #A = IF_TRUE0 , The true jump dest
                                        "D;JEQ" + "\n" + #if D == 0 jump to ROM[A]
                                        "D=0" + "\n" +  #else , puts FALSE value
                                        "@SP" + "\n" +  #A = 0
                                        "A=M-1" + "\n" +  #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" +
                                        "M=D" + "\n" +
                                        "@IF_FALSE" + "\n" + #A = IF_FALSE0 , The false jump dest
                                        "0;JMP"	 + "\n" + #jump to IF_FALSE0 label
                                        "(IF_TRUE" + count + ")" + "\n" + #label
                                        "D=-1"  + "\n" + #for the TRUE value
                                        "@SP"  + "\n" + #A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" + #A = 257-1 = 256
                                        "M=D"  + "\n" + #RAM[256] = -1 puts TRUE value
                                        "(IF_FALSE" + count + ")" + "\n" +
                                        "@SP" + "\n" +
                                        "M=M-1" + "\n" #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandEq
                        count = count + 1
                   }
                   if(line: startsWith("gt")){
                        let commandGt = "//gt" + "\n" +
                                        "@SP" + "\n" +  #A = 0
                                        "A=M-1" + "\n" +   #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "D=M" + "\n" +   #D = RAM[A] = RAM[257] = 8
                                        "A=A-1"  + "\n" +  #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=256
                                        "D=M-D"  + "\n" +  #D = RAM[A]-D = 9-8
                                        "@IF_GRT" + count + "\n" +  #A = IF_GRT , The true jump dest
                                        "D;JGT" + "\n" +   #if D > 0 jump to ROM[A]
                                        "D=0" + "\n" +   #else , puts FALSE value
                                        "@SP" + "\n" +   # A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" +
                                        "M=D" + "\n" +
                                        "@END" + "\n" + #A = END ,  jump to END
                                        "0;JMP" + "\n" +	  #jump to END label
                                        "(IF_GRT" + count + ")" + "\n" + #label
                                        "D=-1" + "\n" +  #for the TRUE value
                                        "@SP" + "\n" +  #A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" + #A = 257-1 = 256
                                        "M=D" + "\n" + #RAM[256] = -1 puts TRUE value
                                        "(END" + count + ")" + "\n" +
                                        "@SP" + "\n" +
                                        "M=M-1" + "\n"  #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandGt
                        count = count + 1
                   }
                   if(line: startsWith("lt")){
                        let commandLt = "//lt" + "\n" +
                                        "@SP" + " \n" +  #A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "D=M" + "\n" +   #D = RAM[A] = RAM[257] = 8
                                        "A=A-1" + "\n" +  #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=256
                                        "D=M-D" + "\n" +  #D = RAM[A]-D = 9-8
                                        "@IF_LT" + count + "\n" +  #A = IF_GRT , The true jump dest
                                        "D;JLT" + "\n" +  #if D < 0 jump to ROM[A]
                                        "D=0" + "\n" +  #else , puts FALSE value
                                        "@SP" + "\n" +  #A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" +
                                        "M=D" + "\n" +
                                        "@END" + count + "\n" + #A = END ,  jump to END
                                        "0;JMP" + "\n" + #jump to END label
                                        "(IF_LT" + count + ")" + "\n" + #label
                                        "D=-1" + "\n" + #for the TRUE value
                                        "@SP" + "\n" +  #A = 0
                                        "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "A=A-1" + "\n" + #A = 257-1 = 256
                                        "M=D" + "\n" +  #RAM[256] = -1 puts TRUE value
                                        "(END" + count + ")" +  "\n" +
                                        "@SP" + "\n" +
                                        "M=M-1" + "\n"  #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandLt
                        count = count + 1
                   }
                   if(line: startsWith("and")){
                        let commandAnd = "//and" + "\n" +
                                         "@SP"  + "\n" +  #A = 0
                                         "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                         "D=M" + "\n" +  #D = RAM[A] = RAM[257] = 8
                                         "A=A-1" + "\n" +  #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=256
                                         "M=M&D" + "\n" +  #D = RAM[A]&D = 9&8
                                         "@SP" + "\n" +
                                         "M=M-1" + "\n"  #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]
                       fullCommand = fullCommand + commandAnd
                   }
                   if(line: startsWith("or")){
                        let commandOr = "//or" + "\n" +
                                        "@SP" + "\n" + #A = 0
                                        "A=M-1" + "\n" +  #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                        "D=M"  + "\n" +   #D = RAM[A] = RAM[257] = 8
                                        "A=A-1" + "\n" +   #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=256
                                        "M=M|D" + "\n" +  #D = RAM[A]|D = 8 | 0
                                        "@SP" + "\n" +
                                        "M=M-1" + "\n"  #RAM[A]=RAM[A]-1 => RAM[0] = RAM[0] - 1 => RAM[0] = 258-1 = 257. so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandOr
                   }
                   if(line: startsWith("not")){
                        let commandNot =  "//not" + "\n" +
                                          "@SP" + "\n" + #A = 0
                                          "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                          "M=!M" + "\n"   #RAM[A]= !RAM[A]= !0
                        fullCommand = fullCommand + commandNot
                   }
                   if(line: startsWith("push constant")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushCon = "//push constant" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" +	#save the value of A in register D, D = 7
                                              "@SP"	+ "\n" +	#SP is Stack Pointer: points to the top of the stack (next free location of the stack). SP = 0 and points to RAM[0]. #suppose the stack top points to RAM[256] so SP = RAM[0]=256 #current command is: A=0
                                              "A=M" + "\n" +	#M is shortcut name to RAM[A]. #since A=0 from the previous command #then current command is: A = RAM[A] = RAM[0] = 256. => A=256
                                              "M=D" 	+ "\n" + #RAM[A]= D. RAM[256]=7. #meaning: push 7 to the top of the stack, which is now RAM[256].
                                              "@SP" + "\n" +	#after pushing 7 to the stack, we want to increment the stack pointer. #current command is: A=0
                                              "M=M+1" + "\n" #RAM[A]=RAM[A]+1 => RAM[0] = RAM[0] + 1 => RAM[0] = 256+1 = 257. #so now the stack pointer, saved in RAM[0], points to RAM[257]
                        fullCommand = fullCommand + commandPushCon
                   }
                   if(line: startsWith("push that")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushThat = "//push that" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" + #save the value of A in register D, D = 7
                                              "@4" + "\n" + #THAT points to the base of the current that segment
                                              "A=M+D" + "\n" +
                                              "D=M" + "\n" + # D=RAM[THAT] + num ]
                                              "@SP" + "\n" +
                                              "A=M" + "\n" +
                                              "M=D" + "\n" +
                                              "@SP" + "\n" +
                                              "M=M+1" + "\n"
                        fullCommand = fullCommand + commandPushThat
                   }
                   if(line: startsWith("push this")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushThis = "//push this" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" + #save the value of A in register D, D = 7
                                              "@3" + "\n" + #THIS points to the base of the current this segment
                                              "A=M+D" + "\n" +
                                              "D=M" + "\n" + # D=RAM[THIS] + num ]
                                              "@SP" + "\n" +
                                              "A=M" + "\n" +
                                              "M=D" + "\n" +
                                              "@SP" + "\n" +
                                              "M=M+1" + "\n"
                        fullCommand = fullCommand + commandPushThis
                   }
                   if(line: startsWith("push local")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushLcl =  "//push local" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" +
                                              "@1" + "\n" +
                                              "A=M+D" + "\n" +
                                              "D=M" + "\n" + # D=RAM[LCL] + num ]
                                              "@SP" + "\n" +
                                              "A=M" + "\n" +
                                              "M=D" + "\n" +
                                              "@SP" + "\n" +
                                              "M=M+1" + "\n"
                        fullCommand = fullCommand + commandPushLcl
                   }
                   if(line: startsWith("push argument")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushArg =  "//push argument" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" + #save the value of A in register D, D = 7
                                              "@2" + "\n" + #ARG points to the base of the current argument segment
                                              "A=M+D" + "\n" +
                                              "D=M" + "\n" + #RAM[ARG] + num ]
                                              "@SP" + "\n" +
                                              "A=M" + "\n" +
                                              "M=D" + "\n" +
                                              "@SP" + "\n" +
                                              "M=M+1" + "\n"
                       fullCommand = fullCommand + commandPushArg
                   }
                   if(line: startsWith("push temp")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushTemp = "//push temp" + "\n" +
                                              "@" + num + "\n" +	#register A = 7
                                              "D=A" + "\n" + #save the value of A in register D, D = 7
                                              "@5" + "\n" + #5 is constant value, since temp variables are saved on RAM[5-12]
                                              "A=A+D" + "\n" + # A= 5+num
                                              "D=M" + "\n" + # D = RAM [5+num]
                                              "@SP" + "\n" +
                                              "A=M" + "\n" +
                                              "M=D" + "\n" + #push into the top of the stack the value that is in address RAM[ 5 + num ]
                                              "@SP" + "\n" +
                                              "M=M+1" + "\n"
                        fullCommand = fullCommand + commandPushTemp
                   }
                   if(line: startsWith("push static")){
                        let tempArray = line:split(" ")
                        let num = tempArray: get(2)
                        let commandPushStatic = "//push static" + "\n" +
                                                "@" + new + "." + num + "\n" +	#register A = 7
                                                "D=M" + "\n" + # D = RAM[@className.num]
                                                "@SP" + "\n" +
                                                "A=M" + "\n" +
                                                "M=D" + "\n" + #push into the top of the stack the value that is in address RAM[@className.num]
                                                "@SP" + "\n" +
                                                "M=M+1" + "\n"
                        fullCommand = fullCommand + commandPushStatic
                   }
                   if(line: startsWith("push pointer")){
                        let tempArray = line:split(" ")
                        let num = Integer(tempArray: get(2))
                        if( num == 0){ #Pointer 0 is THIS.
                            let commandPushP = "//push pointer this" + "\n" +
                                               "@THIS" + "\n" + #THIS points to the base of the current this segment
                                               "D=M" + "\n" + # D=RAM[THIS]
                                               "@SP" + "\n" +
                                               "A=M" + "\n" +
                                               "M=D" + "\n" + #push into the top of the stack the value that is in address RAM[THIS]
                                               "@SP" + "\n" +
                                               "M=M+1" + "\n"
                            fullCommand = fullCommand + commandPushP
                        }
                        if( num == 1) { #Pointer 1 is THAT.
                            let commandPushP = "//push pointer that" + "\n" +
                                               "@THAT" + "\n" + #THAT points to the base of the current that segment
                                               "D=M" + "\n" + # D=RAM[THAT]
                                               "@SP" + "\n" +
                                               "A=M" + "\n" +
                                               "M=D" + "\n" + #push into the top of the stack the value that is in address RAM[THAT]
                                               "@SP" + "\n" +
                                               "M=M+1" + "\n"
                           fullCommand = fullCommand + commandPushP
                        }
                   }
                   if(line: startsWith("pop that")){
                        let tempArray = line:split(" ")
                        var numInt = Integer(tempArray: get(2))
                        var commandPopThat = "//pop that" + "\n" +
                                             "@SP" + "\n" +	# A = 0
                                             "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                             "D=M" + "\n" + # D = RAM[256] the top of the stack
                                             "@4" + "\n" +
                                             "A=M" + "\n"
                        while(numInt > 0)
                        {
                          commandPopThat = commandPopThat + "A=A+1" + "\n" # address  RAM[THAT] + num
                          numInt = numInt - 1
                        }
                        commandPopThat = commandPopThat + "M=D" + "\n" + # pop the top of the stack (D) into address RAM[ RAM[THAT] + num]
                                                          "@SP" + "\n" +
                                                          "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopThat
                   }
                   if(line: startsWith("pop this")){
                        let tempArray = line:split(" ")
                        var numInt = Integer(tempArray: get(2))
                        var commandPopThis = "//pop this" + "\n" +
                                             "@SP" + "\n" +	# A = 0
                                             "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                             "D=M" + "\n" + # D = RAM[256] the top of the stack
                                             "@3" + "\n" +
                                             "A=M" + "\n"
                        while(numInt > 0)
                        {
                          commandPopThis = commandPopThis + "A=A+1" + "\n" # address  RAM[THIS] + num
                          numInt = numInt - 1
                        }

                        commandPopThis =  commandPopThis + "M=D" + "\n" + # pop the top of the stack (D) into address RAM[ RAM[THIS] + num]
                                                           "@SP" + "\n" +
                                                           "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopThis
                   }
                   if(line: startsWith("pop local")){
                        let tempArray = line:split(" ")
                        var numInt = Integer((tempArray: get(2)):trim())
                        var commandPopLcl = "//pop local" + "\n" +
                                            "@SP" + "\n" +	# A = 0
                                            "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                            "D=M" + "\n" + # D = RAM[256] the top of the stack
                                            "@1" + "\n" +
                                            "A=M" + "\n"
                        while(numInt > 0)
                        {
                           commandPopLcl = commandPopLcl + "A=A+1" + "\n" # address  RAM[LCL] + num
                           numInt = numInt - 1
                        }
                        commandPopLcl =  commandPopLcl + "M=D" + "\n" + # pop the top of the stack (D) into address RAM[ RAM[LCL] + num]
                                                         "@SP" + "\n" +
                                                         "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopLcl
                   }
                   if(line: startsWith("pop argument")){
                        let tempArray = line:split(" ")
                        var numInt = Integer((tempArray: get(2)):trim())
                        var commandPopArg = "//pop argument" + "\n" +
                                            "@SP" + "\n" + # A = 0
                                            "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                            "D=M" + "\n" + #D = RAM[256] the top of the stack
                                            "@2" + "\n" +
                                            "A=M" + "\n"
                       while(numInt > 0)
                        {
                           commandPopArg = commandPopArg + "A=A+1" + "\n"  # address  RAM[ARG] + num
                           numInt = numInt - 1
                        }
                        commandPopArg = commandPopArg + "M=D" + "\n" + # pop the top of the stack (D) into address RAM[ RAM[ARG] + num ]
                                                        "@SP" + "\n" +
                                                        "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopArg
                   }
                   if(line: startsWith("pop temp")){
                        let tempArray = line:split(" ")
                        var numInt = Integer(tempArray: get(2))
                        var commandPopTmp = "//pop temp" + "\n" +
                                            "@SP" + "\n" +	# A = 0
                                            "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                            "D=M" + "\n" + # D = RAM[256] the top of the stack
                                            "@5" + "\n"
                        while(numInt > 0)
                        {
                           commandPopTmp = commandPopTmp + "A=A+1" + "\n" # address  RAM[THIS] + num
                           numInt = numInt - 1
                        }
                        commandPopTmp = commandPopTmp + "M=D" + "\n" + # pop the top of the stack (D) into address RAM[5 + num]
                                                        "@SP" + "\n" +
                                                        "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopTmp
                   }
                   if(line: startsWith("pop static")){
                        let tempArray = line:split(" ")
                        var num = tempArray: get(2)
                        let commandPopStatic = "//pop static" + "\n" +
                                               "@SP" + "\n" +	# A = 0
                                               "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                               "D=M" + "\n" + # D = RAM[256] the top of the stack
                                               "@" + new + "." + num + "\n" +
                                               "M=D" + "\n" + # pop the top of the stack into address RAM[className.num ]
                                               "@SP" + "\n" +
                                               "M=M-1" + "\n"
                        fullCommand = fullCommand + commandPopStatic
                   }
                   if(line: startsWith("pop pointer")){
                        let tempArray = line:split(" ")
                        var num = Integer(tempArray: get(2))
                        if( num == 0){ #Pointer 0 is THIS.
                            var commandPopP =  "//pop pointer" + "\n" +
                                               "@SP" + "\n" +	# A = 0
                                               "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                               "D=M" + "\n" + # D = RAM[256] the top of the stack
                                               "@3" + "\n" +
                                               "M=D" + "\n" + # pop the top of the stack (D) into address RAM[THIS]
                                               "@SP" + "\n" +
                                               "M=M-1" + "\n"
                            fullCommand = fullCommand + commandPopP
                        }
                        if( num == 1) { #Pointer 1 is THAT.
                            var commandPopP = "//pop pointer" + "\n" +
                                              "@SP" + "\n" +	# A = 0
                                              "A=M-1" + "\n" + #A = RAM[A]-1 = RAM[0]-1 = 258-1 = 257 => A=257
                                              "D=M" + "\n" + # D = RAM[256] the top of the stack
                                              "@4" + "\n" +
                                              "M=D" + "\n" + # pop the top of the stack (D) into address RAM[THIS].
                                              "@SP" + "\n" +
                                              "M=M-1" + "\n"
                            fullCommand = fullCommand + commandPopP
                        }
                   }
                   line =  buff: readLine()
               }
#               textToFile(fullCommand ,dir + "/" + new + ".asm" ) #create asm file
           }

    }
     if(countVmFiles > 1){
        var Command = "//initialize sp to 256" + "\n" +
                      "@256" + "\n" +
                      "D=A" + "\n" +
                      "@SP" + "\n" +
                      "M=D" + "\n"
        Command = Command + call("Sys.init","0",countReturn)  + fullCommand
        textToFile(Command ,dir + "//" + folderName + ".asm" ) #create asm file
     } else {
     textToFile(fullCommand ,dir + "//" + folderName + ".asm" ) #create asm file
     }
 }
