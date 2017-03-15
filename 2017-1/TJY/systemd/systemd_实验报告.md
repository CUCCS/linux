# systemd  
## Systemd 入门教程：命令篇 by 阮一峰的网络日志  
### URL  
* https://asciinema.org/a/csj2ceua54as537s15ykszgw8  
* https://asciinema.org/a/dqrbzvgnmf3zwtfg2um1izrm8  
* https://asciinema.org/a/357w5qnxumqrut0kbohdvr329  
* https://asciinema.org/a/357w5qnxumqrut0kbohdvr329  
* https://asciinema.org/a/arq5l7jidry3b5nhgjssf3a0z  
### 问题  
* 使用$ sudo localectl set-locale LANG=en_GB.utf8  $ sudo localectl set-keymap en_GB修改了本地化语言参数后，会出现以下问题  
![](2.PNG)  
	* 解决方法：  
		sudo localedef -c -f UTF-8 -i en_US en_US.UTF-8  
		export LC_ALL=en_US.UTF-8  

* 几乎每个操作都会说sudo:unable to resolve host cuc但是命令还是可以执行，不知道为什么  

* 这个实验拆分了好几个短视频，因为在录制的过程中，无法上传视频，出现了几次如下情况　　
![](4.PNG)  


## Systemd 入门教程：实战篇 by 阮一峰的网络日志
### URL  
* https://asciinema.org/a/65jerrgrielgpps8m9j4nj7bx  