from itertools import count
from platform import machine
import re
import math

from numpy import number

def ans_maker(ans):
    arr = list(ans.values())
    # print(arr)

    out = ""
    help_hex =""

    for i in range (len(arr)):
        # print(arr[i])

        if (arr[i]=='66' or arr[i]=='67'):
            out += arr[i]

        elif arr[i]=='0100'  and arr[3]!='':
            help_hex+=arr[i]

        elif arr[i]!="0100" and arr[i]!='':
            help_hex+=arr[i]
            # help_hex += "-"
    # print(help_hex)
    decimal = int(help_hex,2)
    hexad = str(hex(decimal))
    hexad = hexad[2:]
    if (help_hex[:4]=="0000"):
        hexad = '0' + hexad
    out += hexad
    print(out)

# function to find the size of each operand
def find_size_operand(reg):

    # print("reg:", reg)
    size = 0
    
    #handing r8b - r15b
    if ( reg[0] == "r" and reg[len(reg)-1] == "b"):
        size = 8

    #handling r8w - r15w
    elif ( reg[0] == "r" and reg[len(reg)-1] == "w"):
        size = 16

    #handling r8d - r15d
    elif ( (reg[0] == "r" and reg[len(reg)-1] == "d") or (reg[0] == "e") ):
        size = 32

    #handling r8 - r15 and rax - rdi 
    elif ( re.match(r"r[0-9]+", reg) ) or ( re.match(r"r[a-z]+", reg) ):
        size = 64
    
    #handling al-bh
    elif ( reg[len(reg)-1] == "l" or reg[len(reg)-1] == "h" ):
        size = 8
    else:
        size = 16
    
    return size

#function to find the code of each operand
def find_code_operand(reg):
    code = ""

    if (reg == "rax" or reg == "eax" or reg == "ax" or reg == "al"):
        code = "0000"

    elif (reg == "rcx" or reg == "ecx" or reg == "cx" or reg == "cl"):
        code = "0001"

    elif (reg == "rdx" or reg == "edx" or reg == "dx" or reg == "dl"):
        code = "0010"

    elif (reg == "rbx" or reg == "ebx" or reg == "bx" or reg == "bl"):
        code = "0011"

    elif (reg == "rsp" or reg == "esp" or reg == "sp" or reg == "ah"):
        code = "0100"
    
    elif (reg == "rbp" or reg == "ebp" or reg == "bp" or reg == "ch"):
        code = "0101"
    
    elif (reg == "rsi" or reg == "esi" or reg == "si" or reg == "dh"):
        code = "0110"

    elif (reg == "rdi" or reg == "edi" or reg == "di" or reg == "bh"):
        code = "0111"
    
    elif (reg == "r8" or reg == "r8d" or reg == "r8w" or reg=="r8b"):
        code = "1000"

    elif (reg == "r9" or reg == "r9d" or reg == "r9w" or reg=="r9b" ):
        code = "1001"

    elif (reg == "r10" or reg == "r10d" or reg == "r10w" or reg=="r10b" ):
        code = "1010"

    elif (reg == "r11" or reg == "r11d" or reg == "r11w" or reg=="r11b"):
        code = "1011"

    elif (reg == "r12" or reg == "r12d" or reg == "r12w" or reg=="r12b"):
        code = "1100"

    elif (reg == "r13" or reg == "r13d" or reg == "r13w" or reg=="r13b"):
        code = "1101"

    elif (reg == "r14" or reg == "r14d" or reg == "r14w" or reg=="r14b"):
        code = "1110"

    elif (reg == "r15" or reg == "r15d" or reg == "r15w" or reg=="r15b"):
        code = "1111"
    
    return code

def displacement_finder(disp):
    displacement = ""
    
    count_im_bit = int(disp,16)

    if count_im_bit < 128:
        count_im_bit = 8

    elif count_im_bit > 128:
        count_im_bit = 32


    disp = disp[2:]
    if(len(disp)%2!=0):
        disp = '0'+disp

    len_data = len(disp)
    for i in range(len_data-2, -1, -2):

        binary = str("{0:08b}".format(int(disp[i], 16)))
        binary = binary[len(binary)-4 :]
        displacement += binary
        # displacement += "--"

        binary = binary = str("{0:08b}".format(int(disp[i+1], 16)))
        binary = binary[len(binary)-4 :]
        displacement += binary
        # displacement += "--"
    number_of_bits = count_im_bit

    return displacement, number_of_bits
    
