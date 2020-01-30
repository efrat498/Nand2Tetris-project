# Nand2Tetris-project
 Build a compiler to Jack language with Golo Language. 
 The project included translating Jack files to VM files and then to Assembly files.
 
 Pojects 07 & 08 are translating the vm files to asm (hack) files. 
 
 Project 10 is the part of the syntax analysis - firat step: creating from jack file a new fileT.xml. 
 The fileT.xml contains tokens of the jack file.

 Second step: reading the fileT.xml and creating file.xml with hierarchical structure in accordance to jack language grammar.

 Project 11 is the part of code generation. Translating from the xml files (project 10) to vm files.
 Using the hierarchical structure from project 10 to analyze the code, instead of writing to xml files -
  for every rule in jack language grammar will be written the vm commanda to a vm file.
