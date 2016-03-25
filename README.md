# 新浪微博 （仿）
---


下载后先请 打开 `XFOAuthController.m`文件，修改以下三个参数，需要自己注册成为新浪的开发者才可以拥有以下三个参数！

	NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"3109390359";
    params[@"client_secret"] = @"f2aef4bdf1e80ba7a9ce7da8a336218b";
    params[@"redirect_uri"] = @"http://www.baidu.com";
    
  以及这个URL的参数
  	
  	NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=3109390359&redirect_uri=http://www.baidu.com"];  


这个项目是之前在学习的时候写的一个高仿微博的App

![](http://7xoijj.com1.z0.glb.clouddn.com/%E5%BE%AE%E5%8D%9A3.gif)
![](http://7xoijj.com1.z0.glb.clouddn.com/wb01.png)

![](http://7xoijj.com1.z0.glb.clouddn.com/wb02.png)
![](http://7xoijj.com1.z0.glb.clouddn.com/wb04.png)

--
#已经完成的功能

* 启动画面
* 微博的登录跟微博内容的显示
* 下拉跟上拉刷新
* 发布微博，（表情，文字，图片的发布）
* 加号的按钮动画

--

#待完善功能
* 发现和我模块

--

#如有什么问题和建议或者相互学习请通过QQ：279698034 联系我