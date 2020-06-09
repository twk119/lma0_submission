import re

#Function dictionaries
instructions = {"ADD": "r", "SUB": "r", "MOV": "r", "XSR": "r", "LDR": "r", "STR": "r", 
                "MUL16" : "r", "MUL32": "r", "POW16": "r", "POW32" : "r", "MAC16" : "r", "MAC32" : "r", 
                "LCG16" : "r", "LCG32" : "r", "NOT": "r", "OR": "r", "AND": "r", "XOR": "r",
                "ADDI": "i", "SUBI": "i", "LDI": "i", 
                "STP": "s", 
                "LDA": "ls", "STA": "ls", 
                "JEQ": "j", "JLT": "j", "JAL": "j", "JR": "j", "JMP": "j"}
registers_sorted = ["R0", "GP1", "GP2", "GP3", "GP4","GP5", "SP", "RA"]
registers = {"R0": "000", "GP1": "001", "GP2": "010", "GP3": "011", "GP4": "100", 
             "GP5": "101", "SP": "110", "RA": "111"}
cin_r = {"C0" : "00", "C1": "01", "CMSB" : "10", "CC" : "11"}
lcg_r = {"MUL16" : "000", "MUL32": "001", "POW16": "010", "POW32" : "011", 
         "MAC16" : "100", "MAC32" : "101", "LCG16" : "110", "LCG32" : "111"}
variables = {}

def checkvariables(linesrc):
    lines = []
    data = {}
    data_pos = False
    data_starting_pos = 0
    count = 0 
    for idx, line in enumerate(linesrc):
        #if you are alr in the data initialisation part of the text file
        if data_pos == True:
            if line[:3] == "ORG":
                count = 0  #reset count
                data_starting_pos = int(line.split(' ')[1],16)
            else:
                data_value = re.sub(r"^\s+|\s+$", "", line)
                data[count + data_starting_pos] = int(data_value.split(' ')[1],16)
                count += 1
        else:
            #check if u reach the data initialisation part of the text file
            if line[:3] == "ORG":
                data_pos = True #indicate that instructions from here onwards are data related
                data_starting_pos = int(line.split(' ')[1],16)
            else:
                if ":" in line:
                    variable = line.split(':')[0]
                    assert (variable[0].isalpha() or variable[0]=="_") and (variable[1:].isalnum())or variable[0]=="_", "Variable name invalid"
                    variables[variable] = '{0:x}'.format(idx)
                    instruction = line.split(':')[1]
                    #remove leading and trailing spaces
                    lines.append(re.sub(r"^\s+|\s+$", "", instruction))
                else:
                    lines.append(re.sub(r"^\s+|\s+$", "", line))
    return lines, data

#function to handle cin and s or offset
def checkcinrs(inst):
    opcode = inst[0]
    if opcode in ["ADD", "SUB", "MOV", "XSR"] :
        try:
            cin = cin_r[inst[3]]
        except:
            cin = "00"
        try:
            s = '{0:01b}'.format(int(inst[4]))
        except:
            s = "0"
        return (cin + s)
    else:
        try:
            return ('{0:03b}'.format(int(inst[3])))
        except:
            return "000"

#handle r type instructions
def check_r(inst):
    opcode = inst[0]
    if opcode in lcg_r.keys():
        bin_inst = "0000100" + lcg_r[opcode] + "000000"
        # print(bin_inst)
        return(int(bin_inst,2))

    assert inst[1] in registers.keys(), "Register invalid"
    Rd = registers[inst[1]]
    if opcode == "NOT":
        cins = checkcinrs(inst)
        bin_inst = "0000111" + "000" + "000" + Rd
        return(int(bin_inst,2))
    
    assert inst[2] in registers.keys(), "Register invalid"
    Rs = registers[inst[2]]
    
    if opcode == "OR":
        cins = checkcinrs(inst)
        # print(cins)
        bin_inst = "0000111" + "010" + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "AND":
        cins = checkcinrs(inst)
        bin_inst = "0000111" + "100" + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "XOR":
        cins = checkcinrs(inst)
        bin_inst = "0000111" + "110" + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))



    if opcode == "ADD":
        cins = checkcinrs(inst)
        bin_inst = "0000000" + cins + Rs + Rd
        return(int(bin_inst,2))
        
    if opcode == "SUB":
        cins = checkcinrs(inst)
        # print(cins)
        bin_inst = "0000001" + cins + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "MOV":
        cins = checkcinrs(inst)
        bin_inst = "0000010" + cins + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "XSR":
        cins = checkcinrs(inst)
        bin_inst = "0000011" + cins + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "LDR":
        offset = checkcinrs(inst)
        bin_inst = "0000101" + offset + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "STR":
        offset = checkcinrs(inst)
        bin_inst = "0000110" + offset + Rs + Rd
        # print(bin_inst)
        return(int(bin_inst,2))


