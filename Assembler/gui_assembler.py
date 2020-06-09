import tkinter as tk
from tkinter.ttk import *
from tkinter import scrolledtext
from tkinter.filedialog import asksaveasfile 
from lma0_assembler import *
from PIL import ImageTk, Image

#create tkinter window
window = tk.Tk()
window.geometry("750x900")
window['background'] = '#212121'
window.title("lma0 Assembler")

#Add imperial logo
img = ImageTk.PhotoImage(file = "images/imperial.png")
canvas = tk.Canvas(window, bg="#212121", width=300, height=109, bd=0, highlightthickness=0)
canvas.create_image(10, 10, image=img, anchor='nw')
canvas.grid(row = 0, column = 0)

#App title
title = tk.Label(window, text = "lma0 Assembler", font=("Verdana",20), bg = "#212121", fg = "#85c3cf")
title.grid(column = 1, row = 0, padx = 10,pady = 10)

#dropdown menu of pre designed algorithms
combo = Combobox(window)
combo["values"] = ("fib_optimized", "fib_memoized", "lcg16","linkedlist", "skiplist", "None")
combo.current(5)
combo.grid(row=1, column=0, padx = 10,pady = 10, sticky = "NSEW")

#function for loading string from text files
def load_string():
    clear() #clear content in text box and mif box
    algo = combo.get()
    f = open("benchmark_tests/" + algo + ".txt", "r")
    print(f)
    for line in f.readlines():
        txt.insert(tk.INSERT, line)

#Load from pre designed algorithms
load = tk.Button(window, text = "Load", bg = "#065464", fg = "White", command = load_string)
load.grid(column = 1, row = 1, padx = 10,pady = 10, sticky = "NSEW")

#Text box
stringinst = tk.Label(window, text = "Insert string instructions here", font=("Verdana",15), 
                      bg = "#212121", fg = "#85c3cf")
stringinst.grid(column = 0, row = 2)
txt = scrolledtext.ScrolledText(window, width = 40, height = 30, bg = "#34acbc", fg = "White")
txt.grid(column = 0, row = 3, padx = 10,pady = 10, sticky = "NSEW")

#mif box
mifinst = tk.Label(window, text = "MIF version", font=("Verdana",15) , bg = "#212121", fg = "#85c3cf")
mifinst.grid(column = 1, row = 2)
mif = scrolledtext.ScrolledText(window, width = 40, height = 30 , bg = "#34acbc", fg = "White")
mif.grid(column = 1, row = 3, padx = 10,pady = 10, sticky = "NSEW")

#Function to convert text to mif
def click_convert():
    mif.delete('1.0',  'end-1c')
    stringtxt = txt.get('1.0', 'end-1c').splitlines()
    print(stringtxt)
    try:
        lines,data = checkvariables(stringtxt)

        # #convert string intructions to hexadecimal values
        hex_inst = convert_to_int(lines)
        # #write hexadecimal into mif commands
        mif_inst = write_to_mif_GUI(hex_inst, data, width=16, depth=4096)
        mif.insert(tk.INSERT, mif_inst)
        status.configure(text="Status: Conversion Successful:)")
    except AssertionError as e:
        show_error(e)

def show_error(error):
    status.configure(text="Status: " + str(error))

#Button to convert
convert = tk.Button(window, text = "Convert", bg = "#065464", fg = "White", command = click_convert)
convert.grid(column = 0, row = 4, padx = 10,pady = 5)

#clear content in text box and mif box
def clear():
    status.configure(text="Status: Idle")
    txt.delete('1.0',  'end-1c')
    mif.delete('1.0',  'end-1c')

#Button to clear
clearing = tk.Button(window, text = "Clear", bg = "#065464", fg = "White", command = clear)
clearing.grid(column = 0, row = 5, padx = 10,pady = 5)

#Save to mif file with .mif extension
def save(): 
    save_text_as = asksaveasfile(mode='w', defaultextension='.mif') 
    if save_text_as:
        text_to_save = mif.get('1.0', 'end-1c')
        save_text_as.write(text_to_save)
        save_text_as.close()

#Button to save
save = tk.Button(window, text = "Save", bg = "#065464", fg = "White", command = save)
save.grid(column = 1, row = 4, padx = 10,pady = 10)

#Status 
status = tk.Label(window, text = "Status: Idle", font=("Verdana",10), 
                      bg = "#212121", fg = "#ff0000")
status.grid(column = 1, row = 5)

window.mainloop()