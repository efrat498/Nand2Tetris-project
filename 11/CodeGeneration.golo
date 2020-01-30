module tar5 
import java.lang.Integer
import java.util.LinkedList
import java.io.FileWriter
import java.io.FileReader
import java.io.BufferedReader
import java.io.File
import java.util.LinkedHashMap
import java.util.Arrays

#Reading the xml files from project 10 and creating jack files.

var classTable = map[]
var subroutineTable = map[]
var counter = map[["STATIC",0],["FIELD",0],["ARG",0],["VAR",0]]
var kind = map[["STATIC","STATIC"],["FIELD","THIS"],["ARG","ARG"],["VAR","LOCAL"]]
var opList = list("+", "-", "*", "/", "&", "|", "<", ">", "=")
var arithmetic = map[['+', "ADD"], ['-', "SUB"], ['=', "EQ"], ['>', "GT"], ['<', "LT"], ['&', "AND"], ['|', "OR"]]
var keyword = list("class","constructor","function","method","field","static","var","int","char","boolean","void","true","false","null","this","let","do","if","else","while","return")
var symbol = list('{','}','(',')','[',']','.',',',';','+','-','*','/','&','|','<','>','=','~')
var ifIndex = 0
var whileIndex = 0
function symbols = |theSymbol|{
    var result = ""
    if(theSymbol == '<'){
        result = "<symbol> &lt; </symbol>"+ "\n"
    }else if(theSymbol == '>'){
        result = "<symbol> &gt; </symbol>"+ "\n"
    }else if(theSymbol == '"'){
        result = "<symbol> &quot; </symbol>"+ "\n"
    }else if(theSymbol == '&'){
       result = "<symbol> &amp; </symbol>"+ "\n"
    }else {
        result = "<symbol> "+ theSymbol +" </symbol>" +"\n"
    }
    return result
}


function func = |theWord,keyword|{
    var result = ""
    if(keyword:contains(theWord)){
        result = result + "<keyword> "+theWord+" </keyword>" + "\n"
    } else if(theWord:charAt(0):isDigit()){ #if the word starts with digit
            result = result + "<integerConstant> "+theWord+" </integerConstant>" + "\n"
    } else { #it must be indentifier
        result = result + "<identifier> "+theWord+" </identifier>" + "\n"
    }
    return result
}

function startClass = {
    classTable:clear()
    counter:put("STATIC",0)
    counter:put("FIELD",0)
}
function startSubroutine = {
    subroutineTable:clear()
    counter:put("VAR",0)
    counter:put("ARG",0)
}
function define = |name,type,kind|{
    println("in define " + name + " " + type + " " + kind)
    var triple = ""
    if(kind == "ARG" or kind == "VAR"){
        var index = counter:get(kind)
        counter:put(kind,index+1)
        if(kind == "ARG"){
            triple = array[type,"argument",index]
        } else {
            triple = array[type,"local",index]
        }
        subroutineTable:put(name,triple)
    } else if(kind == "STATIC" or kind == "FIELD"){
        var index = counter:get(kind)
        counter:put(kind,index+1)
        if(kind == "FIELD"){
            triple = array[type,"this",index]
        } else {
            triple = array[type,kind,index]
        }
        classTable:put(name,triple)
    }
}

function varCount = |kind| {
    return counter:get(kind)
}

function kindOf = |name| {
    var itsKind = "NONE"
    var nameArray = subroutineTable:get(name)
    if(nameArray isnt null){
       itsKind =  nameArray:get(1)
    } else {
        nameArray = classTable:get(name)
        if(nameArray isnt null){
            itsKind =  nameArray:get(1)
        }
    }
    return itsKind
}

function typeOf = |name|{
    var type = ""
    var nameArray = subroutineTable:get(name)
    if(nameArray isnt null){
        type = nameArray:get(0)
    } else {
        nameArray = classTable:get(name)
        type = nameArray:get(0)
    }
    return type
}

function indexOf = |name|{
    var index = ""
    var nameArray = subroutineTable:get(name)
    if(nameArray isnt null){
        index = nameArray:get(2)
    } else {
        nameArray = classTable:get(name)
        index = nameArray:get(2)
    }
    return index
}

function writeVmPush = |type, num| {
    return "push " + type + " " + num + "\n"
}
function writeVmPop = |type, num| {
    return "pop " + type + " " + num + "\n"
}

function writeVmCall = |name, num| {
    return "call " + name + " " + num + "\n"
}

