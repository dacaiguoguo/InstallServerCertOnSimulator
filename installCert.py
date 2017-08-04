#!usr/bin/env python
# -*- coding: utf-8 -*-
#用途：把测试环境某域名下的Https证书下载并用模拟器打开，模拟器回自动调整到设置里的安装描述文件的页面
#前提：1.模拟器需要打开 2.域名需要配置测试环境的host，例如 192.168.0.29 test.com
#用法： python installCert.py test.com
import ssl
import os
import sys
import tempfile


if __name__ == '__main__':
    tempdir = tempfile.gettempdir()
    # print tempdir

    tempfilename =  tempdir + '/' + sys.argv[1] + '.cer'
    fileurlTempFile = '\'file://' + tempfilename + '\''
    # print fileurlTempFile
    cert = ssl.get_server_certificate((sys.argv[1], 443))
    # cert = ssl.get_server_certificate(('baidu.com', 443))
    # print cert
    file_object = open(tempfilename, 'w')
    file_object.write(cert)
    file_object.close()
    # os.system('open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app')
    commandString ='xcrun simctl openurl booted ' + fileurlTempFile
    os.system(commandString)
    print "请到模拟器里点击安装"
    exit(0)


