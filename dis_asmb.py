import re
ans_dict = {'c3':'ret', 'f9':'stc', 'f8':'clc', 'fd':'std',  'fc':'cld', '0f05':'syscall'}
reg_code_dict = {
    "0000": ["al", "ax", "eax", "rax"],
    "0001": ["cl", "cx", "ecx", "rcx"],
    "0010": ["dl", "dx", "edx", "rdx"],
    "0011": ["bl", "bx", "ebx", "rbx"],
    "0100": ["ah", "sp", "esp", "rsp"],
    "0101": ["ch", "bp", "ebp", "rbp"],
    "0110": ["dh", "si", "esi", "rsi"],
    "0111": ["bh", "di", "edi", "rdi"],

    "1000": ["r8b", "r8w", "r8d", "r8"],
    "1001": ["r9b", "r9w", "r9d", "r9"],
    "1010": ["r10b", "r10w", "r10d", "r10"],
    "1011": ["r11b", "r11w", "r11d", "r11"],
    "1100": ["r12b", "r12w", "r12d", "r12"],
    "1101": ["r13b", "r13w", "r13d", "r13"],
    "1110": ["r14b", "r14w", "r14d", "r14"],
    "1111": ["r15b", "r15w", "r15d", "r15"]
}

# exception_opcodes = {
#     "110000": {"xadd"},
#     "101111": {"bsf", "bsr"},
#     "101011": {"imul"},
#     "100001": {"test", "xchg"},
# }

two_operand_opc_withoutImm = { "000100":"adc", "000000":"add", "001000":"and", "0000111110111100":"bsf", "0000111110111101":"bsr", "001110":"cmp", 
"0000111110101111":"imul", "100010":"mov", "000010":"or", "000110":"sbb", "001010":"sub", "100001":"test", "0000111111000000":"xadd", "100001":"xchg",
 "001100":"xor", "0000111111000001":"xadd", "0000111110111100":"bsf", "0000111110111101":"bsr"}

two_operand_opc_Imm = {
    "110001": {"mov"}, "1011": {"mov"}, #????????
    "100000": {"add", "adc", "sub", "sbb", "and", "or", "xor", "cmp"}, "111101": {"test"},
    "110100": {"shl", "shr"}, #when Imm == 1
    "110000": {"shl", "shr"} #when Imm != 1
}

one_operand_opc = { "111101": {"neg", "not", "idiv", "imul"}, "111111": {"inc", "dec", "push"}, "100011": {"pop"} }

regOp = {  
    '000': {"add", "pop", "inc", "test", "mov"},
    '001': {"dec", "or"},
    '010': {"adc", "not", },
    '011': {"sbb", "neg"},
    '100': {"shl", "and"},
    '101': {"sub", "shr", "imul"},
    '110': {"xor", "push"},
    '111': {"idiv", "cmp"},
}


parsed_dict = {}


def first_parse(inp):
    #finding prefixes
    if inp[0:2] == "67":
        parsed_dict["prefix1"] = "67"
        inp = inp[2:]

    if inp[0:2] == "66":
        parsed_dict["prefix2"] = "66"
        inp = inp[2:]

    #rex
    if inp[0] == "4":
        parsed_dict["start_rex"] = "0100"
        h = inp[1] #h includes 4 bit data of w r x b

        binary = str("{0:04b}".format(int(h, 16))) 

        parsed_dict["rex.w"] = binary[0]
        parsed_dict["r"] = binary[1]
        parsed_dict["x"] = binary[2]
        parsed_dict["b"] = binary[3]

        inp = inp[2:]


    #opcode
    if inp[0:2] == "0f":

        #we have 16 bit opcode
        h = inp[:4]
        # print("h:", h)


        binary = str("{0:08b}".format(int(h, 16))) 
        # print("binary:",binary)
        binary = "0000" + binary #forr '0' of 0f

        parsed_dict["opcode"] = binary[:16]
        parsed_dict["d"] = binary[14]
        parsed_dict["w"] = binary[15]

        inp = inp[4:]

    elif inp[:2] != "0f" :
        h = inp[:2]
        binary = str("{0:08b}".format(int(h, 16))) 
        parsed_dict["opcode"] = binary[:6]
        parsed_dict["d"] = binary[6]
        parsed_dict["w"] = binary[7]

        inp = inp[2:]


    #mod reg r/m
    h = inp[:2]
    binary = str("{0:08b}".format(int(h, 16))) 
    parsed_dict["mod"] = binary[:2]
    parsed_dict["reg/op"] = binary[2:5]
    parsed_dict["r/m"] = binary[5:8]
    inp = inp[2:]
    # print(parsed_dict)

    return inp


