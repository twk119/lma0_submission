import sys
from checks import *


#convert string intructions to hexadecimal values
def convert_to_int(lines):
    assembly = []
    #Loop through each line of instruction and do checks based on opcode type
    for line in lines:
        inst = line.strip('\n').split(" ")
        print(inst)
        assert inst[0] in instructions.keys(), "Opcode invalid"
        opcode = inst[0]
        #r type instruction check
        if instructions[opcode] == "r":
            assembly.append(check_r(inst))
        #i type instruction check
        elif instructions[opcode] == "i":
            assembly.append(check_i(inst))
        #s type instruction check
        elif instructions[opcode] == "s":
            bin_inst = "000111" + "0000000000"
            assembly.append(int(bin_inst,2))
        #ls type instruction check
        elif instructions[opcode] == "ls":
            assembly.append(check_ls(inst))
        #j type instruction check
        else: 
            assembly.append(check_j(inst))
    return assembly

#write hexadecimal into mif file directly
def write_to_mif(f_out, hex_inst, data, width=16, depth=4096):
    assert len(hex_inst) <= depth, "Length of instructions longer than RAM depth"
    mif = 'WIDTH={:d};\nDEPTH={:d};\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\nCONTENT BEGIN\n'.format(width, depth)
    l_index = str(len('{:x}'.format(depth)))
    l_data = str(int(width / 4))
    s = '\t{:0' + l_index + 'X} : {:0' + l_data + 'X};\n'
    r = '\t[{:0' + l_index + 'X}..{:0' + l_index + 'X}] : {:0' + l_data + 'X};\n'
    for i, j in enumerate(hex_inst):
        mif += s.format(i, j)
    if data:
        sorted_data_keys = list(data.keys())
        sorted_data_keys.sort()
        origin = min(list(data.keys()))
        #create range from the last instruction to the start of data stored in ram
        if len(mif) < origin:
            mif += r.format(len(hex_inst), origin - 1, 0)
        mif += s.format(sorted_data_keys[0], data[sorted_data_keys[0]])
        for i in range(1, len(sorted_data_keys)):
            if sorted_data_keys[i] - 1 == sorted_data_keys[i-1]:
                mif += s.format(sorted_data_keys[i], data[sorted_data_keys[i]])
            else: 
                mif += r.format(sorted_data_keys[i-1] + 1, sorted_data_keys[i] - 1, 0)
                mif += s.format(sorted_data_keys[i], data[sorted_data_keys[i]])
        #create range from the last data stored to the end of ram depth
        mif += r.format(max(list(data.keys())) + 1, depth - 1, 0)
        
    else:
        if len(mif) == depth - 1:
            mif += s.format(depth - 1, 0)
        elif len(mif) < depth - 1:
            mif += ('\t[{:0' + l_index + 'X}..{:0' + l_index + 'X}] : {:0' + l_data + 'X};\n').format(len(hex_inst), depth - 1, 0)
    mif += 'END;\n'
    with open(f_out, 'w') as f:
        f.write(mif)

def write_to_mif_GUI(hex_inst, data, width=16, depth=4096):
    assert len(hex_inst) <= depth, "Length of instructions longer than RAM depth"
    mif = 'WIDTH={:d};\nDEPTH={:d};\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\nCONTENT BEGIN\n'.format(width, depth)
    l_index = str(len('{:x}'.format(depth)))
    l_data = str(int(width / 4))
    s = '\t{:0' + l_index + 'X} : {:0' + l_data + 'X};\n'
    r = '\t[{:0' + l_index + 'X}..{:0' + l_index + 'X}] : {:0' + l_data + 'X};\n'
    for i, j in enumerate(hex_inst):
        mif += s.format(i, j)
    if data:
        sorted_data_keys = list(data.keys())
        sorted_data_keys.sort()
        origin = min(list(data.keys()))
        #create range from the last instruction to the start of data stored in ram
        if len(mif) < origin:
            mif += r.format(len(hex_inst), origin - 1, 0)
        mif += s.format(sorted_data_keys[0], data[sorted_data_keys[0]])
        for i in range(1, len(sorted_data_keys)):
            if sorted_data_keys[i] - 1 == sorted_data_keys[i-1]:
                mif += s.format(sorted_data_keys[i], data[sorted_data_keys[i]])
            else: 
                mif += r.format(sorted_data_keys[i-1] + 1, sorted_data_keys[i] - 1, 0)
                mif += s.format(sorted_data_keys[i], data[sorted_data_keys[i]])
        #create range from the last data stored to the end of ram depth
        mif += r.format(max(list(data.keys())) + 1, depth - 1, 0)
        
    else:
        if len(mif) == depth - 1:
            mif += s.format(depth - 1, 0)
        elif len(mif) < depth - 1:
            mif += ('\t[{:0' + l_index + 'X}..{:0' + l_index + 'X}] : {:0' + l_data + 'X};\n').format(len(hex_inst), depth - 1, 0)
    mif += 'END;\n'
    return mif

if __name__ == "__main__":
    #check if user has given text file and mif file
    assert len(sys.argv) == 3, "Missing text file and mif file"
    txt_file = sys.argv[1]
    mif_file = sys.argv[2]
    #open text file and input into a list of string instructions
    f = open(txt_file, "r")
    #check for variables
    lines,data = checkvariables(f.readlines())
    # print(lines)
    #convert string intructions to hexadecimal values
    hex_inst = convert_to_int(lines)
    #write hexadecimal into mif file directly
    write_to_mif(mif_file, hex_inst, data, width=16, depth=4096)
    print('Success')