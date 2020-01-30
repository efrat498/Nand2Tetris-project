module tar3 
import java.lang.Integer
import java.util.LinkedList
import java.io.FileWriter
import java.io.FileReader
import java.io.BufferedReader
import java.io.File
#Syntax Analysis
#Reading a jack file and creating fileT.xml (tokenizing). Reading the fileT.xml file and creating hierarchical file.xml (parsing)

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

function parseClass = |buff, currentLine|{
    var result = "<class>" + "\n"
    result = result + currentLine + "\n" #<keyword> class </keyword>
    var line = buff: readLine() #read the next line
    result = result + line + "\n" #<identifier> Square </identifier>
    line = buff: readLine() #read the next line
    result = result + line + "\n" #<symbol> { </symbol>]
    result = result + parseClassVarDec(buff)
    buff:reset()
    result = result + parseSubDec(buff)
    buff:reset()
    line = buff: readLine() #read the next line
    result = result + line + "\n" #<symbol> } </symbol>
    result = result + "</class>" + "\n"
    return result
}

function parseClassVarDec = |buff|{
    var result =""
    buff:mark(30)
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1) #field / static
    while (word == "field" or word == "static"){
        result = result + "<classVarDec>" + "\n"
        result = result + line + "\n" #<keyword> field or static </keyword>
        line = buff: readLine()
        result = result + line + "\n" #<keyword> int </keyword>
        line = buff: readLine()
        result = result + line + "\n" #<identifier> x </identifier>
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        while(word == ","){
            result = result + line + "\n" # <symbol> , </symbol>
            line = buff: readLine()
            result = result + line + "\n" # #<identifier> y </identifier>
            buff:mark(30)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1)
        }
        buff:reset()
        line = buff: readLine()
        result = result + line + "\n" # <symbol> ; </symbol>
        result = result + "</classVarDec>" + "\n"
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #field / static
    }
    return result
}

function parseSubDec = |buff| {
    buff:mark(30)
    var line = buff: readLine()
    var result = ""
    var myArr = line:split(" ")
    var word = myArr: get(1) #function / method / constructor
    while(word == "function" or word == "method" or word == "constructor"){
        result = result + "<subroutineDec>" + "\n"
        result = result + line + "\n" #<keyword> function / method / constructor </keyword>
        line = buff: readLine()
        result = result + line + "\n" #<keyword> void/type </keyword>
        line = buff: readLine()
        result = result + line + "\n" #<identifier> dispose </identifier>
        line = buff: readLine()
        result = result + line + "\n" #<symbol> ( </symbol>
        result = result + parseParameterList(buff)
        buff:reset()
        line = buff: readLine()
        println("parseSubDec: after parseParameterList line is:" + line)
        result = result + line + "\n" #<symbol> ) </symbol>
        result = result + parseSubroutineBody(buff)
        result = result + "</subroutineDec>" + "\n"
        buff:mark(40)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #function / method / constructor
    }
    return result
}

function parseParameterList=|buff|{
    var result = "<parameterList>" + "\n"
    buff:mark(30)
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1)
    if( word != ")"){
        println("inIf")
        result = result + line + "\n" #type
        line = buff: readLine()
        result = result + line + "\n" #varName
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        while( word == ","){
            result = result + line + "\n" # ,
            line = buff: readLine()
            result = result + line + "\n" #type
            line = buff: readLine()
            result = result + line + "\n" #varName
            buff:mark(30)
            line = buff: readLine()
            println("parseParameterList: in while: next line is: " + line)
            myArr = line:split(" ")
            word = myArr: get(1)
        }
    }
    result = result + "</parameterList>" + "\n"
    return result
 }


function parseSubroutineBody = |buff|{
    var result= "<subroutineBody>" + "\n"
    var line=buff: readLine()
    result = result + line + "\n" # <symbol> { </symbol>
    result = result + parseVarDec(buff)
    buff:reset()
    result = result + parseStatments(buff)
    buff:reset()
    line = buff: readLine()
    result = result + line + "\n" # <symbol> } </symbol>
    result = result + "</subroutineBody>" + "\n"
    return result
 }