def base_func(parsed_dict): #this function ,using the dictionary I just made, finds the operator(through opcode) and the number of operands of that operator 
                            #and finds out if we have immidiate data or not
    data = {"operand_num":"", "Imm":"", "opr":""}

    if parsed_dict["opcode"] in two_operand_opc_withoutImm :
        # print("11")
        data["operand_num"] = "2"
        data["Imm"] = "0"
        if parsed_dict["opcode"] == "100001":
            if parsed_dict["d"] == "0":
                data["opr"] = "test"
            else:
                data["opr"] = "xchg"
        else:
            data["opr"] = two_operand_opc_withoutImm[ parsed_dict["opcode"] ] 

    elif (parsed_dict["opcode"] in two_operand_opc_Imm) and (parsed_dict["opcode"] in one_operand_opc):
        # print("44")
        two = two_operand_opc_Imm[parsed_dict["opcode"] ] 
        one = one_operand_opc[parsed_dict["opcode"] ]
        reg = regOp[parsed_dict["reg/op"]]

        for i in reg:
            if i in two:
                data["operand_num"] = "2"
                data["Imm"] = "1"
                data["opr"] = i 
                break
            if i in one:
                data["operand_num"] = "1"
                data["Imm"] = "0"
                data["opr"] = i 
                break

    elif parsed_dict["opcode"] in two_operand_opc_Imm :
        # print("22")
        data["operand_num"] = "2"
        data["Imm"] = "1"
        
        opr_list = two_operand_opc_Imm[ parsed_dict["opcode"] ]
        reg_part =  regOp[parsed_dict["reg/op"]]

        for i in opr_list:
            if i in reg_part:
                data["opr"] = i
                break

    elif parsed_dict["opcode"] in one_operand_opc:
        # print("33")
        data["operand_num"] = "1"
        data["Imm"] = "0"

        opr_list = one_operand_opc[ parsed_dict["opcode"] ]
        reg_part = regOp[parsed_dict["reg/op"]]

        for i in opr_list:
            if i in reg_part:
                data["opr"] = i
                break

    return(data)

def disp_maker(disp):
    # print(disp)
    ret = ""
    if disp.count("0") == len(disp)  :
        return "0x0"

    while(len(disp)>2):
        ret = disp[:2] + ret 
        disp = disp[2:]

    if (len(disp) == 2):
        ret = disp + ret 

    #deleting zeros  
    while(ret[0]=="0" ):
        ret = ret[1:]

    ret = "0x"+ret 
    return ret

