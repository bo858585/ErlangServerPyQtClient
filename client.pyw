#! /usr/bin/env python2.7
#coding=utf-8

HOST = 'localhost'    # The remote host
PORT = 43429          # The same port as used by the server

import socket
import sys
from PyQt4 import QtGui, QtCore
from erlport import Port, Protocol

class ClientWindow(QtGui.QWidget, Protocol):
    """
        Main client window class with tcp protocol for send/receive messages
    """

    def __init__(self, parent=None, socket = None):
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
        Get text from edit box, add space to text, send text to server, 
        receive response, remove space and put text to label.
        Space need for situation when text in edit box is empty.
        """
        sen =  self.edit.text()
        sen = sen + ' '
        s.send(sen)
        rec = s.recv(1024).decode("utf-32")
        rec = rec[0:-1]
        self.label.setText(rec)

    def send_stop(self):
        """
            
        """
        exit(0)
        

if __name__ == "__main__":
    """
    Connect to socket and run gui
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
    app = QtGui.QApplication(sys.argv)
    qb = ClientWindow(socket = s)
    qb.show()
    sys.exit(app.exec_())