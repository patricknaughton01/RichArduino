# File assembler.py
from tkinter import filedialog
from tkinter import *
import os
 
# logical shift right 
def rshift(val, n): return (val % 0x100000000) >> n

# Get hex of instruction
def getHex(line):
	instHex = 0
	global pc

	# if line contains a tag seperate the rest of the line
	if(line.find(";") != -1):
		line = line[:line.find(";")]
	if(line.find(":") != -1):
		line = line[line.find(":")+1:]	



	# seperate the line by the commas to get the op and the args
	line = line.strip()
		# if line is blank skip it
	if(line == ""):
		pc -= 4
		return
	# split line by commas
	args = line.split(",")

	# check if segment before first comma has space, if so, split the instruction from the first arg
	if args[0].find(" ") == -1:
		instruction = args[0]
		args = []
	else:
		instruction, args[0] = args[0].split(" ")
	instruction = instruction.strip()
	stripped_args = []
	for arg in args:
		stripped_args.append(arg.strip())
	args = stripped_args

	# opcodes 
	instructions = {"nop"	: 0,
				    "ld"	: 1,
				    "ldr"	: 2,
				    "st"	: 3,
				    "str"	: 4,
				    "la"	: 5,
				    "lar"	: 6,
				    "br"	: 8, "brnv"  : 8, "brzr"  : 8, "brnz"  : 8, "brpl"  : 8, "brmi"	 : 8,
				 	"brl"	: 9, "brlnv" : 9, "brlzr" : 9, "brlnz" : 9, "brlpl"	: 9, "brlmi" : 9,
				 	"add"	: 12,
				 	"addi"	: 13,
				 	"sub"	: 14,
				 	"neg"	: 15,
				 	"and"	: 20,
				 	"andi"	: 21,
				 	"or"	: 22,
				 	"ori"	: 23,
				 	"not"	: 24,
				 	"shr"	: 26,
				 	"shra"	: 27,
				 	"shl"	: 28,
				    "shc"	: 29,
				    "stop"	: 31,
			   	   }

	# check for .db and .dw commands and shift program counter accordingly
	if(not (instruction.strip() in instructions)):
		if(instruction == ".db"):
			pc = pc + int(args[0]) - 4
			return
		elif(instruction == ".dw"):
			pc = pc + 4*int(args[0]) - 4
			return

	# check that registers passed are valid
	for arg in args:
		if(arg.find("r") != -1 and arg.find("(") == -1):
			if(int(arg[1:]) < 0 or int(arg[1:]) > 31):
				raise Exception

	# set highest five bits to opcode
	opcode = instructions[instruction.strip()]
	instHex = instHex | (opcode << 27)

	# checks opcode and places args in corresponding locations
	if(opcode == 1 or opcode == 3 or opcode == 5): # ld, st, la
		instHex = instHex | (int(args[0][1:]) << 22)
		rbAndCTwo = args[1].split("(")
		if(len(rbAndCTwo) > 1):
			if(int(rbAndCTwo[1][1:-1]) >= 0 and int(rbAndCTwo[1][1:-1]) <= 31):
				instHex = instHex | (int(rbAndCTwo[1][1:-1]) << 17)
			else:
				raise Exception
		if(rbAndCTwo[0] in tags):
			instHex = instHex | (rshift(tags.get(rbAndCTwo[0]) << 15, 15))
		elif(rbAndCTwo[0] != ""):
			instHex = instHex | (rshift(int(rbAndCTwo[0]) << 15, 15))
	elif(opcode == 2 or opcode == 4 or opcode == 6): # ldr, str, lar
		instHex = instHex | (int(args[0][1:]) << 22)
		if(args[1] in tags):
			instHex = instHex | (rshift((tags.get(args[1]) - pc) << 10, 10))
		else:
			instHex = instHex | (rshift((int(args[1]) - pc) << 10, 10))
	elif(opcode == 12 or opcode == 14 or opcode == 20 or opcode == 22): # add, sub, and, or
		instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17)  | (int(args[2][1:]) << 12)
	elif(opcode == 13 or opcode == 21 or opcode == 23): # addi, andi, ori
		instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17) | (rshift(int(args[2]) << 15, 15))
	elif(opcode == 15 or opcode == 24): # neg, not
		instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 12)
	elif(opcode == 26 or opcode == 27 or opcode == 28 or opcode == 29): # shr, shra, shl, shc
		instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17)
		if(args[2].find("r") != -1):
			instHex = instHex | (int(args[2][1:]) << 12)
		else:
			instHex = instHex | (rshift(int(args[2]) << 20, 20))
	elif(opcode == 8): # br instructions
		if(instruction == "br"):
			instHex = instHex | 1
			if(len(args) == 1):
				instHex = instHex | (int(args[0][1:]) << 17)
			else:
				instHex = instHex | (int(args[0][1:]) << 17) | (int(args[1][1:]) << 12)
				if(args[2] in tags):
					instHex = instHex | (rshift(tags.get(args[2]) << 20, 20))
				else:
					instHex = instHex | (rshift(int(args[2]) << 20, 20))
		elif(instruction == "brnv"):
			pass
		else:
			instHex = instHex | (int(args[0][1:]) << 17) | (int(args[1][1:]) << 12)
			if(instruction == "brzr"):
				instHex = instHex | 2
			elif(instruction == "brnz"):
				instHex = instHex | 3
			elif(instruction == "brpl"):
				instHex = instHex | 4
			elif(instruction == "brmi"):
				instHex = instHex | 5
	elif(opcode == 9): # brl instructions
		if(instruction == "brl"):
			instHex = instHex | 1
			if(len(args) == 2):
				instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17)
			else:
				instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17) | (int(args[2][1:]) << 12)
				if(args[3] in tags):
					instHex = instHex | (rshift(tags.get(args[3]) << 20, 20))
				else:
					instHex = instHex | (rshift(int(args[3]) << 20, 20))
		elif(instruction == "brlnv"):
			instHex = instHex | (int(args[0][1:]) << 22)
		else:
			instHex = instHex | (int(args[0][1:]) << 22) | (int(args[1][1:]) << 17) | (int(args[2][1:]) << 12)
			if(instruction == "brlzr"):
				instHex = instHex | 2
			elif(instruction == "brlnz"):
				instHex = instHex | 3
			elif(instruction == "brlpl"):
				instHex = instHex | 4
			elif(instruction == "brlmi"):
				instHex = instHex | 5

	# write the hex into the output file
	hexStr = format(instHex, '08x') + "\n"
	saveHexFile.write(hexStr)
	binary = instHex.to_bytes(4, byteorder = 'little')
	#Output least significant byte of word first, then second least, then third, then fourth
	saveBinaryFile.write(binary)
		
