# -*- coding: utf-8 -*-
"""
Created on Thu Jul 27 12:18:49 2023

@author: QC109_4

pyuic5 -x 실행파일 경로\파일명.ui -o 결과파일 경로\파일명.py
pyuic5 -x MainWindowUI_v1_00.ui -o MainWindowUI_v1_00.py
"""
import TCL_main.TCL_Creater_v1_00 as prj_mgr
import sys
import os
from PyQt5 import QtWidgets, QtGui
from PyQt5.QtWidgets import QFileDialog
from PyQt5.QtCore import Qt
from MainWindowUI_v1_00 import Ui_MainWindow

class VivadoPrjMgrMainWindow(QtWidgets.QMainWindow):
    
    def __init__(self, parent=None):
        QtWidgets.QMainWindow.__init__(self, parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        ###################################################################
        ## Settings default file path
        ###################################################################
        self.prj_name = "TimeController"
        self.folder_directory = "E:\RFSoC\GIT\RFSoC\RFSoC_Design_V1_1\IP_File_00\TimeController"
        self.part_name = "xczu28dr-ffvg1517-2-e"
        self.board_path = "E:/Xilinx/Vivado/2020.2/data/boards/board_files"
        self.board_name = "xilinx.com:zcu111:part0:1.4" 
        self.file_type = [".v", ".sv", ".xci"] #
        self.vivado_path = r"E:\Xilinx\Vivado\2020.2\bin\vivado.bat"  
        self.file_path = self.folder_directory + '\\' + self.prj_name + '.tcl'
        
        self.ui.ProjectDir.setPlainText(self.file_path)
        self.ui.PartName.setPlainText(self.part_name)
        self.ui.BoardPath.setPlainText(self.board_path)
        self.ui.BoardName.setPlainText(self.board_name)
        self.ui.VivadoPath.setPlainText(self.vivado_path)
        
    def SetProjectDir_Clicked(self):    
        file_path, _ = QtWidgets.QFileDialog.getSaveFileName()
        self.file_path = file_path
        
        directory = os.path.dirname(file_path)
        filename = os.path.basename(file_path)
        basename, extension = os.path.splitext(filename)
        self.prj_name = basename
        self.folder_directory = directory
        self.ui.ProjectDir.setPlainText(file_path)
        print(self.prj_name)
        print(self.folder_directory)
        
    # def SetFolderDir_Clicked(self):
    #     folderpath = QtWidgets.QFileDialog.getExistingDirectory(self, 'Select Folder')
    #     self.folder_directory = folderpath
    #     self.file_path = self.folder_directory + '\\' + self.prj_name + '.tcl'
    #     print(self.file_path)
    
    def SetPartName_Clicked(self):
        self.part_name = self.ui.PartName.toPlainText()
        print(f'set part name {self.part_name}')
        
    def SetBoardName_Clicked(self):
        self.board_name = self.ui.BoardName.toPlainText()
        print(f'set part name {self.board_name}')
        
    def SetVivadoPath_Clicked(self):
        fname=QFileDialog.getOpenFileName(self)
        self.ui.VivadoPath.setPlainText(fname[0])
        self.vivado_path = fname[0]
    
    def SetBoardPath_Clicked(self):
        folderpath = QtWidgets.QFileDialog.getExistingDirectory(self, 'Select Folder')
        self.board_path = folderpath
        self.ui.BoardPath.setPlainText(folderpath)
        print(self.board_path)
    
    def MakeProject_Clicked(self):
        prj_mgr.run(self.folder_directory,self.prj_name,self.part_name,self.board_path,self.board_name,self.file_type,self.vivado_path, self.file_path)
        
if __name__ == '__main__':
    app = QtWidgets.QApplication.instance()
    if app is None:
        app = QtWidgets.QApplication([])
    
    MainWindow = VivadoPrjMgrMainWindow()
    #    dc = MyDynamicMplCanvas(ui.widget, width=5, height=4, dpi=100)
    MainWindow.show()
    app.exec_()
#    sys.exit(app.exec_())