def scale_finder(scale):

    if scale == "2" :
        return "01"

    if scale == "4" :
        return "10"

    if scale == "8" :
        return "11"

    return "00"

def register(reg):
    data = { "size": 0, "code":0, "type": "" }

    #finding the size of the operand

    data["size"] = find_size_operand(reg)

    data["code"] = find_code_operand(reg)

    if re.match(r"r[0-9]*[a-z]*", reg) :
        data["type"] = "new"

    else:
        data["type"] = "old"

    return data

def reg_to_reg(command, reg1, reg2):

    machine_code = {"prefix":"","start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"" , "w":"1", "mod":"11", "reg/op":"", "r/m":"" }

    reg1_data = register(reg1)
    reg2_data = register(reg2)

    bit = reg1_data["size"]

    if bit == 8 :
        machine_code["w"] = "0"
    
    if bit == 8 or command=="bsf":
        machine_code["w"] = "0" 

    if command == "bsr":
        machine_code["w"] = "1" 

    if bit == 16:
        machine_code["prefix"] = "66"

    
    # if bit < 64 :
    machine_code["reg/op"] = reg2_data["code"][1:]
    machine_code["r/m"] = reg1_data["code"][1:]

    if (command=="bsf" or command=="bsr" or command=="imul"):
        machine_code["reg/op"] = reg1_data["code"][1:]
        machine_code["r/m"] = reg2_data["code"][1:]



    #handling rex
    if ( reg1_data["code"][0] == "1" or reg2_data["code"][0] == "1"  or reg1_data["size"] == 64 or reg2_data["size"] == 64 ):
        machine_code["r"] = reg2_data["code"][0]
        machine_code["b"] = reg1_data["code"][0]
        machine_code["rex.w"] = "0"
        machine_code["x"] = "0"

        if  reg1_data["size"] == 64 :
            machine_code["rex.w"] = "1"

        if (command=="bsf" or command=="bsr" or command=="imul"):
            machine_code["r"] = reg1_data["code"][0]
            machine_code["b"] = reg2_data["code"][0]



    #handling opcodes
    if (command == "adc"):
        machine_code["opcode"] = "0001000"

    if (command == "add"):
        machine_code["opcode"] = "0000000"

    if (command == "and"):
        machine_code["opcode"] = "0010000"

    if (command == "bsf"):
        machine_code["opcode"] = "000011111011110"

    if (command == "bsr"):
        machine_code["opcode"] = "000011111011110"
        
    if (command == "cmp"):
        machine_code["opcode"] = "0011100"

    if (command == "imul"):
        machine_code["opcode"] = "000011111010111"

    if (command == "mov"):
        machine_code["opcode"] = "1000100"

    if (command == "or"):
        machine_code["opcode"] = "0000100"

    if (command == "sbb"):
        machine_code["opcode"] = "0001100"

    if (command == "sub"):
        machine_code["opcode"] = "0010100"

    if (command == "test"):
        machine_code["opcode"] = "1000010"

    if (command == "xadd"):
        machine_code["opcode"] = "000011111100000"

    if (command == "xchg"):
        machine_code["opcode"] = "1000011"

    if (command == "xor"):
        machine_code["opcode"] = "0011000"

    return machine_code

# adc dx,0x3545
def imd_to_reg(command, reg1, imd):
    machine_code = {"prefix":"", "start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"", "s":"0" , "w":"1", "mod":"11", "reg":"", "r/m":"", "ImmData":"" }
    
    reg1_data = register(reg1)
    bit = reg1_data["size"]
    decimal_value = int(imd, 16)

    #w
    if bit == 8 :
        machine_code["w"] = "0"
    
    #r/m
    machine_code["r/m"] = reg1_data["code"][1:]

    #prefix
    if bit == 16:
        machine_code["prefix"] = "66"


    displacement , count_im_bit = displacement_finder(imd)

    machine_code["ImmData"] = displacement

    if( decimal_value<=127 and (reg1_data["size"]==16 or reg1_data["size"]==32 or reg1_data["size"]==64) ):
        machine_code["s"] = "1"

    #rex
    if (reg1_data["size"]==64 or reg1[0]=="r"):
        machine_code["r"] = "0"
        machine_code["x"] = "0"
        machine_code["b"] = reg1_data[0]
        if reg1_data["size"]==64:
            machine_code["w"]="1"
        else:
            machine_code["w"]="0"



    #handling reg and opcode part
    machine_code["opcode"] = "100000"

    if (command == "sub"):
        machine_code["reg"] = "101"

    # if (command == "test"):
    #     machine_code["reg"] = "000"
    #     machine_code["opcode"] = "111101"
    #     machine_code["s"] = "1"

    if (command == "xor"):
        machine_code["reg"] = "110"


    if (command == "adc"):
        machine_code["reg"] = "010"


    if (command == "add"):
        machine_code["reg"] = "000"


    if (command == "and"):
        machine_code["reg"] = "100"

    if (command == "cmp"):
        machine_code["reg"] = "111"


    if (command == "mov" and reg1_data["size"]==64 ):
        machine_code["reg"] = "000"
        machine_code["opcode"] = "110001"
        machine_code["s"] = "1"

    if (command == "mov" and reg1_data["size"]!=64 ):
        machine_code["reg"] = reg1_data["code"][1:]
        machine_code["opcode"] = "1011"
        machine_code["s"] = ""
        machine_code["mod"] = ""
        machine_code["r/m"] = ""

    

    if (command == "or"):
        machine_code["reg"] = "001"

    if (command == "shl"):
        machine_code["reg"] = "100"
        machine_code["opcode"] = "110000"

    if (command == "shr"):
        machine_code["reg"] = "101"
        machine_code["opcode"] = "110000"

    if (command == "sbb"):
        machine_code["reg"] = "011"


    return machine_code

def memmory_to_register(command, reg1, memory):
    machine_code = {"prefix1":"", "prefix2":"","start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"" , "w":"1", "mod":"", "reg/op":"", "r/m":"", 
     "ss":"", "inx":"", "base":"","displacement":"" }
    reg11_data = register(reg1)
    bit = reg11_data["size"]

    
    machine_code["reg/op"] = reg11_data["code"][1:]

    #prefix
    if bit == 16:
        machine_code["prefix"] = "66"

    #w
    if bit == 8 or command=="bsf":
        machine_code["w"] = "0" 
    if command == "bsr":
        machine_code["w"] = "1" 


    star_index =  memory.find("*")
    plus_index = memory.find("+")



    #[esi]
    if(star_index==-1 and plus_index==-1 and memory[0:2]!="0x"):
        # print("1")

        mem_data = register(memory)

        machine_code["mod"] = "00"

        machine_code["r/m"] = mem_data["code"][1:]

        #prefix
        if(mem_data["size"]==32):
            machine_code["prefix1"] = "67"

        #rex
        # print(memory)
        # print(reg1)
        # print(reg11_data["size"])
        if (memory[0]=="r" and memory[1].isdigit() == 1) or reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit()==1):
            machine_code["b"]=mem_data["code"][0]
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]="0"
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"

        if memory[1:] == "bp":
            machine_code["mod"] = "01"
            machine_code["displacement"] = "00000000"

        


    # [esi+0x51]
    elif( star_index ==-1  and plus_index !=-1 and memory[plus_index + 2 ]=="x" ):
        # print("2")
    
        reg_part = memory [:plus_index] 
        disp = memory [plus_index+1 :]

        mem_data = register(reg_part)

        machine_code["r/m"] = mem_data["code"][1:]


        #displacement to binary
        displacement , number_of_bits = displacement_finder(disp)

        machine_code["displacement"] = displacement

        if (number_of_bits==8):
            machine_code["mod"] = "01"
            machine_code["displacement"] += "0"*(8- len(displacement))

        elif(number_of_bits>8):
            machine_code["mod"] = "10"
            machine_code["displacement"] += "0"*(32- len(displacement))

        #prefix
        if(mem_data["size"]==32):
            machine_code["prefix1"] = "67"

        #rex 
        if (memory[0]=="r" and memory[1].isdigit() == 1 )or reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit() == 1):
            machine_code["b"]=mem_data["code"][0]
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]="0"
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"
        

        
  
    #[eax+edx] and [eax+ecx+0x55]
    elif( (star_index ==-1  and memory.count("+")==1 and  memory[plus_index+1] != "0") or (star_index ==-1  and memory.count("+")==2 ) ):
        # print("3")

        #[eax+edx] 
        if (star_index ==-1  and memory.count("+")==1 and  memory[plus_index+1] != "0"):
            index_reg = memory[plus_index+1:]  
            base_reg = memory[:plus_index]
            machine_code["mod"] = "00"
            if base_reg[1:] == "bp":
                machine_code["mod"] = "01"
                machine_code["displacement"] = "00000000"

        #[eax+ecx+0x55]
        elif (star_index ==-1  and memory.count("+")==2 ):

            base_reg = memory[:plus_index]

            sec_plus_index = memory[plus_index+1:].find("+")

            index_reg = memory[plus_index+1: sec_plus_index + len(base_reg) + 1]

            disp = memory[len(base_reg) + 1 + sec_plus_index+1:]

            #displacement part
            displacement , number_of_bits = displacement_finder(disp)

            machine_code["displacement"] = displacement

            if (number_of_bits==8):
                machine_code["mod"] = "01"
                machine_code["displacement"] += "0"*(8- len(displacement))

            elif(number_of_bits>8):
                machine_code["mod"] = "10"
                machine_code["displacement"] += "0"*(32- len(displacement))


        #common parts
        index_data = register(index_reg)
        base_data = register(base_reg)

        machine_code["r/m"] = "100"
        
        machine_code["ss"] = "00"
        machine_code["inx"] = index_data["code"][1:]
        machine_code["base"] = base_data["code"][1:]

        #prefix
        if(index_data["size"]==32 or base_data["size"]==32 ):
            machine_code["prefix1"] = "67"


        #rex
        if (index_reg[0]=="r" and index_reg[1].isdigit() == 1) or (base_reg[0]=="r" and base_reg[1].isdigit() == 1)or reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit() == 1):

            machine_code["b"]=base_data["code"][0]
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]=index_data["code"][0]
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"


    #[ecx*4] and [ecx*4+0x06] (cases where we have index but we don't have base)
    elif( (plus_index==-1 and star_index!=-1) or (star_index!=-1 and plus_index > star_index and memory.count("+")==1 ) ):
        # print("4")
        
        with_disp = False 

        index_reg = memory[:star_index]
        scale = memory[star_index+1]

        index_data = register(index_reg)

        if (  star_index+2 < len(memory) and memory[star_index+2]=="+"):
            # print("5")
            with_disp = True 
            disp =  memory[plus_index+1:]

        machine_code["mod"] = "00"
        machine_code["r/m"] = "100"

        machine_code["ss"] = scale_finder(scale)

        machine_code["inx"] = index_data["code"][1:]

        #assigning the code of ebp to base
        machine_code["base"] = "101"

        if with_disp:
            displacement , number_of_bits = displacement_finder(disp)
            machine_code["displacement"] = displacement
            machine_code["displacement"] += "0"*(32-len(displacement))
        
        elif with_disp == False :
            machine_code["displacement"] = "0"*32

        #prefix
        if(index_data["size"]==32 ):
            machine_code["prefix1"] = "67"

        #rex part    
        if (index_reg[0]=="r" and index_reg[1].isdigit() == 1) or reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit() == 1):

            machine_code["b"]="0"
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]=index_data["code"][0]
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"

    #[ebp+ecx*4] and [ebp+ecx*4+0x06]
    elif( ( plus_index!=-1 and star_index!=-1 and star_index > plus_index ) or ( star_index!=-1 and plus_index!=-1 and memory.count("+")==2 ) ):
        # print("5")

        disp_bool = False 


        machine_code["mod"] = "00"
        if memory.count("+")==2 :
            disp_bool = True 
            disp = memory[star_index+3:]
        
        base_reg = memory[:plus_index]
        index_reg = memory[plus_index+1:star_index]
        scale = memory[star_index+1]

        base_data = register(base_reg)
        index_data = register(index_reg)

        machine_code["ss"] = scale_finder(scale)
        machine_code["r/m"] = "100"
        machine_code["inx"] = index_data["code"][1:]
        machine_code["base"] = base_data["code"][1:]

        if(disp_bool == False and (base_reg == "rbp" or base_reg == "ebp" )):
            machine_code["mod"] = "01"
            machine_code["displacement"] = "00000000"
        
        elif(disp_bool==True):
            displacement , number_of_bits = displacement_finder(disp)
            machine_code["displacement"] = displacement

            if (number_of_bits==8):
                machine_code["mod"] = "01"
                machine_code["displacement"] += "0"*(8- len(displacement))

            elif(number_of_bits>8):
                machine_code["mod"] = "10"
                machine_code["displacement"] += "0"*(32- len(displacement))


        #prefix
        if(index_data["size"]==32 or base_data["size"]==32 ):
            machine_code["prefix1"] = "67"

        #rex part
        if (index_reg[0]=="r" and index_reg[1].isdigit() == 1) or (base_reg[0]=="r" and base_reg[1].isdigit() == 1)or reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit() == 1):

            machine_code["b"]=base_data["code"][0]
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]=index_data["code"][0]
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"

    #[0x5555551E]
    elif(plus_index==-1 and star_index==-1 and memory[:2]=="0x"):
        # print("6")
        machine_code["ss"] = "00"
        machine_code["r/m"] = "100"
        machine_code["inx"] = "100"
        machine_code["base"] = "101"
        machine_code["mod"] = "00"

        displacement , number_of_bits = displacement_finder(memory)
        machine_code["displacement"] = displacement

        if(8 < number_of_bits <= 32 ):
            machine_code["displacement"] += "0" * (32 - len(displacement))

        elif( number_of_bits <= 8 ):
            machine_code["displacement"] += "0" * (8 - len(displacement))


        #rex part
        if reg11_data["size"]==64 or (reg1[0]=="r" and reg1[1].isdigit() == 1):

            machine_code["b"]=base_data["code"][0]
            machine_code["r"]=reg11_data["code"][0]
            machine_code["x"]=index_data["code"][0]
            if reg11_data["size"]==64:
                machine_code["rex.w"]="1"
            else:
                machine_code["rex.w"]="0"

    #handling opcodes
    if (command == "adc"):
        machine_code["opcode"] = "0001001"

    if (command == "add"):
        machine_code["opcode"] = "0000001"

    if (command == "and"):
        machine_code["opcode"] = "0010001"

    if (command == "bsf"):
        machine_code["opcode"] = "000011111011110"

    if (command == "bsr"):
        machine_code["opcode"] = "000011111011110"
        
    if (command == "cmp"):
        machine_code["opcode"] = "0011101"

    if (command == "imul"):
        machine_code["opcode"] = "000011111010111"

    if (command == "mov"):
        machine_code["opcode"] = "1000101"

    if (command == "or"):
        machine_code["opcode"] = "0000101"

    if (command == "sbb"):
        machine_code["opcode"] = "0001101"

    if (command == "sub"):
        machine_code["opcode"] = "0010101"

    if (command == "test"):
        machine_code["opcode"] = "1000010"

    if (command == "xadd"):
        machine_code["opcode"] = "000011111100000"

    if (command == "xchg"):
        machine_code["opcode"] = "1000011"

    if (command == "xor"):
        machine_code["opcode"] = "0011001"
    
    return machine_code

