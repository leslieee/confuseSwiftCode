## 主要功能
- 支持替换ts+方法名
- 支持替换ts+类名
- 支持向swift文件中添加垃圾代码
- 支持生成垃圾swift类
## 使用方法
1. 将confuseSwiftCode和funcname.txt文件放入ts+根目录(release目录下已提供最新版本)
2. funcname.txt文件中可添加需替换方法名或类名(已经添加了经过测试的多个方法名和类名)
3. 双击confuseSwiftCode执行, 等待脚本完成
4. 妥善保存funcnamekeyvalue文件 ( 为生成的对照表文件, 避免下次重复生成, 理论上一个项目生成一次即可, 以后每次上架打包的替换规则根据现有的这个文件来 )
5. 将newproject文件夹拖入项目(垃圾类)
## 运行效果
![](https://qqadapt.qpic.cn/txdocpic/0/4c89403b05ba166f85d56aa7d45508ca/0)
![](https://qqadapt.qpic.cn/txdocpic/0/d28f1ed49587f9351f147f2bc3b3b824/0)