function writeVmFunction = |funcName, numOfLocals| {
    return "function " + funcName + " " + numOfLocals + "\n"
}

function writeVmConstructor = {
    var commands = ""
    var numOfFields = counter:get("FIELD")
    commands = writeVmPush("constant",numOfFields)
    commands = commands + writeVmCall("Memory.alloc", 1)
    commands = commands + writeVmPop("pointer", 0)
    return commands
}

function writeVmMethod = {
    var commands = ""
    commands = commands + writeVmPush("argument", 0)
    return commands
}

function writeVmIF = |label| {
    return "if-goto " + label + "\n"
}

function writeVmGoto = |label| {
    return "goto " + label + "\n"
}

function writeVmLabel = |label| {
    return "label " + label + "\n"
}
function parseClass = |buff, currentLine|{
    var result = ""
#    result = result + currentLine + "\n" #<keyword> class </keyword>
    startClass()
    var line = buff: readLine() #read the next line
#    result = result + line + "\n" #<identifier> Square </identifier>
    var myArr = line:split(" ")
    var word = myArr: get(1) #Square
    var className = word
    line = buff: readLine() #read the next line
    result = result + parseClassVarDec(buff)
    println("result after parseClassVarDec is " + result)
    buff:reset()
    result = result + parseSubDec(className,buff)
    println("result after parseSubDec is " + result)
    buff:reset()
    line = buff: readLine() #read the next line
#    result = result + line + "\n" #<symbol> } </symbol>
#    result = result + "</class>" + "\n"
    return result
}
function parseClassVarDec = |buff|{
    var kind = ""
    var type = ""
    var name =""
    var result = ""
    buff:mark(30)
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1) #field / static
    while (word == "field" or word == "static"){
#        result = result + "<classVarDec>" + "\n"
#        result = result + line + "\n" #<keyword> field or static </keyword>
        kind = word
        line = buff: readLine()
#        result = result + line + "\n" #<keyword> int </keyword>
        myArr = line:split(" ")
        word = myArr: get(1) #int
        type = word
        line = buff: readLine()
#        result = result + line + "\n" #<identifier> x </identifier>
        myArr = line:split(" ")
        word = myArr: get(1) #x
        name = word
        define(name,type,kind)
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        while(word == ","){
#            result = result + line + "\n" # <symbol> , </symbol>
            line = buff: readLine()
#            result = result + line + "\n" # #<identifier> y </identifier>
            myArr = line:split(" ")
            word = myArr: get(1) #y
            name = word
            define(name,type,kind)
            buff:mark(30)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1)
        }
        buff:reset()
        line = buff: readLine()
#        result = result + line + "\n" # <symbol> ; </symbol>
#        result = result + "</classVarDec>" + "\n"
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #field / static
    }
    return result
}

function parseSubDec = |className, buff| {
    var subType = ""
    var returnType = ""
    var name = ""
    buff:mark(30)
    var line = buff: readLine()
    var result = ""
    var myArr = line:split(" ")
    var word = myArr: get(1) #function / method / constructor
    println("word is " + word)
    while(word == "function" or word == "method" or word == "constructor"){
        startSubroutine()
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        returnType = word #void/type
        line = buff: readLine()
        #result = result + line + "\n" #<identifier> dispose </identifier>
        myArr = line:split(" ")
        word = myArr: get(1)
        name = word #dispose
        name = className + "." + name
        parseParameterList(buff)
        buff:readLine() #skip {
        parseSubroutineVarsDec(buff)
        #write function in vm
        let numOfLocals = counter:get("VAR")
        result = result + writeVmFunction(name,numOfLocals)
        println(result)
        #handle function by type
        if (subType == "method") {
            result = result + writeVmMethod()
        } else if(subType == "constructor") {
            result = result + writeVmConstructor()
        }
        result = result + parseSubroutineBody(buff, className)
        buff:mark(40)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #function / method / constructor
    }
    return result
}

function parseParameterList = |buff| {
   var line = buff:readLine() # read start of arguments list '('
   var splitLine = line:split(" ")
   var type = ""
   var name = ""
   line = buff:readLine() # read next line to see if we got argument or ')'
   splitLine = line:split(" ")
   while(splitLine: get(1) != ")" )  {# while we haven't reached to end of arguments
        println("in parseParameterList token is " + splitLine: get(1))
        line = buff: readLine()
        splitLine = line:split(" ")
        type = splitLine: get(1)
        line = buff: readLine()
        splitLine = line:split(" ")
        name = splitLine: get(1)
        define(name,type,"ARG")
   }
   return
}

