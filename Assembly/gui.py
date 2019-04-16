from tkinter import *
from tkinter import ttk
from tkinter import filedialog
# https://github.com/pyusb/pyusb/blob/master/docs/tutorial.rst
import usb.core
import usb.util

def prog():
    fileLength = 0
    with open(filename.get(), 'rb') as file:
        word = file.read(4)
        while word:
            fileLength = fileLength + 1
            word = file.read(4)
            
    print('File length (words): '+str(fileLength))
    fileBytes = format(fileLength, '032b')
    rawBytes = fileLength.to_bytes(4, byteorder='big')
    ep.write('P')
    ep.write(rawBytes[3:4]+rawBytes[2:3]+rawBytes[1:2]+rawBytes[0:1])
    print('Data sent:')
    print('P')
    print(rawBytes[3:4]+rawBytes[2:3]+rawBytes[1:2]+rawBytes[0:1])
    
    with open(filename.get(), 'rb') as file:
        word = file.read(4)
        while word:
            ep.write(word)
            print(word)
            word = file.read(4)

    msgText.set('Program sent')
    print('Program sent')

def readUSB():
    output = ep2.read(size_or_buffer=320)
    msgText.set(str(output))
    print(output)

def openFile():
    filename.set(filedialog.askopenfilename())
    fileText.set('Program: '+filename.get())
    if dev is not None:
        programButton.state(['!disabled'])
    msgText.set('File opened')
    print('File '+filename.get()+' opened')

def sendText():
    sendData = textBox.get(1.0, 'end')
    textBox.delete(1.0, 'end')
    ep.write(bytes([1, 17]))        # Clear the display and turn led on
    ep.write(sendData[:-1])         # Get rid of newline at end
    ep.write(bytes([7, 18, 29]))    # Buzz so we know we sent, turn led off, turn cursor on
    msgText.set('Text sent')
    print("Data sent:")
    print(bytes(sendData[:-1], 'utf-8'))

dev = usb.core.find(idVendor=0x0403, idProduct=0x6015)

if dev is None:
    print('Warning: USB device not found')
else:
    if dev.is_kernel_driver_active(0):
        reattach = True
        dev.detach_kernel_driver(0)
    dev.set_configuration()
    cfg = dev.get_active_configuration()
    intf = cfg[(0,0)]

    ep = usb.util.find_descriptor(
        intf,
        custom_match = 
        lambda e: 
            usb.util.endpoint_direction(e.bEndpointAddress) == 
            usb.util.ENDPOINT_OUT)

    assert ep is not None
	
    ep2 = usb.util.find_descriptor(
        intf,
        custom_match = 
        lambda e: 
            usb.util.endpoint_direction(e.bEndpointAddress) == 
            usb.util.ENDPOINT_IN)

    assert ep2 is not None

root = Tk()
GUI = ttk.Frame(root, padding=(5,5,5,5))
filename = StringVar()
fileText = StringVar()
fileText.set('Program: none')
msgText = StringVar()
msgText.set('Status')
warnText= StringVar()
warnText.set('OK')
titleLabel = ttk.Label(GUI, text='GUI')
msgLabel = ttk.Label(GUI, textvariable=msgText)
warnLabel = ttk.Label(GUI, textvariable=warnText)
warnLabel['foreground'] = 'green'    
fileLabel = ttk.Label(GUI, textvariable=fileText, width=50,
                      anchor='center')
textBox = Text(GUI, width=50, height=5)
programButton = ttk.Button(GUI, text='Send Program', command=prog)
programButton.state(['disabled'])
fileButton = ttk.Button(GUI, text='Open Program', command=openFile)
readButton = ttk.Button(GUI, text='Read from USB', command=readUSB)
sendButton = ttk.Button(GUI, text='Send Text', command=sendText)
if dev is None:
    readButton.state(['disabled'])
    sendButton.state(['disabled'])
    warnLabel['foreground'] = 'red'
    warnText.set('Warning: USB device not found')

GUI.grid(column=0, row=0, sticky=(N, S, E, W))
titleLabel.grid(column=0, row=0, sticky=(N))
fileButton.grid(column=0, row=1, sticky=(N))
fileLabel.grid(column=0, row=2, sticky=(N))
programButton.grid(column=0, row=3, sticky=(N))
readButton.grid(column=0, row=4, sticky=(N))
textBox.grid(column=0, row=5, sticky=(N))
sendButton.grid(column=0, row=6, sticky=(N))
msgLabel.grid(column=0, row=7, sticky=(N))
warnLabel.grid(column=0, row=8, sticky=(N))

root.columnconfigure(0, weight=1)
root.rowconfigure(0, weight=1)
GUI.columnconfigure(0, weight=1)
root.mainloop()