def memory_handler(inp):
    ans = ""
    operation_size = 0 
    if "prefix2" in parsed_dict:
        operation_size = 16
    elif ("rex.w" in parsed_dict) and (parsed_dict["rex.w"] == "1"):
        operation_size = 64
    elif parsed_dict["w"]=="0":
        operation_size = 8
    elif operation_size == 0:
        operation_size = 32

    operation = {8:"BYTE PTR", 16:"WORD PTR", 32:"DWORD PTR", 64:"QWORD PTR"}
    scale = {"00":"1", "01":"2", "10":"4", "11":"8"}
    ans_sib = {"base":"", "index":"", "scale":"","disp":""}

    memory_prefix = operation[operation_size]

    #one operand(memmory without displacement) not QWORD [r11]
    if (inp == "" and parsed_dict["mod"]=="00") :
        # print("yo1")
        reg_code = parsed_dict["r/m"]

        if "b" in parsed_dict:
            reg_code = parsed_dict["b"] + reg_code

        reg_code = "0"*(4 - len(reg_code)) + reg_code

        reg_list = reg_code_dict[reg_code]

        if "prefix1" in parsed_dict:
            # ans += operation[operation_size]
            ans += memory_prefix
            ans += " "
            ans += "["
            ans += reg_list[2]
            ans += "]"
        elif "prefix1" not in parsed_dict:
            # ans += operation[operation_size]
            ans += memory_prefix
            ans += " "
            ans += "["
            ans += reg_list[3]
            ans += "]"
        
        return ans

    #[esi+0x51]
    elif parsed_dict["r/m"]!="100":
        # print(2)
        disp = inp 
        reg_code = parsed_dict["r/m"]

        if "b" in parsed_dict:
            reg_code = parsed_dict["b"] + reg_code

        reg_code = "0"*(4 - len(reg_code)) + reg_code

        reg_list = reg_code_dict[reg_code]

        if "prefix1" in parsed_dict:
            # ans += operation[operation_size]
            ans += memory_prefix
            ans += " "
            ans += "["
            ans += reg_list[2]
            ans += "+"
        elif "prefix1" not in parsed_dict:
            # ans += operation[operation_size]
            ans += memory_prefix
            ans += " "
            ans += "["
            ans += reg_list[3]
            ans += "+"

        dis_final =  disp_maker(disp)
        ans += dis_final
        ans +="]"
        return ans

    # if we had sib
    elif parsed_dict["r/m"]=="100":
        # print("yo2")
        # print("here")
        sib_part = inp[:2]
        binary = str("{0:08b}".format(int(sib_part, 16))) 
        parsed_dict["ss"]= binary[:2]
        parsed_dict["inx"]= binary[2:5]
        parsed_dict["bas"]= binary[5:8]
        inp = inp[2:]
        mod = parsed_dict["mod"]

        # print(parsed_dict)
        # print("inp:",inp)


        #if we had base
        if parsed_dict["bas"] != "101" :

            bas_code = parsed_dict["bas"]

            if "b" in parsed_dict:
                bas_code = parsed_dict["b"] + bas_code
                
            bas_code = "0"*(4 - len(bas_code)) + bas_code
            bas_list = reg_code_dict[bas_code]


            #finding the right reg for base
            if "prefix1" in parsed_dict:
                ans_sib["base"] = bas_list[2]

            elif "prefix1" not in parsed_dict:
                ans_sib["base"] = bas_list[3]

        #dont have base or base is bp 
        if parsed_dict["bas"] == "101":

            #no base
            if mod == "00":
                ans_sib["disp"] = disp_maker (inp[:8])
                inp = inp[8:]

            #base is bp
            else:
                bas_code = "0101"
                bas_list = reg_code_dict[bas_code]

                if "prefix1" in parsed_dict:
                    ans_sib["base"] = bas_list[2]

                elif "prefix1" not in parsed_dict:
                    ans_sib["base"] = bas_list[3]
        
        #if we had index
        if (parsed_dict["inx"] != "100" ) or ( ("x" in parsed_dict) and parsed_dict["x"]!="0" ):
            inx_code = parsed_dict["inx"]

            if "x" in parsed_dict:
                inx_code = parsed_dict["x"] + inx_code

            inx_code = "0"*(4 - len(inx_code)) + inx_code
            inx_list = reg_code_dict[inx_code]

            if "prefix1" in parsed_dict:
                ans_sib["index"] = inx_list[2]

            elif "prefix1" not in parsed_dict:
                ans_sib["index"] = inx_list[3]

            #finding scale
            ans_sib["scale"] = scale[ parsed_dict["ss"] ]
            # print(ans_sib)
        
        #disp
        if inp!="":
            # print("inp2:", inp)
            ans_sib["disp"] = inp
            # print(ans_sib["disp"])
            ans_sib["disp"] = disp_maker(ans_sib["disp"])
            # print("heeeree3:",ans_sib["disp"] )

    ans += "["
    if ans_sib["base"] !="" :
        ans += ans_sib["base"]

    if ans_sib["index"] !="" :
        if ans_sib["base"] !="" :
            ans+="+"
        ans += ans_sib["index"]
        ans += "*"
        ans += ans_sib["scale"]

    if   ("disp" in ans_sib) and   (ans_sib["disp"]!=""):
        if ans_sib["base"] !="" or ans_sib["index"] !="":
            ans += "+"
        ans += ans_sib["disp"]
    ans += "]"

    memory_prefix += " "
    memory_prefix+=ans

    return memory_prefix

#function for operations with one operand
def one_operand(data, inp):
    ans = ""
    ans += data["opr"]
    ans += " "

    #one operand (register)
    if inp=="" and parsed_dict["mod"]=="11":
        #the only operand is a register so there isn't any fields after r/m
        reg_code = parsed_dict["r/m"]

        if "b" in parsed_dict:
            reg_code = parsed_dict["b"] + reg_code

        reg_code = "0"*(4 - len(reg_code)) + reg_code

        reg_list = reg_code_dict[reg_code]

        if parsed_dict["w"] == "0":
            ans += reg_list[0] 
            return ans 
        if "prefix2" in parsed_dict:        
            ans += reg_list[1]
            return ans    
        if  ("rex.w" not in parsed_dict) or (parsed_dict["rex.w"] == "0"):
            ans += reg_list[2]
            return ans 
        else:
            ans+=reg_list[3]
            return ans

    #one operand(memmory)
    else:
        # print("one memory operand")
        # ans += memory_handler(inp)
        mem= memory_handler(inp)
        ans += mem
        return ans