function parseSubroutineVarsDec = |buff| {
   var line = buff:readLine() # read next line to check if contains var
   var splitLine = line:split(" ")
    println(splitLine: get(1))
   while(splitLine: get(1) == "var" )  {# while we haven't reached to end of vars dec
        parseVarDec(buff)
        buff: mark(30)
        line = buff:readLine()
        splitLine = line:split(" ")
   }
   buff:reset()
   return
}

function parseVarDec = |buff| {
    var line = buff:readLine()
    var splitLine = line:split(" ")
    var type = ""
    var name = ""
    #read first var
    type = splitLine: get(1)
    line = buff:readLine()
    splitLine = line:split(" ")
    name = splitLine: get(1)
    define(name,type,"VAR")
    line = buff:readLine()
    splitLine = line:split(" ")
    #parse multiple vars separated by ,
    while(splitLine:get(1) != ";") {
        line = buff:readLine() #skip the ,
        line = buff:readLine()
        splitLine = line:split(" ")
        type = splitLine: get(1)
        line = buff:readLine()
        splitLine = line:split(" ")
        name = splitLine: get(1)
        define(name,type,"VAR")
        line = buff:readLine()
        splitLine = line:split(" ")
    }
    return
}
function parseSubroutineBody = |buff, className| {
    var statementType = ""
    var line = ""
    var splitLine = ""
    var commands = ""
    var varKind = ""
    var word = ""
    var index = ""
    line = buff:readLine()
    splitLine = line:split(" ")
    statementType = splitLine:get(1)
    println("in parseSubroutineBody")
    while (statementType != '}') {
        if (statementType == "let") {
            println("in let case")
            line = buff:readLine()
            splitLine = line:split(" ")
            word = splitLine:get(1)
            println("word is "+word)
            varKind =  kindOf(word)
            index = indexOf(word)
            line = buff:readLine()
            splitLine = line:split(" ")
            word = splitLine:get(1)
            println("word2 is "+word)
            if (word == "[") { #var is array: let arr[5] = expression
                commands = commands + parseExpression(buff)
                commands = commands + writeVmPush(varKind, index)
                commands = commands + "ADD" + "\n"
                line = buff:readLine() #skip ']'
                line = buff:readLine() #skip '='
                commands = commands + parseExpression(buff)
                commands = commands + writeVmPop("temp", 0) #save the assignment value in temp 0
                commands = commands + writeVmPop("pointer", 1) #save the var address (position in arr) in pointer 0
                commands = commands + writeVmPush("temp", 0)
                commands = commands + writeVmPop("that", 0)
            } else { # var is regular var: let a = expression
                commands = commands + parseExpression(buff)
                commands = commands + writeVmPop(varKind, index) #save the assignment value in the var
            }
            buff:readLine() # ';'
        } else if (statementType == "if") {
            index = ifIndex
            ifIndex = ifIndex + 1
            line = buff:readLine() #skip '('
            commands = commands + parseExpression(buff)
            line = buff:readLine() #skip ')'
            line = buff:readLine() #skip '{'
            commands = commands + writeVmIf("IF_TRUE" + index)
            commands = commands + writeVmGoto("IF_FALSE" + index)
            commands = commands + writeVmLabel("IF_TRUE" + index)
            commands = commands + parseSubroutineBody(buff, className)
            commands = commands + writeVmGoto("IF_END" + index)
        } else if (statementType == "while") {
            index = whileIndex
            whileIndex = whileIndex + 1
            commands = commands + writeVmLabel("WHILE" + index)
            buff:readLine() # '('
            commands = commands + parseExpression(buff)
            commands = commands + "NOT" + "\n" # eval false condition first
            buff:readLine() # ')'
            buff:readLine() # '{'
            commands = commands + writeVmIf("WHILE_END" + index)
            commands = commands + parseSubroutineBody(buff, className) # statements
            commands = commands + writeVmGoto("WHILE" + index)
            commands = commands + writeLabel("WHILE_END" + index)
            buff:readLine() # '}'
        } else if (statementType == "do") {
            commands = commands + parseSubroutineCall(buff, className)
            commands = commands + writeVmPop("temp", 0)
            buff:readLine() # ';'
        } else if (statementType == "return") {
            buff:mark(30)
            line = buff:readLine()
            splitLine = line:split(" ")
            if(splitLine:get(1) == ';') {
                commands = commands + writeVmPush("const", 0)
            } else {
                buff:reset()
                commands = commands + parseExpression(buff)
            }
            commands = commands + "return\n"
            buff:readLine()# ';'
        }
    }
    return commands
}

