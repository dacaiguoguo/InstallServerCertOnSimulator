# InstallServerCertOnSimulator
# 一、把测试环境证书添加到模拟器的信任证书列表（动态获取指定域名证书）
### 安装方法 编译即安装到 `/usr/loca/bin`  
### 使用方法  
    1.配置host，例如 192.168.0.229  m.lvmama.com  
    2.`icer 指定host`例如 `icer m.lvmama.com`  
    3.如果需要下载证书 `icer 指定host 指定路径`，  
      例如`icer api3g2.lvmama.com ~/Desktop/lvmama2.cer`



# 二、把测试环境证书添加到模拟器的信任证书列表 (固定内容，m.lvmama.com测试环境的证书)
 
参考的是Charles的安装脚本（/Applications/Charles.app/Contents/Resources/install-charles-ca-cert-for-iphone-simulator.sh）  
## 使用方法
1.复制addCert.sh的内容  
或者  
`curl -o- -fsSL http://192.168.0.96/debugapps/addCert.sh | zsh`
到终端执行  
2.重启模拟器生效  
注意：需要把模拟器设置里的证书删除  

## 三、脚本内容解释

#### 1. for循环找出所有的信任列表数据库
```
for SQLITEDBPATH in ~/Library/Developer/CoreSimulator/Devices/*/data/Library/Keychains/TrustStore.sqlite3
do

```
#### 2. 如果文件存在，则执行SQL语句
```
if [ -f "$SQLITEDBPATH" ]; then
sqlite3 "$SQLITEDBPATH" <<EOF
```

##### 2.1 往tsettings表中插入一条数据
数据前有X，代表为hex的数据表示，即获取相应的数据后需要转化成hex形式

##### 2.2 sha1获取方式如下，获取后把冒号去掉
```
openssl x509 -sha1 -in cert.pem -noout -fingerprint
SHA1 Fingerprint=44:69:2D:2B:43:E2:45:81:97:DE:96:BC:AF:46:30:1F:0D:DC:56:C9
```

##### 2.3 subject获取方式如下，获取后转化成hex格式
```
openssl x509 -sha1 -in cert.pem -noout -subject                                                 
subject= /C=CN/ST=shanghai/L=shanghai/O=lvmama/OU=lvtu/CN=*.lvmama.com/emailAddress=lvtu_deploy@lvmama.com
```

##### 2.4 tset是固定内容

##### 2.5 data获取方式，如果证书是pem格式，需要转化成cer格式，再转化成hex形式



  