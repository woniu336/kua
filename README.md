![Image](https://imgsrc.baidu.com/forum/pic/item/a1ec08fa513d269731c9b97913fbb2fb4316d8f8.jpg)





### 项目

原项目: https://github.com/Cp0204/quark-auto-save

本次项目：[https://github.com/woniu336/kua](https://github.com/woniu336/kua)

关于夸克网盘分享链接失效或者屏蔽问题

你可能有所了解，假设别人分享一个很热门的影视作品，大概率用不了多久，这个分享链接就会什么都没有，而且会出现以下三种情况

1. 热门资源被官方屏蔽分享，你会在网盘看到资源显示`不可分享`，即使链接有效，别人也看不到资源
2. 资源被人为删除或者移动到其他文件夹
3. 取消了分享或者分享链接具有有效期

基于以上情况，我根据原项目修改了一下，主要是方便自己用，如果热门资源被官方屏蔽了分享，注意：只是不能分享了，但是资源还是在网盘里的，你可以下载到电脑上。如果屏蔽了分享或者失效可以收到钉钉通知，然后我会把资源下载到本地，使用转码工具压缩一下再上传，最后分享出去，大概率这条分享链接能活久一点。

另外做了一个**index.html**查看页面，每分钟自动刷新，可以把整个项目文件放在网站根目录下使用

## 流程

### 1.获取夸克网盘cookie

登录 https://pan.quark.cn/ 按 F12 查找 Cookie

把Cookie写入`quark_config.json`文件

### 2.钉钉通知（可选）

修改`check_movie_links.py`

```
ACCESS_TOKEN = ""
SECRET = ""
```





### 3.添加夸克网盘分享链接

格式: `文件名@url`

写入`movie_links.txt`文件



### 4.运行脚本

```
python3 check_movie_links.py quark_config.json movie_links.txt
```



### 5.排除文件

把需要排除的文件写入`.gitignore` 

### 5.定时任务

每5分钟检测

```
(crontab -l ; echo "*/5 * * * * cd /www/wwwroot/你的站点目录 && python3 check_movie_links.py quark_config.json movie_links.txt >/dev/null 2>&1") | crontab -
```

### 6.其他



split_and_merge.sh 转换视频元信息的脚本，目的是躲避官方屏蔽（当你分享热门资源的时候）

使用方法，例如：

```
./split_and_merge.sh old.mp4 new.mp4
```



**old.mp4**为需要转换的资源，**new.mp4**为转换后的资源

<br>