function parseSubroutineCall = |buff, className| {
    var functionName = ""
    var numberArgs = 0
    var line = ""
    var splitLine = ""
    var subroutineName = ""
    var type = ""
    var commands = ""
    line = buff:readLine()
    splitLine = line:split(" ")
    functionName = splitLine:get(1)
    buff:mark(30)
    line = buff:readLine()
    splitLine = line:split(" ")
    if (splitLine:get(1) == "."){
        line = buff:readLine()
        splitLine = line:split(" ")
        subroutineName = splitLine:get(1)
        type = typeOf(functionName)
        if (type != "NONE") { # it's an instance
            let instanceKind = kindOf(functionName)
            let instanceIndex = indexOf(functionName)
            commands = commands + writeVmPush(kind:get(instanceKind), instanceIndex)
            functionName = type + "."  + subroutineName
            numberArgs = numberArgs + 1
        } else{ # it's a class
             let classNameLocal = functionName
             functionName = classNameLocal + "." + subroutineName
        }
    }else{
      subroutineName = functionName
      functionName = className + "." + subroutineName
      numberArgs = numberArgs + 1
      commands =  commands + writeVmPush("POINTER", 0)
    }
    let returnValues = parseExpressionList(buff)
    commands = commands + returnValues[0]
    numberArgs = numberArgs + returnValues[1]
    buff:readLine()             # ')'
    commands = commands + writeVmCall(functionName, numberArgs)

    return commands
}

function parseExpressionList = |buff| {
    var numberArgs = 0
    var commands = ""
    var line = ""
    var splitLine = ""
    line = buff:readLine()
    splitLine = line:split(" ")
    if (")" != splitLine:get(1)){
        numberArgs = numberArgs + 1
        commands = commands + parseExpression(buff)
    }
    line = buff:readLine()
    splitLine = line:split(" ")
    while (')' != splitLine:get(1)) {
        numberArgs = numberArgs + 1
        buff:readLine() # skip ,
        line = buff:readLine()
        splitLine = line:split(" ")
    }
    var myarray = array[commands,numberArgs]
    return myarray
}

function parseExpression = |buff| {
    var commands = ""
    var line = ""
    var splitLine = ""
    commands = parseTerm(buff) # term
    println(commands)
    buff:mark(30)
    line = buff:readLine()
    splitLine = line:split(" ")
    println("parse expression " + splitLine:get(1))
    while (opList:contains(splitLine:get(1))) {# (op term)*
        var op = splitLine:get(1)
        buff:reset()
        commands = commands + parseTerm(buff) # term
        if (arithmetic:containsKey(op)) {
            commands = commands + arithmetic:get(op) + "\n"
        } else if  (op == "*") {
            commands = commands + writeVmCall("Math.multiply", 2)
        }  else if (op == "/") {
            commands = commands + writeVmCall("Math.divide", 2)
        }
        buff:mark(30)
        line = buff:readLine()
        splitLine = line:split(" ")
    }
    buff:reset()
    return commands
}

function parseTerm = |buff| {
    var line = ""
    var splitLine = ""
    var op = ""
    var commands = ""
    buff:mark(30)
    line = buff:readLine()
    splitLine = line:split(" ")
    op = splitLine:get(1)
    if(op == "&" or op =="|"){
        commands = commands + parseTerm(buff)
        if(op == "&"){
            commands = commands + "AND\n"
        } else {
            commands = commands + "OR\n"
        }
    }  else if(op == "("){
        commands = commands + parseExpression(buff)
        buff:readLine() # skip ')'
    } else if(op oftype Integer.class) {
        commands = commands + writeVmPush("const", op)
    } else if (op oftype String.class){
        commands = commands + parseString(op)
    } else if (keyword:contains(op)){
        if (op == "this"){
            commands = commands + writeVmPush("POINTER", 0)
        }else{
            commands = commands + writeVmPush("CONST", 0)
            if (keyword == "true") {
                commands = commands + "NOT\n"
            }
        }
    } else{ # first is a var or subroutine
        line = buff:readLine()
        splitLine = line:split(" ")
        if(splitLine:get(1) == "[") {# it's array
            commands = commands + parseExpression(buff)  # expression
            buff:readLine()         # ']'
            let kind = kindOf(op)
            let arrayIndex = indexOf(op)
            commands = commands + writeVmPush(kind, arrayIndex)
            commands = commands + "ADD\n"
            commands = commands + writeVmPop("POINTER", 1)
            commands = commands + writeVmPush("THAT", 0)
        } else if (op == "." or op == "("){
            println("got here")
            buff:reset()
            commands = commands + parseSubroutineCall(buff)
        } else {
            let kind  = kindOf(op)
            let index = indexOf(op)
            commands = commands + writeVmPush(kind, index)
        }
    }
}

