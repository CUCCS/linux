# 作业四实验报告
***
## 任务一
* 任务描述：
	* 用bash编写一个图片批处理脚本，实现以下功能：
    	* 支持命令行参数方式使用不同功能
    	* 支持对指定目录下所有支持格式的图片文件进行批处理
    	* 支持以下常见图片批处理功能的单独使用或组合使用
        	* 支持对jpeg格式图片进行图片质量压缩
        	* 支持对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
        	* 支持对图片批量添加自定义文本水印
        	* 支持批量重命名（统一添加文件名前缀或后缀，不影响原始文件扩展名）
        	* 支持将png/svg图片统一转换为jpg格式图片
* 实现过程
	* 结构采用调用函数的方式，通过传递参数控制功能实现。
	* 使用到的核心工具
		* Image MagicK(图片处理)
			* convert
			* mogrify
		* file(判断文件类型)
		* rename(文件重命名)
	* 遇到的问题
		* 在bash编程中if后面需要加空格，示例：
			*  if [ a == "b" ];then 正确
			*  if[ a == "b"];then 错误
			*  if [a == "b"];then 错误
		* 在bash脚本命令中引用变量，示例：
			*  ls '${PATH}' ;引用变量$PATH
* 参考链接
	* [imagemagick官方文档](https://www.imagemagick.org/script/command-line-tools.php)
	* [如何使用bash](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)
	* [有关bash传参的示例](http://www.runoob.com/linux/linux-shell-passing-arguments.html)


## 任务二 
* 任务描述
	* 用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
    	* [2014世界杯运动员数据](https://sec.cuc.edu.cn/huangwei/course/LinuxSysAdmin/exp/chap0x04/worldcupplayerinfo.tsv)
    * 统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
    * 统计不同场上位置的球员数量、百分比
    * 名字最长的球员是谁？名字最短的球员是谁？
    * 年龄最大的球员是谁？年龄最小的球员是谁？
* 实现过程
	* 结构采用调用函数的方式，通过传递参数控制功能实现。
	* 核心工具：
		* sed(用于去除无效行)
		* awk(用于对列进行批处理)
	* 遇到的问题
		* 在处理年龄问题时会出现不同运动员年龄相同的情况，因此需要进行两次遍历过程
		* 在遍历球员位置时发现后卫位置的两种表达方式："Défenseur"，"Defender"
		* awk计算百分比时，无法输出float格式，因此选择四舍五入的方式进行计算
			* i=int(pc); print (pc-i<0.5)?i:i+1
* 参考链接
	* [awk官方文档](http://www.grymoire.com/Unix/Awk.html)
	* [awk循环与条件语句](http://xb9he.bokee.com/6569997.html)

## 任务三
* 任务描述
	* 用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务：
    * [Web服务器访问日志](https://sec.cuc.edu.cn/huangwei/course/LinuxSysAdmin/exp/chap0x04/web_log.tsv.7z)
    	* 统计访问来源主机TOP 100和分别对应出现的总次数
    	* 统计访问来源主机TOP 100 IP和分别对应出现的总次数
    	* 统计最频繁被访问的URL TOP 100
    	* 统计不同响应状态码的出现次数和对应百分比
    	* 分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
    	* 给定URL输出TOP 100访问来源主机
* 实现过程
	* 结构采用调用函数的方式，通过传递参数控制功能实现。
	* 核心工具：
		* awk
		* sed
		* sort(用于排序)
		* head(用于输出前X条数据)
	* 遇到的问题
		* 在获取ip时，需要用正则表达式进行过滤，可以使用awk中的正则表达式表示方式进行编程实现。
* 参考链接
	* [awk正则表达式](http://www.cnblogs.com/notlate/p/3894602.html)
