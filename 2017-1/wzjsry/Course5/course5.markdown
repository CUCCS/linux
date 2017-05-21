##Web服务器实验

>**1.基础环境**

* 系统：ubuntu-16.04.2-server-amd64
* 基本软件环境：nginx-1.10  mysql—5.7.18 php-7.0 ![](images/jiben.PNG)  ![](images/jiben2.PNG)   

>**2.服务器网络： 双网卡**
 

* network模式网卡 --ip:10.0.2.15 -- 用于连接外部网络进行下载
* hostonly模式网卡 --ip:192.168.42.3--用于主机与虚拟机通信

>**3.verynginx安装配置**

* 1.先安装如下几个包
* 
![](images/verynginx1.PNG) 
* 2.按照说明，使用git clone 命令下载包，再输入 pathon install.py install 安装

* 如果步骤一二颠倒，会提示gmake错误。

* verynginx基本操作指令
![](images/verynginx3.PNG)  

* verynginx网站基本配置目录位于/opt/verynginx/openresty/nginx/conf/nginx.conf

>**4.nginx和verynginx服务**
 

* nginx开启双server 分别监听233 2333（wordpress） 和333 3333（dvwa）端口
* root目录分别设置位/var/www/html/wordpress 和/var/www/html/DVWA
* 分别位wordpress和DVWA站点

* 后期verynginx 监听80 443端口，通过配置verynginx反向代理，将对wp.sec.cuc.edu.cn的访问指向233和2333（https）端口，将对dvwa.sec.cuc.edu.cn的访问指向333和3333端口
* nginx网站配置目录位于/etc/nginx/site-available/default
* nginx配置php，mysql参考文档：https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04

* 如果配置时监听了相同端口会报错，某一服务将无法运行
* 为了实现网址访问，需要修改主机hosts文件

* 配置ssl参考文档：https://www.digitalocean.com/community/tutorials/how-to-create-an-ssl-certificate-on-nginx-for-ubuntu-14-04

![](images/vnginx_ssl.PNG)






>**5.安装wordpress**

* 参考文档：https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-lemp-on-ubuntu-16-04  
* 包含了创建mysql数据库，用户，以及wordpress基本配置 
![](images/wordpress_new1.PNG) 

* 此处出现问题
* 1.是网站进行复制或其他操作后会莫名其妙无法访问，会提示access denied，经过分析应该是权限问题
* 解决方法是尽量在网站根目录下直接git clone操作，避免复制等操作。或是通过chusr www-data 文件目录 来赋予权限。
* 2.浏览器访问网站会有缓存，导致一些更新的配置无法看到效果，解决方法是经常清理缓存，或是开启开发者窗口，在设置里关闭缓存。


>**6.安装DVWA**

* 下载：sudo 模式下 git clone https://github.com/ethicalhack3r/DVWA.git
* 更改配置文件名称，在里边配置数据库
* 参考官方安装配置视频：https://www.youtube.com/watch?v=5BG6iq_AUvM
![](images/dvwa.PNG)   

###实验部分

>**1.配置反向代理**
* 之前部分已经提到nginx和verynginx端口部分的配置，下面是verynginx控制面板里的设置
![](images/vn_fanxiang.PNG)   
* 网址访问通过配置反向代理，修改本机hosts文件，可以实现，效果在安装wordpress和dvwa途中有显示


>**2.禁止ip访问网站**
* 1.禁止以ip方式访问网站
* 2.dvwa禁止非白名单ip访问网站
* 3.verynginx禁止非白名单ip访问管理页面
* 下图分别为2，1，3的reponse设置
![](images/ip_deny_response.PNG)   
* 下图分别位1，2，3的filter设置
![](images/ip_deny_filter.PNG) 
![](images/ip_deny_vn.PNG) 
* 下图分别为1,2,3matcher设置
![](images/ip_deny_m.PNG) 
![](images/ip_deny_m2.PNG) 
* 下图为效果
![](images/ip_deny.PNG) 
![](images/ip_deny2.PNG) 
![](images/dvwa_ip_deny.PNG)
![](images/vn_ip_deny2.PNG)  
* 下图为一些配置过程
![](images/deny_ip.PNG) 
* 下图为变更主机ip用来测试
![](images/dvwa_ip_deny2.PNG) 

>**3.热修复漏洞**
* 1.思路:，禁用/wp-json/wp/v2/users/路径使漏洞无法实现
![](images/buding.PNG)
![](images/buding2.PNG)  

>**4.禁止curl**
![](images/curl.PNG)

>**5.限制访问速率**
![](images/fre.PNG)
![](images/fre2.PNG)  

>**6.dvwa漏洞注入**
* 实验过程如下，配置规则：
![](images/sql_in1.PNG)
![](images/sql2.PNG)
 ![](images/sql3.PNG)
* 将安全级别设置为低，进入SQL_Injection页
 ![](images/sql4.PNG)
* 找一段注入代码，填入
 ![](images/sql5.PNG)
* 注入被拦截
 ![](images/sql6.PNG)