function parseString = |str| {
    var commands = ""

    commands = commands + writeVmPush("CONST", str:length())
    commands = commands + writeVmCall("String.new", 1)

    for (var i = 0, i<str:length(), i = i+1){
      commands = commands + writeVmPush("CONST", str:charAt(i))
      commands = commands + writeVmCall("String.appendChar", 2)
    }
}

function main = |args| {
        let dir = args: get(0) #the input path
        let file = File(dir)   #create file of the input path
        let listOfFiles = file: list() #array of string with names of files/directory
        for(var i = 0, i < listOfFiles: size(), i = i+1){
               let nameF = listOfFiles: get(i)
               let fileLen = nameF: length() #length of filename
               if(nameF: substring(fileLen - 5, fileLen) == ".jack" ){ #chaeck if the file ends with .jack
                    let new = nameF: substring(0,fileLen - 5) #the jack filename without .jack
                    let thisFile = File(dir + "/" + nameF) #get into the file
                    let buff = BufferedReader(FileReader(thisFile))
                    var line = buff: readLine()
                    var xmlTxt = "<tokens>" + "\n"
                    while line isnt null{
                        if(line:startsWith("//") or line:startsWith("/*") or line:startsWith("*/") or line:startsWith("*") ){#comment
                            line = buff: readLine()
                        } else {
                        let lineLength = line:length()
                        var word = "" #the word we recognize
                        var j = 0
                        while(j < lineLength ){ #read every char
                            var currentChar = line:charAt(j)
                            if(symbol:contains(currentChar)){
                                if(word != ""){
                                     xmlTxt = xmlTxt + func(word,keyword)
                                }
                                xmlTxt = xmlTxt + symbols(currentChar)
                                word =""
                            } else if(currentChar == ' ' or currentChar == '\t'){
                                if(word != ""){
                                    xmlTxt = xmlTxt + func(word,keyword)
                                    }
                                word =""
                            } else if(currentChar == '\"'){#if it is string keep reading until it ends
                                j = j+1
                                currentChar = line:charAt(j)
                                while(currentChar != '\"'){
                                    word = word + currentChar
                                    j = j+1
                                    currentChar = line:charAt(j)
                                }
                                xmlTxt = xmlTxt + "<stringConstant> "+ word +" </stringConstant>" + "\n"
                                word = ""
                            } else{
                                word = word + currentChar
                            }
                            j = j+1
                        }
                        line =  buff: readLine()
                     }
               }
               xmlTxt = xmlTxt + "</tokens>"
               textToFile(xmlTxt ,dir + "/" + new + "T.xml" ) #create T.xml file
            }
        }
        let newListOfFiles = file: list()
        for(var i = 0, i < listOfFiles: size(), i = i+1){
            let nameFile = listOfFiles: get(i)
            let fileLength = nameFile: length() #length of filename
            if(nameFile: substring(fileLength - 5, fileLength) == "T.xml" ){ #chaeck if the file ends with .jack
                let name = nameFile: substring(0,fileLength - 5) #the T.xml filename without T.xml
                let thisFile = File(dir + "/" + nameFile) #get into the file
                let buff = BufferedReader(FileReader(thisFile))
                var currentLine = buff: readLine()
                var newVm = ""
                currentLine = buff: readLine() #we dont need to read the <tokens> line
                 while currentLine != "</tokens>"{
                    let tempArray = currentLine:split(" ")
                    let myWord = tempArray: get(1)
                    if( myWord == "class"){
                        println("found class")
                        newVm = newVm + parseClass(buff,currentLine)
                    }
                    currentLine = buff: readLine()
                 }
                 textToFile(newVm ,dir + "/" + name + ".vm" ) #create vm file
            }
        }

}
