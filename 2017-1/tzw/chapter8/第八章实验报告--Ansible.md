# 第八章实验报告--ansible技术重构自动配置
## 实验环境
* 虚拟机物理环境
	* Server : Ubuntu-16.04.2-Server
	* Target : Ubuntu-16.04.2-Server
* 网络环境
	* Server
		* NAT
		* Host-Only:192.168.112.10
	* Target
		* NAT
		* Host-Only:192.168.112.20
		* Internal:100.0.0.1
## 实验基本原理
* ansible-galaxy/roles的基本工作路径
	* ![](image/14.PNG)
* 原理简单解读
	* roles父目录中的.yml文件定义了支持自定义修改的配置参数
	* 参数的定义保存在roles/defaults/main.yml中
	* templates/中的文件用于保存原始配置文件的模板以及配置增量相关的代码
	* tasks/中的文件用于处理配置文件的加工以及最终在目标机的所需操作
## 实验步骤
* 在Server上安装ansible

		$ sudo apt-get install software-properties-common
		$ sudo apt-add-repository ppa:ansible/ansible
		$ sudo apt-get update
		$ sudo apt-get install ansible
* 配置Server到Target的root用户的ssh免密登录
	
		$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.112.20
		# 假设B上没有安装过python
		$ sudo apt-get update && sudo apt-get install -y python-minimal
		$ exit
* 在Server上配置本地Ansible本地工作目录，并测试
	
		$ mkdir ansible && cd ansible
		$ echo -e "[web]\n192.168.112.20" > hosts
		$ ansible all -m ping -u root -i hosts
	* ![](image/1.PNG)