function parseVarDec = |buff|{
    buff:mark(30)
    var line = buff: readLine()
    var result = ""
    var myArr = line:split(" ")
    var word = myArr: get(1) #var
    while( word == "var"){
        result = result + "<varDec>" + "\n"
        result = result + line + "\n" #var
        line = buff: readLine()
        result = result + line + "\n" #type
        line = buff: readLine()
        result = result + line + "\n" #varName
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        while(word == ","){
            result = result + line + "\n" # <symbol> , </symbol>
            line = buff: readLine()
            result = result + line + "\n" # varName
            buff:mark(30)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1)
           }
        buff:reset()
        line = buff: readLine()
        result = result + line + "\n" # <symbol> ; </symbol>
        result = result + "</varDec>" + "\n"
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #var
    }
    return result
 }

function parseStatments = |buff|{
    buff:mark(100)
    var result = ""
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1) #let/while...
    if(word == "let" or word == "if" or word == "while" or word == "do" or word == "return"){
        result = result + "<statements>" + "\n"
    }
    while(word == "let" or word == "if" or word == "while" or word == "do" or word == "return"){
        if(word == "let"){
            result = result + "<letStatement>" + "\n"
            result = result + line + "\n" #let
            line = buff: readLine()
            result = result + line + "\n" #varName
            buff:mark(30)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1) # maybe [
            if(word == "["){
                result = result + line + "\n" #[
                result = result + parseExp(buff)
                buff:reset()
                line = buff: readLine()
                result = result + line + "\n" #]
            } else {
                buff:reset()
            }
            line = buff: readLine()
            result = result + line + "\n" # =
            result = result + parseExp(buff)
            buff:reset()
            line = buff: readLine()
            result = result + line + "\n" # ;
            result = result + "</letStatement>" + "\n"
        } else if(word == "if"){
            result = result + "<ifStatement>" + "\n"
            result = result + line + "\n" #if
            line = buff: readLine()
            result = result + line + "\n" # (
            result = result + parseExp(buff)
            buff:reset()
            line = buff: readLine()
            println("statements in if after calling parseExp: " + line)
            result = result + line + "\n" # )
            line = buff: readLine()
            result = result + line + "\n" # {
            result = result + parseStatments(buff)
            buff:reset()
            line = buff: readLine()
            result = result + line + "\n" # }
            buff:mark(40)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1) # maybe else
            if(word == "else"){
                result = result + line + "\n" #else
                line = buff: readLine()
                result = result + line + "\n" # {
                result = result + parseStatments(buff)
                buff:reset()
                line = buff: readLine()
                result = result + line + "\n" # }
            } else {
                buff: reset()
            }
            result = result + "</ifStatement>" + "\n"
        } else if( word == "while"){
            result = result + "<whileStatement>" + "\n"
            result = result + line + "\n" #while
            line = buff: readLine()
            result = result + line + "\n" # (
            result = result + parseExp(buff)
            buff:reset()
            line = buff: readLine()
            println("in while statement line is: " + line + " should be ')'")
            result = result + line + "\n" # )
            line = buff: readLine()
            result = result + line + "\n" # {
            result = result + parseStatments(buff)
            buff:reset()
            line = buff: readLine()
            result = result + line + "\n" # }
            result = result + "</whileStatement>" + "\n"
        } else if(word == "do"){
            result = result + "<doStatement>" + "\n"
            result = result + line + "\n" #do
            result = result + parseSubroutineCall(buff)
            line = buff: readLine()
            println("in do statement after calling subroutine line is: " + line)
            result = result + line + "\n" # ;
            result = result + "</doStatement>" + "\n"
        } else if(word == "return"){
            result = result + "<returnStatement>" + "\n"
            result = result + line + "\n" #return
            buff:mark(30)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1) # expression / ;
            if(word != ";"){
                buff:reset()
                result = result + parseExp(buff)
                buff:reset()
                line = buff: readLine()  #read the ;
            }
            result = result + line + "\n" #;
            result = result + "</returnStatement>" + "\n"
        }
        buff:mark(100)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1) #let/while...
        println("in statements: in while: word is: " + word)
    }
    result = result + "</statements>" + "\n"
    return result
}

function parseExp = |buff|{
    let op = list("+","-","*","/","&amp;","|","&lt;","&gt;","&quot;", "=")
    var result = "<expression>" + "\n"
    result = result + parseTerm(buff)
    buff:mark(40)
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1)
    println("parseExp: after calling parseTrem for the first time line is: " + line)
    while(op:contains(word)){
        result = result + line + "\n" #op
        result = result + parseTerm(buff)#term
        buff:mark(40)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
    }
    result = result + "</expression>" + "\n"
    return result
}

