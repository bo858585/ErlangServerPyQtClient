#! /usr/bin/env python2.7
#coding=utf-8

HOST = 'localhost'    # The remote host
PORT = 43430          # The same port as used by the server

import socket
import sys
from PyQt4 import QtGui,QtCore

class ClientWindow(QtGui.QWidget):
    """
        Main client window
    """

    def __init__(self, parent=None):
        QtGui.QWidget.__init__(self, parent)

        self.setFixedSize(300, 300)
        self.setWindowTitle('Client')

        #EditBox
        self.edit = QtGui.QLineEdit("Edit", self)
        self.edit.setAlignment(QtCore.Qt.AlignCenter)
        self.edit.setGeometry(90, 0, 140, 35)       

        #Text field label
        self.label = QtGui.QLabel("No data", self)
        self.label.setAlignment(QtCore.Qt.AlignLeft)
        self.label.setGeometry(0, 60, 140, 35)

        #Send to server button
        self.send_to_server = QtGui.QPushButton('Send to server', self)
        self.send_to_server.setGeometry(160, 60, 140, 35)
        self.connect(self.send_to_server, QtCore.SIGNAL('clicked()'), self.send_text)
        
        #Exit button
        self.quit = QtGui.QPushButton('Exit', self)
        self.quit.setGeometry(100, 200, 60, 35)
        self.connect(self.quit, QtCore.SIGNAL('clicked()'), self.send_stop)

    def send_text(self):
        """
        Connect to server port, get text from edit box, add space to text, send text to server, 
        receive response, remove space and put text to label, close connection.
        Space need for situation when text in edit box is empty.
        """
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((HOST, PORT))

        sen =  self.edit.text()
        sen = sen + ' '
        s.send(sen)
        rec = s.recv(1024).decode("utf-32")
        
        s.close()

        rec = rec[0:-1]
        self.label.setText(rec)

    def send_stop(self):
        """
            
        """
        exit(0)
        

if __name__ == "__main__":
    """
    Run gui
    """
    app = QtGui.QApplication(sys.argv)
    qb = ClientWindow()
    qb.show()
    sys.exit(app.exec_())