#!/usr/bin/python3
## -*- coding: latin-1 -*-

# Change log
# v1_00: Initial version

import os
import subprocess
import io
import time
import socket
import numpy as np

S00_AXIS_TDATA=0x0
S00_AXIS_TVALID=0x1
DAC00_FAST_SHUTDOWN=0x2
DAC00_PL_EVENT=0x3
DAC00_NCO_FREQ=0x4
DAC00_NCO_PHASE=0x5
DAC00_NCO_PHASE_RST=0x6
DAC00_NCO_UPDATE_EN=0x7
DAC0_NCO_UPDATE_REQ=0x8
DAC0_SYSREF_INT_GATING=0x9
DAC0_SYSREF_INT_REENABLE=0xA
UPDATE=0xF


class TCP_Client:
    def __init__(self, defaultIPAddress = '192.168.1.10', defaultTCPPort = 7):
        self.IPAddress = defaultIPAddress
        self.TCPPort = defaultTCPPort


    def connect(self):
        """ Opens the device.
        
        Args:
            None
        
        Returns:
            None
        """
        print(self.IPAddress)
        print(self.TCPPort)
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((self.IPAddress,self.TCPPort))
        self.socket.settimeout(20)
        
        
    def disconnect(self):
        self.socket.close()
        
    def write(self, commandWithoutNewline):
        """ Send the command.
        
        Args:
            commandWithoutNewline (unicode string): '\n' is automatically added,
                so it should not be added to the argument
        
        Returns:
            None
        """
        self.socket.send(bytes(commandWithoutNewline, 'latin-1'))

        
        

    def read(self):
        """ Reads data from the device.
        
        Args:
            None
        
        Returns:
            unicode string: received string
        """
        return (self.socket.recv(10000).decode('latin-1'))

class RFSoC:
    def __init__(self):    
        self.tcp = TCP_Client()
        
    def connect(self):
        self.tcp.connect()
        print("RFSoC is connected with TCP")
        
    def autoStart(self):
        #TimeController
        self.tcp.write("#TIME_CONT#write_fifo#0#2#!EOL#")
        a = self.tcp.read()
        print(a)
        
        self.tcp.write("#TIME_CONT#write_fifo#0#9#!EOL#")
        a = self.tcp.read()
        print(a)
    def autoEnd(self):
        #TimeController
        self.tcp.write("#TIME_CONT#write_fifo#0#0#!EOL#")
        a = self.tcp.read()
        print(a)
        
        self.tcp.write("#TIME_CONT#write_fifo#0#2#!EOL#")
        a = self.tcp.read()
        print(a)
    
    def sendBin(self, data_list):
        for i in range(len(data_list)):
            self.tcp.write(data_list[i])
            a = self.tcp.read()
    
    def stopBin(self):
        self.tcp.send('#BIN#stop_binary#!EOL#')
        a = self.tcp.read()
        print(a)
        
    def recvCallback(self):
        self.tcp.write('#CPU#trans_callback#0#!EOL#')
        a = self.tcp.read()
        print(a)
        
    def disconnect(self):
        self.tcp.disconnect()
    

if __name__ == "__main__": 
    RFSoC = RFSoC()
    RFSoC.connect()
    RFSoC.autoEnd()