* 下载相关配置文件
	* 在[galaxy.ansible.com](https://galaxy.ansible.com/)中搜索相关的roles
	* 确认资源可信后，下载配置文件
		* [vsftpd](https://galaxy.ansible.com/franklinkim/vsftpd/)
		* [NFS](https://galaxy.ansible.com/indigo-dc/nfs/)
		* [DHCP](https://galaxy.ansible.com/debops/dhcpd/)
		* [DNS](https://galaxy.ansible.com/resmo/bind/)
		* [SAMBA](https://galaxy.ansible.com/mrlesmithjr/samba/)

				$ ansible-galaxy install franklinkim.vsftpd -p roles
				$ ansible-galaxy install indigo-dc.nfs -p roles
				$ ansible-galaxy install debops.dhcpd -p roles
				$ ansible-galaxy install resmo.bind -p roles
				$ ansible-galaxy install mrlesmithjr.samba -p roles

* 根据README进行自定义修改配置
	* vsftpd
		* 目标状态：
			* 修改target中文件
				* /etc/hosts.allow
				* /etc/hosts.deny
				* /etc/shells
			* 覆盖/新建target中文件
				* /etc/vsftpd.config
				* /etc/vsftpd.userlist
		* 在roles父目录下新建deploy.yml，根据README以及上次实验的配置文件进行自定义修改如下：
			* ![](image/7.PNG)
			* 该配置定义了vsftpd.conf中的相关配置以及ftp用户的创建
		* 由于需要修改/etc/hosts.allow与/etc/hosts.deny文件，因此可以在roles/franklinkim.vsftpd/tasks/config.yml中添加如下配置语句：
			* ![](image/8.PNG)
			* 该配置原理是通过正则表达式对文件中的内容进行判断，进行无重复地添加自定义内容。
		* 在该文件中也可看到对于其他配置的实现方式
			* ![](image/9.PNG)
			* 对于主配文件vsftpd.conf，通过template文件覆盖的方式进行
			* 对于/etc/shells文件的修改，通过lineinfile的方式进行添加行
		* 覆盖target中/etc/vsftpd.userlist文件
			* 在server中roles/franklinkim.vsftpd/tasks/config.yml中添加如下内容：
				* ![](image/10.PNG)
			* 在server中新建roles/franklinkim.vsftpd/templates/etc-vsftpd.userlist.j2，内容如下：
				* ![](image/11.PNG)
			* 在server中roles/franklinkim.vsftod/default/main.yml中添加有关vsftpd.userlist的定义
				* ![](image/12.PNG)
			* 最终在deploy.yml中增添vsftpd_userlist中的用户
				* ![](image/13.PNG)
		* 检查target：
			* /etc/vsftpd.config
				* ![](image/23.PNG)
			* /etc/vsftpd.userlist
				* ![](image/24.PNG)
			* /etc/hosts.allow
				* ![](image/25.PNG)
			* /etc/hosts.deny
				* ![](image/26.PNG)
	* nfs
		* 目标状态: 
			* 覆盖/新建target中文件
				* /etc/exports
		* 根据README.MD在deploy.yml中进行Role Variables的添加
			* ![](image/2.PNG)
		* 检查target中/etc/exports：
			* ![](image/22.PNG)

	* dhcp
		* 目标状态：
			* 覆盖/新建target中文件
				* /etc/dhcp/dhcpd.conf
				* /etc/default/isc-dhcp-server
		* 根据README.MD在deploy.yml中进行Role Variables的添加
			* ![](image/3.PNG)
		* 检查target：
			* /etc/dhcp/dhcpd.conf
				* ![](image/20.PNG)
				* ![](image/21.PNG)
			* /etc/default/isc-dhcp-server
				* ![](image/27.PNG)
	* Samba
		* 目标状态：
			* 覆盖/新建target中文件
				* /etc/samba/smb.conf
		* 根据README.MD在deploy.yml中进行Role Variables的添加
			* ![](image/4.PNG)
		* 检查target中/etc/samba/smb.conf：
			* ![](image/18.PNG)
			* ![](image/19.PNG)
	* DNS
		* 目标状态：
			* 覆盖/新建target中文件
				* /etc/bind/named.conf.local.master
				* /var/lib/bind/master/db.cuc.edu.cn
		* 根据README.MD在deploy.yml中进行Role Variables的添加
			* ![](image/5.PNG)
			* 注：需要在playbook脚本（deploy.yml）路径下创建自己的master/db.cuc.edu.cn用于远程自动拷贝
		* 检查target：
			* /etc/bind/named.conf.local.master
				* ![](image/6.PNG)
			* /var/lib/bind/master/db.cuc.edu.cn
				* ![](image/17.PNG)
* 对target进行远程安装

		ansible-playbook deploy.yml -i hosts -u root -v
## 附配置文件
* playbook脚本（deploy.yml）：

		---
		
		- hosts: all
		  sudo: yes
		  roles:
		    - franklinkim.vsftpd
		    - indigo-dc.nfs
		    - debops.dhcpd
		    - mrlesmithjr.samba
		    - resmo.bind
		  vars:

		# vsftpd Server
		    vsftpd_service_enabled: yes
		    vsftpd_service_state: started
		    vsftpd_users:
		       - username: 'ftpuser'
		         name: 'FTP User'
		         password: '123'
		    vsftpd_config:
		         local_enable: YES
		         anonymous_enable: YES
		         chroot_local_user: YES
		         write_enable: YES
		
		         user_sub_token: $USER
		         local_root: '/home/$USER/ftp'
		
		         pasv_min_port: '40000'
		         pasv_max_port: '50000'
		
		         userlist_enable: YES
		         userlist_file: '/etc/vsftpd.userlist'
		         userlist_deny: NO
		
		         tcp_wrappers: YES
		
		    vsftpd_userlist:
		         user_1: 'anonymous'
		         user_2: 'ftpuser'

		# NFS Server
		    # NFS install mode: server or client
		    nfs_mode: 'server'
		    # Line to add to the /etc/exports file
		    nfs_exports:
		      - path: "/var/nfs/share_rw"
		        export: "100.0.0.100(rw,sync,no_subtree_check)"
		      - path: "/var/nfs/share_r"
		        export: "100.0.0.100(ro,sync,no_subtree_check)"
		
		# DHCP Server
		    dhcpd_mode: 'server'
		    dhcpd_ipversion: '4'
		    dhcpd_interfaces: ['enp0s9']
		
		    dhcpd_subnets:
		      - subnet: '100.0.0.0'
		        netmask: '255.255.255.0'
		        routers: '100.0.0.100'
		        options: |
		          default-lease-time 600;
		          max-lease-time 7200;
		        pools:
		          - comment: "A pool in a subnet"
		            range: '100.0.0.100 100.0.0.200'
		
		# SAMBA Server
		    # Define samba groups to create
		    samba_groups:
		      - 'sambaGroup'
		    # Define users to create
		    samba_users:
		        # Define user name to create
		      - name: 'sambauser'
		        # Define groups to add user to
		        # ensure samba_groups names exist.
		        groups:
		          - 'sambaGroup'
		        smbpasswd: '123'
		    # Defines root folder for samba shares to be created
		    samba_share_path: '/srv/samba'
		    samba_shares:
		      - name: 'demo'
		        browsable: 'yes'
		
		        group: 'nogroup'
		        read_only: 'no'
		        guest_ok: 'no'
		
		        force_create_mode: '0660'
		        force_directory_mode: '2770'
		        folder_perms: '0770'
		
		        force_user: 'sambauser'
		        force_group: 'sambaGroup'
		
		        writable: 'yes'
		
		# DNS Server
		    bind_masterzones_path: 'masters'
		    bind_config_master_zones:
		      - name: 'cuc.edu.cn'
* roles/franklinkim.vsftpd/templates/etc-vsftpd.userlist.j2
	
		{% for key,value in vsftpd_userlist.iteritems() %}
		{{ value }}
		{% endfor %}
* roles/franklinkim.vsftpd/tasks/config.yml

		---

		- name: Configuring
		  template: >
		    src={{ vsftpd_config_template if vsftpd_config_template else 'etc-vsftpd.conf.j2' }}
		    dest=/etc/vsftpd.conf
		    owner=root
		    group=root
		    mode=0644
		  notify: restart vsftpd
		  tags:
		    - networking
		    - vsftpd
		    - config
		
		- name: Configuring
		  template: >
		    src={{ vsftpd_userlist_template if vsftpd_userlist_template else 'etc-vsftpd.userlist.j2' }}
		    dest=/etc/vsftpd.userlist
		    owner=root
		    group=root
		    mode=0644
		  notify: restart vsftpd
		  tags:
		    - networking
		    - vsftpd
		    - config
		
		- name: Adding nologin shell
		  lineinfile: >
		    state=present
		    dest=/etc/shells
		    line="/usr/sbin/nologin"
		    regexp="^/usr/sbin/nologin"
		    insertafter=EOF
		  tags:
		    - networking
		    - vsftpd
		    - config
		- name: Adding hosts_allow
		  lineinfile: >
		    state=present
		    dest=/etc/hosts.allow
		    line="vsftpd:100.0.0.100"
		    regexp="^vsftpd:100.0.0.100"
		    insertafter=EOF
		  tags:
		    - networking
		    - vsftpd
		    - config
		
		- name: Adding hosts deny
		  lineinfile: >
		    state=present
		    dest=/etc/hosts.deny
		    line="vsftpd:ALL"
		    regexp="^vsftpd:ALL"
		    insertafter=EOF
		  tags:
		    - networking
		    - vsftpd
		    - config

## 参考
* [ansible官方文档](http://docs.ansible.com/ansible/)
* [franklinkim/vsftpd](https://galaxy.ansible.com/franklinkim/vsftpd/)
* [indigo-dc/nfs](https://galaxy.ansible.com/indigo-dc/nfs/)
* [debops/dhcpd](https://galaxy.ansible.com/debops/dhcpd/)
* [resmo/bind](https://galaxy.ansible.com/resmo/bind/)
* [Smrlesmithjr/samba](https://galaxy.ansible.com/mrlesmithjr/samba/)
