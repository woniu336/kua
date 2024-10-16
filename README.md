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



### 5.定时任务

每5分钟检测

```
(crontab -l ; echo "*/5 * * * * cd /www/wwwroot/你的站点目录 && python3 check_movie_links.py quark_config.json movie_links.txt >/dev/null 2>&1") | crontab -
```