# get tags and store there locations
def getTags(line):
	if(line.find(";") != -1):
		line = line[:line.find(";")]
	global pc
	line = line.strip()
	if(line == ""):
		pc -= 4
		return
	if(line.find(":") != -1):
		tag = line.split(":")
		tags.update({tag[0].strip(): pc})

# check if a .org command is used, and if so, set program counter accordingly
def checkOrg(line):
	if(line.find(";") != -1):
		line = line[:line.find(";")]
	if(line.find(".org") != -1):
		line = line.strip()
		parts = line.split(" ")
		global pc 
		pc = int(parts[1])
		return True
	else:
		return False


# run
root = Tk()

try:
	# open window to find .txt files
	root.withdraw()
	root.filename = filedialog.askopenfilename(initialdir = os.getcwd(), title = "Select file", filetypes = (("Text File", "*.txt"),("All Files","*.*")))
	txtFile = open(root.filename)
	# output to file in same location with same name including "Hex" and "Binary" before the .txt's
	saveHexFileName = root.filename.replace(".txt", "Hex.txt")
	saveBinaryFileName = root.filename.replace(".txt", "Binary.txt")
	saveHexFile = open(saveHexFileName, 'w')
	saveBinaryFile = open(saveBinaryFileName, 'wb')
except ValueError as err:
	print ("An Error Occurred: " + err)
	quit()
pc = 0
tags = {}
errLine = ""
try:
	# search file for tags
	for line in txtFile:
		errLine = line
		if(not checkOrg(line)):
			getTags(line)
			pc += 4

	pc = 0
	txtFile = open(root.filename)

	# go through file and convert to hex
	for line in txtFile:
		errLine = line
		if(not checkOrg(line)):
			pc += 4
			getHex(line)

	saveHexFile.close()
	saveBinaryFile.close()

except ValueError as err:
    print ("Could not assemble code due to error: " + err + "\n" + errLine)
    quit()

print("**Program assembled**")
