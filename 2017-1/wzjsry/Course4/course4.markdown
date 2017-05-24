##SHELL脚本编程

>**基础环境**

* 系统：ubuntu-16.04.2-server-amd64
* 基本软件环境：imagemagick

>**实验1**
 

* 基本思路：采用imagemagick 图片处理软件
* 通过while 循环 打开包含图片的源文件，通过case 匹配输入的指令调用不同函数
* 函数内调用imagemagick命令进行图片批处理


* 
* 实验中问题：
* 创建的bash文件运行前可以chmod 777 .sh文件 ，否则会提示权限问题
* $#,$1,等参数在调用的函数里无法直接使用，必须先赋值给全局变量
* 
* 参考文档：
* https://imagemagick.cn/#!convert.md
* http://baige5117.github.io/blog/ImageMagick_bash_script_to_crop_images.html
* 实验结果如下：
* 每次运行会显示帮助信息，输入 -h也可以查看help信息
![](image/1_1.PNG) 
![](image/1_2.PNG) 
![](image/1_3.PNG) 
![](image/1_4.PNG) 
![](image/1_5.PNG) 

* 实验用图片与处理后图片在image文件中