def reg_to_reg(ans):
    reg1_code = parsed_dict["r/m"]
    reg2_code = parsed_dict["reg/op"]

    if "b" in parsed_dict:
        reg1_code = parsed_dict["b"] + reg1_code
    if "r" in parsed_dict:
        reg2_code = parsed_dict["r"] + reg2_code

    reg1_code = "0"*(4 - len(reg1_code)) + reg1_code
    reg2_code = "0"*(4 - len(reg2_code)) + reg2_code

    if(ans == "imul " or ans == "bsf " or ans=="bsr "):
        c = reg1_code
        reg1_code = reg2_code
        reg2_code = c

    reg1_list = reg_code_dict[reg1_code]
    reg2_list = reg_code_dict[reg2_code]

    # print("reg 1 list:", reg1_list)
    # print("reg 2 list:", reg2_list)


    if parsed_dict["w"] == "0" and ans!="bsf " and ans!="bsr ":
        ans += reg1_list[0] 
        ans += ","
        ans += reg2_list[0] 
        return ans 
    elif "prefix2" in parsed_dict:    
        ans += reg1_list[1]
        ans += ","
        ans += reg2_list[1] 
        return ans    
    elif  ("rex.w" not in parsed_dict) or (parsed_dict["rex.w"] == "0"):
        ans += reg1_list[2]
        ans += ","
        ans += reg2_list[2] 
        return ans 
    else:
        ans+=reg1_list[3]
        ans += ','
        ans += reg2_list[3] 
        return ans

# def mem_to_reg(ans):
    

def two_operand(data, inp):
    ans = ""
    ans += data["opr"]
    ans += " "

    #reg to reg
    # print(parsed_dict)

    if parsed_dict["mod"] == "11":
        x = reg_to_reg(ans)
        return x


    reg_code = parsed_dict["reg/op"]
    if "r" in parsed_dict:
        reg_code = parsed_dict["r"] + reg_code

    reg_code = "0"*(4 - len(reg_code)) + reg_code
    reg_list = reg_code_dict[reg_code]

    if parsed_dict["w"] == "0" and data["opr"]!="bsf":
        reg = reg_list[0] 
 
    elif "prefix2" in parsed_dict:        
        reg = reg_list[1]

            
    elif (("rex.w" in parsed_dict) and (parsed_dict["rex.w"] == "1")):
        reg = reg_list[3]
    
         
    else:
        reg = reg_list[2]
    # print("hi2")

    mem = memory_handler(inp)
    # print("hi3")

    if parsed_dict["d"] == "1" or data["opr"]=="bsr" or data["opr"]=="bsf" :
        #memory to reg
        ans += reg
        ans +=","
        ans += mem
    elif parsed_dict["d"] == "0":
        #memory to reg
        ans += mem
        ans +=","
        ans += reg
    return ans
   

def Imm_to_reg(data,inp):
    ans = ""
    ans += data["opr"]
    ans += " "

    reg_code = parsed_dict["r/m"]


    if "b" in parsed_dict:
        reg_code = parsed_dict["b"] + reg_code

    reg_code = "0"*(4 - len(reg_code)) + reg_code

    reg_list = reg_code_dict[reg_code]

    if parsed_dict["w"] == "0" and data["opr"]!="bsf":
        ans += reg_list[0] 
 
    elif "prefix2" in parsed_dict:        
        ans += reg_list[1]

            
    elif (("rex.w" in parsed_dict) and (parsed_dict["rex.w"] == "1")):
        ans+=reg_list[3]
    
         
    else:
        ans += reg_list[2]
    
    ans += ","
    if (inp!=""):
        m = disp_maker(inp)
        ans += m 
    if (inp==""):
        ans+="1"
    return ans
           

# print(parsed_dict)

inp = input()
one_go = False
if inp in ans_dict:
    print(ans_dict[inp])
else:
    inp = first_parse(inp)
    data = base_func(parsed_dict)
    # print(parsed_dict)
    # print(data)
    if data["operand_num"]=="2" and data["Imm"]=="0" and one_go==False:
        # print("hi")
        print(two_operand(data,inp))
        one_go =True
    elif data["operand_num"]=="1" and one_go==False:
        print(one_operand(data,inp))
        one_go =True

    elif data["Imm"] == "1" and one_go==False:
        print(Imm_to_reg(data,inp))
        one_go =True


    