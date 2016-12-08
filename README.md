# HHSSJJ
Swift 版上传蒲公英 控制台工具

# 使用步骤

1. 运行程序(可以将build好的程序保存到所需打包的根目录，下次使用会更方便)。
2. cd 到`HHSSJJ`目录 运行 ` ./HHSSJJ -init 工程根目录 ` 可以初始化json。
3. 修改HHSSJJ.json里面的配置。
4. ` ./HHSSJJ -bu 工程根目录 ` 打包并上传到蒲公英。
5. ` ./HHSSJJ -up 工程根目录 ` 第4步上传失败，执行此命令可以重新上传。

# HHSSJJ.json
` { 

 "proPath"  : "当前工程根目录，暂时可以不用写",
 "scheme"   : "scheme 名称",
 "cerName"  : "证书名称",
 "uKey"     : "蒲公英的userkey",
 "_api_key" : "蒲公英的 api_key"
 
} `

# 更多

1. 可以修改上传函数，进行自己服务器的部署。
2. 可以将 `HHSSJJ` 放到 `/usr/bin` 直接调用 `$hhssjj -cmd`
3. 这个Tool还不完善，大家多多提意见。
