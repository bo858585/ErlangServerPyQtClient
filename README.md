ErlangServerPyQtClient
======================

0) Install python 2.7:
http://python.org/ftp/python/2.7/Python-2.7.tgz

tar xzf Python-2.7.tgz
cd Python-2.7
./configure
make
sudo make altinstall

1) Install PyQt:

http://problemssol.blogspot.com/2010/12/compile-and-install-pyqt4-for-python27.html

2) Install Erlang:

sudo apt-get install erlang

3) Install lib for communicate between python client and erlang server:

sudo easy_install erlport

http://hlabs.org/development/erlang/ports.html

4) Download

5)Execute:
a) Non gen_server configuration:
In ubuntu terminal cd to dir where files are.
Start server:
erl
c(server).
server:start(port_number).

Start client:
In other terminal cd dir with client pyw file and start it:
python client.pyw port_number
(port_number same as at server)

b) gen_server configuration:
In ubuntu terminal cd to dir where files are.
Start server:
erl
c(socket_server).
c(echo_server).
server:start(port_number).

Start client:
In other terminal cd dir with client pyw file and start it:
python client.pyw port_number
(port_number same as at server)








