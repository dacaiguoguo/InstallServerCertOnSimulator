# InstallServerCertOnSimulator
# 安装测试环境的证书到模拟器的辅助工具
# 安装方法 编译即安装到 `/usr/loca/bin`
# 使用方法 `icer 指定host`例如 `icer m.lvmama.com`这时模拟器会跳转到设置里的描述文件安装页面，按照提示操作即可 
# 代码实现步骤
 1.下载证书  
 2.启动模拟器  
 3.模拟器中打开证书  


# addCert.sh 说明
把测试环境证书添加到模拟器的信任证书列表
参考的是Charles的安装脚本（/Applications/Charles.app/Contents/Resources/install-charles-ca-cert-for-iphone-simulator.sh）
## 使用方法
1.复制addCert.sh的内容到终端执行
2.重启模拟器生效
## 脚本内容解释
```
1.for循环找出所有的信任列表数据库
for SQLITEDBPATH in ~/Library/Developer/CoreSimulator/Devices/*/data/Library/Keychains/TrustStore.sqlite3
do
if [ -f "$SQLITEDBPATH" ]; then
2.如果文件存在，则执行SQL语句
sqlite3 "$SQLITEDBPATH" <<EOF
2.1往tsettings表中插入一条数据
数据前有X，代表为hex的数据表示，即获取相应的数据后需要转化成hex形式
sha1获取方式如下，获取后把冒号去掉
openssl x509 -sha1 -in cert.pem -noout -fingerprint
SHA1 Fingerprint=44:69:2D:2B:43:E2:45:81:97:DE:96:BC:AF:46:30:1F:0D:DC:56:C9
subject获取方式如下，获取后转化成hex格式
openssl x509 -sha1 -in cert.pem -noout -subject                                                 
subject= /C=CN/ST=shanghai/L=shanghai/O=lvmama/OU=lvtu/CN=*.lvmama.com/emailAddress=lvtu_deploy@lvmama.com
tset是固定内容
data获取方式，如果证书是pem格式，需要转化成cer格式，再转化成hex形式
INSERT INTO "tsettings" VALUES(X'sha1',X'subject',X'tset',X'data');
EOF
fi
done
3.重复执行会提示
Error: near line 1: UNIQUE constraint failed: tsettings.sha1
说明tsettings表sha1是不能重复的
```


  