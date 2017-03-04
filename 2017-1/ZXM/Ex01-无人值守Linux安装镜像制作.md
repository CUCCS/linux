## 无人值守Linux安装镜像制作  
### 实验目的与要求  
+ 如何配置无人值守安装iso并在Virtualbox中完成自动化安装。  
+ Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？  
+ 如何使用sftp在虚拟机和宿主机之间传输文件？  

### 实验准备
+ 实验环境及工具：
	+ Ubuntu 16.04 Server 64bit   
	+ VirtualBox  
	+ PuTTY  
	+ PSFTP  

### 实验过程
+ 配置网卡
	+ 使用dhcp方式配置网卡  
	+ 配置前：  
	![](https://github.com/Hiri3024/Aloha/blob/master/配置前的网卡.png)  
	+ 配置后：  
	![](https://github.com/Hiri3024/Aloha/blob/master/配置后的网卡.png)  
	+ 使用命令
+ 挂载镜像并创建工作目录
	+ mkdir loopdir：  
	在当前用户目录下创建一个用于挂载iso镜像文件的目录  
	+ mount -o loop ubuntu-16.04.1-server-amd64.iso loopdir：  
	挂载iso镜像文件到该目录  
	+ mkdir cd：  
	创建一个工作目录用于克隆光盘内容
	+ rsync -av loopdir/ cd：  
	同步光盘内容到目标工作目录  
	+ umount loopdir：  
	卸载iso镜像
+ 编辑Ubuntu安装引导界面增加一个新菜单项入口  
	+ 编辑并强制保存文件txt.cfg  
	![](https://github.com/Hiri3024/Aloha/blob/master/QQ图片20170304112603.png)
	+ 文件内容：  
	> label autoinstall  
	menu label ^Auto Install Ubuntu Server  
	kernel /install/vmlinuz  
	append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet  
	+ 在安装界面多出一个Auto Install Ubuntu Server选项  
+ 将定制好的seed文件移入虚拟机的cd/preseed文件夹中
	+ 使用PSFTP将宿主机中定制好的ubuntu-server-autoinstall.seed文件移入虚拟机。
	+ 使用命令 put   
	![](https://github.com/Hiri3024/Aloha/blob/master/将seed文件传入虚拟机.png)  
	+ 由于出现错误无法直接将文件移入preseed文件夹，故先直接上传到home/cuc/中，再使用PuTTY将文件移入preseed中（下图第三行）。
+ 重新生成md5sum.txt文件
	+ 在重新生成md5sum文件过程中，出现了权限不够的问题，使用命令 sudo chmod 777 md5sum.txt 对文件进行提权。  
	![](https://github.com/Hiri3024/Aloha/blob/master/重新生成md5sum（提权）.png)  
+ 封闭改动后的目录到.iso
	+ 由于用户权限不够，且封闭改动后的目录时无法直接使用sudo，所以先将命令写入test.sh，再以sudo方式运行test.sh已达到目的。
	+ sudo bash test.sh时报错，由于没有安装mkisofs，需要先get-apt install mkisofs 安装mkisofs。  
	![](https://github.com/Hiri3024/Aloha/blob/master/封闭改动后的目录到iso.png)  
	+ 安装好mkisofs后，再sudo bash test.sh时便可成功的封闭目录到custom.iso。  
	![](https://github.com/Hiri3024/Aloha/blob/master/bash-txt.png)
+ 将生成的镜像custom.iso由虚拟机导入宿主机
	+ 由于生成的.iso文件存在于虚拟机中，所以要将其导出到宿主机。
	+ 使用PSFTP。   
		+ put -上传文件到虚拟机  
		+ get -从虚拟机中下载文件  
	![](https://github.com/Hiri3024/Aloha/blob/master/将虚拟机中的镜像移动到宿主机.png)  
+ 实验安装  
	+ 创建一个新的虚拟机，光盘选择刚导出的custom.iso，实验是否可以无人值守安装。  
	![](https://github.com/Hiri3024/Aloha/blob/master/安装镜像选择配置好的镜像.png)

### 实验结果
+ 由于没有配置isolinux/isolinux.cfg，安装时需手动选择Auto Install Ubuntu Server。  
+ 选择后即可无人值守自动安装。  
	![](https://github.com/Hiri3024/Aloha/blob/master/选择是否自动安装.png)  
+ 开始自动安装。  
	![](https://github.com/Hiri3024/Aloha/blob/master/开始自动安装.png)  
+ 安装完成，进入系统。  
	![](https://github.com/Hiri3024/Aloha/blob/master/安装完成.png)  
