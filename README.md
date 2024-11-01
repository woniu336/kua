
## 项目

原项目: https://github.com/Cp0204/quark-auto-save


## 使用流程

### 1.获取夸克网盘cookie

登录 https://pan.quark.cn/ 按 F12 查找 Cookie

把Cookie写入`quark_config.json`文件

### 2.钉钉通知（可选）

修改`check_movie_links.py`

```
ACCESS_TOKEN = ""
SECRET = ""
```

记得把服务器ip加入到ip段才会收到钉钉通知



### 3.添加夸克网盘分享链接

格式: `文件名@url`

写入`movie_links.txt`文件



### 4.运行脚本

```
cd /你的站点目录
python3 check_movie_links.py quark_config.json movie_links.txt
```



### 5.排除文件

把需要排除的文件写入`.gitignore` 

### 5.定时任务

每小时检测一次

记得修改目录

```
(crontab -l ; echo "0 * * * * cd /www/wwwroot/kua.123.top && python3 check_movie_links.py quark_config.json movie_links.txt >/dev/null 2>&1") | crontab -
```



<br>