function parseTerm = |buff|{
    let keywordConstant = list("true","false","null","this")
    var result = "<term>" + "\n"
    var line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(0)
    println("term:" + word)
    if(word == "<stringConstant>" or word == "<integerConstant>" or keywordConstant:contains(myArr: get(1)) ){
        result = result + line + "\n"
    } else if( myArr: get(1) == "~" or myArr: get(1) == "-"){ #unaryOp
        result = result + line + "\n"
        result = result + parseTerm(buff)
    } else if( myArr: get(1) == "("){
        result = result + line + "\n" #(
        result = result + parseExp(buff)
        buff:reset()
        line = buff: readLine()
        result = result + line + "\n" # )
    } else if( myArr: get(0) == "<identifier>" ){
        result = result + line + "\n"
        buff:mark(30)
        line = buff: readLine()
        myArr = line:split(" ")
        word = myArr: get(1)
        if(word == "["){
            result = result + line + "\n" #[
            result = result + parseExp(buff)
            buff:reset()
            line = buff: readLine()
            result = result + line + "\n" #]
        } else if( word == "(" or word == "."){
            buff:reset()
            result = result + parseSubCall(buff)
        } else {
            buff:reset()
        }

    }
    result = result + "</term>" + "\n"
    return result
}

function parseSubroutineCall = |buff| {
    var result = ""
    var line = buff: readLine()
    result = result + line + "\n" # SubroutineNmae / className / varName
    line = buff: readLine()
    var myArr = line:split(" ")
    var word = myArr: get(1)
    if( word == "("){
        result = result + line + "\n" # (
        result = result + parseExpList(buff)
        buff:reset()
        line = buff: readLine()
        result = result + line + "\n" # )
    } else if (word == "."){
         result = result + line + "\n" # .
         line = buff: readLine()
         result = result + line + "\n" # subroutineName
         line = buff: readLine()
         result = result + line + "\n" # (
         result = result + parseExpList(buff)
         buff:reset()
         line = buff: readLine()
         result = result + line + "\n" # )
    }
    return result
}

function parseSubCall = |buff| { #without the SubroutineNmae / className / varName. for term call
    var result = ""
    var line = buff: readLine()
    println("subCall" + line)
    var myArr = line:split(" ")
    var word = myArr: get(1)
    if( word == "("){
        result = result + line + "\n" # (
        result = result + parseExpList(buff)
        buff:reset()
    } else if (word == "."){
         result = result + line + "\n" # .
         line = buff: readLine()
         result = result + line + "\n" # subroutineName
         line = buff: readLine()
         println("sub call:" + line)
         result = result + line + "\n" # (
         result = result + parseExpList(buff)
         buff:reset()
         line = buff: readLine()
         println("sub call:" + line)
         result = result + line + "\n" # )
    }
    return result
}
function parseExpList = |buff|{
     var result = ""
     buff:mark(100)
     var line = buff: readLine()
     println("parseExpList: "+line)
     var myArr = line:split(" ")
     result = result + "<expressionList>" + "\n"
     var word = myArr: get(1)
     if( word != ")"){
        println("parseExpList: "+word)
        buff:reset()
        result = result + parseExp(buff)
        buff:reset()
        buff:mark(100)
        line = buff: readLine()
        println("parseExpList: "+line)
        myArr = line:split(" ")
        word = myArr: get(1)
        while(word == ","){
            println("parseExpList:in while")
            result = result + line + "\n" # ,
            result = result + parseExp(buff)
            buff:reset()
            buff:mark(100)
            line = buff: readLine()
            myArr = line:split(" ")
            word = myArr: get(1)
        }
     }
     result = result + "</expressionList>" + "\n"
     return result
}



function main = |args| {
    let keyword = list("class","constructor","function","method","field","static","var","int","char","boolean","void","true","false","null","this","let","do","if","else","while","return")
    let symbol = list('{','}','(',')','[',']','.',',',';','+','-','*','/','&','|','<','>','=','~')
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
            var newXml = ""
            currentLine = buff: readLine() #we dont need to read the <tokens> line
             while currentLine != "</tokens>"{
                let tempArray = currentLine:split(" ")
                let myWord = tempArray: get(1)
                if( myWord == "class"){
                    newXml = newXml + parseClass(buff,currentLine)
                }
                currentLine = buff: readLine()
             }
             textToFile(newXml ,dir + "/" + name + ".xml" ) #create T.xml file
        }
    }
}