def register_to_memory(command, memory, reg1):
    machine_code_1 = memmory_to_register(command, reg1, memory)

    if command == "sub" or command == "sbb" or command =="or":
        # print("here")
        new_d = machine_code_1["opcode"][ : len(machine_code_1["opcode"])-1 ] + "0"

        machine_code_1["opcode"] = new_d 


    elif command!="xadd" and command!="test":
        new_d = machine_code_1["opcode"][ : len(machine_code_1["opcode"])-1 ] + "1"

        machine_code_1["opcode"] = new_d 

    return machine_code_1
    # print(machine_code_1)

def one_operand_memory(command, size_label ,memory):

    # machine_code = {"prefix1":"", "prefix2":"","start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"" , "w":"1", "mod":"", "reg/op":"", "r/m":"", 
    #  "ss":"", "inx":"", "base":"","displacement":"" }

    help_dict = memmory_to_register(command, "ebx", memory)
    # print(help_dict)

    operand_code = {"neg": "1111011", "not": "1111011","push": '1111111', "pop": '1000111', "inc": '1111111', "dec": '1111111', "idiv":  '1111011'}
    regop = {"neg": "011", "not": "010", "push": "110", "pop": "000", "inc": "000", "dec": "001", "idiv": "111"}

    help_dict["opcode"] = operand_code[command]
    help_dict["reg/op"] = regop[command]

    if size_label == "BYTE":
        help_dict["w"] = "0"

    if (help_dict["r"]!="" or help_dict["x"]!="" or help_dict["b"]!=""):
        help_dict["rex.w"] = "0"

    help_dict["prefix2"] = ""

    if size_label == "QWORD":

        help_dict["rex.w"] = "1"

        if help_dict["r"] == '':
            help_dict["r"] = "0"

        if help_dict["x"] == '':
            help_dict["x"] = "0"

        if help_dict["b"] == '':
            help_dict["b"] = "0"


    if size_label == "WORD":
        help_dict["prefix2"] = "66"

    return(help_dict)

