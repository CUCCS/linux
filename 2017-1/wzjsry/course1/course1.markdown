##定制ubuntu自动安装iso包

>**1.基础环境安装**

* 使用的是ubuntu-16.04.2-server-amd64.iso系统安装包，作为实验用系统平台。

* 安装系统：
![](images/4.PNG)  
--安装完成后在虚拟机系统设置中将启动方式改为硬盘。

>**2.挂载光盘并将内容复制下来**

* 网上搜索挂载光盘的命令，可以看到光驱目录是/dev/cdrom
* 在虚拟机->设备中挂载.iso文件。然后进行挂载操作。
![](images/挂载.PNG)  
![](images/挂载2.PNG)  
![](images/挂载3.PNG)  
>
>**3.更改配置文件设置**

* 由于需要输入的命令较长，手动输入容易出错，所以用别的方法。

* 将命令复制到txt文件中
![](images/输入.PNG)  

* 方法1.放入u盘内通过挂载u盘方式传入文件

* 方法2.将txt文件制作成iso文件，用之前方法挂载复制下来。
![](images/输入2.PNG)  
![](images/输入3.PNG)  
![](images/输入5.PNG)  
![](images/输入7.PNG)  
![](images/输入8.PNG)  

* 方法3.安装ftp软件，通过host-only模式让宿主机和虚拟机能相互啊访问，然后通过ftp传输文件。
![](images/网卡.PNG)  

* 命令文件传到虚拟机内后按要求进行配置。

* 根据所给的seed示例文件和官网文件进行对照修改，然后生成iso文件。
* 要求的自动获取ip等等设置在.seed文件中进行修改即可做到
![](images/输入9.PNG)  
![](images/输入10.PNG)  
![](images/输入11.PNG)  

>**4.配置ftp服务，传出iso文件**

* 安装vsftpd apt install vsftpd
* 网上查找配置示例，对照进行配置
![](images/ftp.PNG) 
![](images/ftp3.PNG) 
* 之后即可进行文件传送

* 此处出现问题较多，主要有：
* 1.host-only网络模式通过ifconfig -a 发现网卡没有分配ip地址
需要手动设置为与虚拟机host-only网卡相同网段的ip
* 2.vsftp多次出现500oops错误， vsftpd: 500 OOPS: could not bind listening IPv4 socket，上网查询，发现是服务冲突问题
* 配置完成后通过service vsftpd start命令，宿主机无法连接ftp，检查发现21端口并没有打开。
* 解决方法是通过service vsftpd stop停用此服务，直接使用vsftpd命令，打开程序，在宿主机端即可访问。
![](images/ftp2.PNG)  
* 3.ftp需要手动设置访问目录。


>**5.传出生成好的custom.iso文件，进行安装**
![](images/实验.PNG)
![](images/ok.PNG)
* 选择之前设置好的auto install 选项，即可自动开始安装
![](images/ok2.PNG)   