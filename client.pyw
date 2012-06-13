#! /usr/bin/env python2.7
#coding=utf-8

HOST = 'localhost'    # The remote host
PORT = 54400          # The same port as used by the server

import socket
import sys
from PyQt4 import QtGui, QtCore
from erlport import Port, Protocol

class ClientWindow(QtGui.QWidget, Protocol):
    """
        Main client window class with tcp protocol
    """

    def __init__(self, parent=None, socket = None):
        QtGui.QWidget.__init__(self, parent)

        self.setGeometry(300, 300, 300, 300)
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
        quit = QtGui.QPushButton('Exit', self)
        quit.setGeometry(100, 200, 60, 35)
        self.connect(quit, QtCore.SIGNAL('clicked()'), QtGui.qApp,  QtCore.SLOT('quit()'))

    def send_text(self):
    """
    Send text to server, receive response, and put it to label
    """
        sen =  self.edit.text()
        self.label.setText(sen)
        s.send(sen)
        rec = s.recv(1024).decode("utf-32")
        self.label.setText(rec)

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