# Function to find two's complement of the immediate part of the i type instructions
def findTwoscomplement(str): 
    str = list(str) 
  
    # Traverse the string to get first '1' from the last of string 
    pastfirstone = False
    for i, x in reversed(list(enumerate(str))):
        if (x == '1' and pastfirstone == False): 
            pastfirstone = True
            pass
        elif pastfirstone == True:
            if (str[i] == '1'): 
                str[i] = '0'
            else: 
                str[i] = '1'
  
    str = ''.join(str) 
    return str

#handle r type instructions
def check_i(inst):
    assert inst[1] in registers.keys(), "Register invalid"
    Rd = registers[inst[1]]
    opcode = inst[0]
    try:
        imm_int = int(inst[2],16)
        # print(imm_int)
        if imm_int < 0:
            flipped = '{0:012b}'.format(-imm_int)
            imm = findTwoscomplement(flipped)
        else:
            imm = '{0:012b}'.format(imm_int)
        # print(imm)
    except:
        imm = "000000000000"
        
    if opcode == "ADDI":
        bin_inst = "000100" + imm[-7:] + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "SUBI":
        bin_inst = "000101" + imm[-7:] + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "LDI":
        bin_inst = "000110" + imm[-7:] + Rd
        # print(bin_inst)
        return(int(bin_inst,2))

#check address for ls instructions
def findaddress_ls(address):
    if address in variables.keys():
        a = '{0:011b}'.format(int(variables[address],16))
    else:   
        a = '{0:011b}'.format(int(address,16))
        #LDA and STA can only access data addresses as 12th bit is set to 1
        assert int(address,16) > 2047, "Address inaccesible, \n needs to be greater than 0x7ff"
    return a[-11:]

#handle ls type instructions
def check_ls(inst):
    #check if the register being accessed are one of the first 4 registers
    assert inst[1] in registers_sorted[:4], "Register inaccessible, \n needs to be in the first 4 registers"
    Rd = registers[inst[1]][1:]
    opcode = inst[0]
    a = findaddress_ls(inst[2])
    if opcode == "LDA":
        bin_inst = "010" + a + Rd
        # print(bin_inst)
        return(int(bin_inst,2))
        
    if opcode == "STA":
        bin_inst = "011" + a + Rd
        # print(bin_inst)
        return(int(bin_inst,2))

#check address for j instructions
def findaddress_j(address):
    if address in variables.keys():
        a = '{0:011b}'.format(int(variables[address],16))
    else:   
        a = '{0:011b}'.format(int(address,16))
        #Jump instructions can only access instruction addresses as 12th bit is set to 0
        assert int(address,16) < 2048, "Address not accessible, \n needs to be less than 0x800"
    return a[-11:]

#handle j type instructions
def check_j(inst):
    opcode = inst[0]
    #JMP instruction will have to directly compare with R0 which is all zeros 
    if opcode == "JMP":
        a = findaddress_j(inst[1])
        bin_inst = "100" + a + "00"
        # print(bin_inst)
        return(int(bin_inst,2))
    
    # JAL instructions do not need a register
    if opcode == "JAL":
        a = findaddress_j(inst[1])
        bin_inst = "110" + a + "00"
        # print(bin_inst)
        return(int(bin_inst,2))
    
    #JR ignores other parameters in instruction as it directly deals with RA
    if opcode == "JR":
        bin_inst = "111" + '0000000000000'
        # print(bin_inst)
        return(int(bin_inst,2))

    #check if the register being accessed are one of the first 4 registers
    assert inst[1] in registers_sorted[:4] , "Register inaccessible, \n needs to be in the first 4 registers"
    Rd = registers[inst[1]][1:]
    a = findaddress_j(inst[2])
    #JEQ and JLT instructions access the first 4 registers (R0 to GP)
    if opcode == "JEQ":
        bin_inst = "100" + a + Rd
        # print(bin_inst)
        return(int(bin_inst,2))

    if opcode == "JLT":
        bin_inst = "101" + a + Rd
        # print(bin_inst)
        return(int(bin_inst,2))