def one_operand_reg(command, reg):

    machine_code = {"prefix1":"", "prefix2":"","start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"" , "w":"1", "mod":"", "reg/op":"", "r/m":""}

    operand_code = {"neg":"1111011", "not":"1111011", "push":'01010', "pop":'01011', "inc":'1111111', "dec":'1111111', "idiv":'1111011'}
    regop = {"neg": "011", "not": "010", "push": "110", "pop": "000", "inc": "000", "dec": "001", "idiv": "111"}


    machine_code["opcode"] = operand_code[command]
    machine_code["reg/op"] = regop[command]
    machine_code["mod"] = "11"


    reg_data = register(reg)

    if reg_data["size"] == 16:
        machine_code["prefix2"] = "66"

    machine_code["r/m"] = reg_data["code"][1:]

    if reg_data["size"] == 8:
        machine_code["w"] = "0"

    if reg_data["size"] == 64 or reg[0] == "r":

        machine_code["r"] = "0"
        machine_code["b"] = reg_data["code"][0]
        machine_code["rex.w"] = "0"
        machine_code["x"] = "0"

        if  reg_data["size"] == 64 :
            machine_code["rex.w"] = "1"

    return(machine_code)

def shift(command, reg, imm):
    machine_code = {"prefix1":"", "start_rex":"0100", "rex.w":"", "r":"", "x":"", "b":"", "opcode":"" , "w":"1", "mod":"11", "reg/op":"", "r/m":"", "imm":""}
    reg_data = register(reg)

    if command =="shr":
        machine_code["reg/op"] = "101"
    if command =="shl":
        machine_code["reg/op"] = "100"

    if reg_data["size"] == 16:
        machine_code["prefix1"] = "66"

    machine_code["r/m"] = reg_data["code"][1:]

    if reg_data["size"] == 8:
        machine_code["w"] = "0"

    if reg_data["size"] == 64 or reg[0] == "r":

        machine_code["r"] = "0"
        machine_code["b"] = reg_data["code"][0]
        machine_code["rex.w"] = "0"
        machine_code["x"] = "0"

        if  reg_data["size"] == 64 :
            machine_code["rex.w"] = "1"
    
    if imm !="1" :
        machine_code["opcode"] = "1100000"
        c = bin(int(imm))[2:]
        c = '0'*(8 - len(c)) + c
        # print(c) 
        machine_code["imm"] = c

    if imm =="1" :
        machine_code["opcode"] = "1101000"

    return(machine_code)
# ans = shift("shr","rax", "3")
# # print(ans)
# ans_maker(ans)







# m = one_operand_memory("idiv", "QWORD","r11*4")
# print(m)
# ans_maker(m)

inp = input()


register_num = inp.find(",")
space_find = inp.find(" ")

if inp[:3] == "shl" or inp[:3] == "shr":
    if register_num !=-1:
        dec = inp[register_num+1:]
        if inp[register_num+1:register_num+3] == "0x":
            # print("hex num:", inp[register_num+3:])
            dec = int(inp[register_num+3:], 16)
        ans = shift(inp[:3], inp[space_find+1:register_num], dec)
    else:
        ans = shift(inp[:3], inp[space_find+1:], "1")
    ans_maker(ans)



elif ( inp == "ret" or inp == "stc" or inp == "clc" or inp == "std" or inp == "cld" or inp == "syscall"):
    ans_dict = {'ret':'c3', 'stc':'f9', 'clc':'f8', 'std':'fd',  'cld':'fc', 'syscall':'0f05'}
    print(ans_dict[inp])


elif (register_num==-1):
    braket_index = inp.find("[")
    if braket_index!=-1:
        sec_space = inp[space_find+1:].find(" ")
        sec_space += space_find
        sec_space += 1
        ans = one_operand_memory(inp[:space_find], inp[ space_find+1: sec_space], inp[braket_index+1: len(inp)-1])
        # print(ans)
        if (ans["rex.w"]=="0" and ans["r"]=="0" and ans["x"]=="0" and ans["b"]=="0"):
            ans["rex.w"]="" 
            ans["r"]="" 
            ans["x"]="" 
            ans["b"]=""

        ans_maker(ans)
    else:
        # print(inp[:space_find])
        # print(inp[space_find+1:])
        ans = one_operand_reg(inp[:space_find], inp[space_find+1:])
        # print(ans)
        ans_maker(ans)
    

elif (register_num != -1):


    c1 = inp[space_find+1]
    c1 = c1.isupper()

    c2 = inp[register_num+1]
    c2 = c2.isupper()

    if c1:
        list1 = inp.split()
        inp = ""
        inp += list1[0]
        inp += " "
        inp += list1[len(list1)-1]

    elif c2:
        list1 = inp.split()
        # print(list1)
        inp = ""
        inp += list1[0]
        inp += " "
        sp = list1[1]
        inp += sp[:sp.find(",")+1]
        inp += list1[len(list1)-1]
    
    # print(inp)
    register_num = inp.find(",")
    space_find = inp.find(" ")

    if inp[register_num+1] =="[":
        # print("11")
        # print(inp[:space_find])
        # print(inp[space_find+1:register_num])
        # print(inp[register_num+2:len(inp)-1])
        ans = memmory_to_register(inp[:space_find], inp[space_find+1:register_num], inp[register_num+2:len(inp)-1])  
        # print(ans)
        ans_maker(ans)
            

    elif inp[register_num+1]=="0":
        # print("22")
        # print(inp[:space_find])
        # print(inp[space_find+1:register_num])
        # print(inp[register_num+1:])
        ans = imd_to_reg (inp[:space_find], inp[space_find+1:register_num], inp[register_num+1:]) 
        # print(ans)
        ans_maker(ans)

    elif inp[register_num-1]=="]":
        # print("44")
        # print(inp[:space_find])
        # print(inp[space_find+2:register_num-1])
        # print(inp[register_num+1:])
        ans = register_to_memory ( inp[:space_find], inp[space_find+2:register_num-1], inp[register_num+1:] )
        # print(ans)
        ans_maker(ans)
    
    else:
        # print("33")
        # print(inp[:space_find])
        # print(inp[space_find+1:register_num])
        # print(inp[register_num+1:])
        ans = reg_to_reg (inp[:space_find], inp[space_find+1:register_num], inp[register_num+1:]) 
        # print(ans)
        ans_maker(ans)
# print(ans)









# register_to_memory("xadd", "rbx+0x5555551E", "r10")
# print(memmory_to_register("xadd", "r10", "rbx+0x5555551E"))



# reg_to_reg("test", "r8d", "edx")

# memmory_to_register("mov", "edx", "eax+ecx")

# imd_to_reg("mov", "edx", "0x5555551E")

# g = "1+2+3"
# plus_index = g.count("+")
# print(plus_index)


#bsf r8,r9
# 4d 0f bc c1
#0100 1101 / 0000 1111 1011 1100 /1100 0001

# 4d 0f bc c3




    

