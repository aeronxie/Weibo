//
//  XFHomeViewController.m
//  Weibo
//
//  Created by Fay on 15/9/13.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFHomeViewController.h"
#import "XFDropdownView.h"
#import "XFTitleMenuViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "XFAccount.h"
#import "XFAccountTool.h"
#import "XFTitleButton.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "XFStatus.h"
#import "XFUser.h"
#import "XFLoadMoreFooter.h"
#import "MJExtension.h"
#import "XFStatusViewCell.h"
#import "XFStatusFrame.h"

@interface XFHomeViewController ()<XFDropdownViewDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *  微博数组（里面放的都是XFStatusFrame模型，一个XFStatusFrame对象就代表一条微博）
 */
@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic,strong) NSMutableArray *refreshArray;
@end

@implementation XFHomeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //[NSThread sleepForTimeInterval:2.0];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = XFColor(211, 211, 211);
    //设置主题
    [self setNavTheme];
    //设置昵称
    [self setupUserInfo];
    //刷新数据
    [self refreshData];
    //上拉刷新,获取更多数据
    [self refreshUpData];
    //获取未读数
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];


}

//懒加载
-(NSMutableArray *)statusFrames {
    
    if (!_statusFrames) {
        _statusFrames  = [NSMutableArray array];
    }
    
    return _statusFrames;
    
}

/**
 *  获得未读数
 */

-(void)setupUnreadCount {
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
   
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XFLog(@"请求失败-%@", error);
    }];

}


//上拉刷新
-(void)refreshUpData{
    
    XFLoadMoreFooter *load = [[XFLoadMoreFooter alloc]init];

    load.hidden = YES;
    self.tableView.tableFooterView = load;
    
}



 //刷新数据
-(void)refreshData {

    UIRefreshControl *refresh = [[UIRefreshControl alloc]init];
    
    [refresh addTarget:self action:@selector(refreshStatus:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refresh];
    
    //进来就开始刷新
    [refresh beginRefreshing];
    
    //一进来就开始加载微博
    [self refreshStatus:refresh];
   
}


/**
 *  将HWStatus模型转为HWStatusFrame模型
 */

-(NSArray *)stausFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *frames = [NSMutableArray array];
    for (XFStatus *status in statuses) {
        XFStatusFrame *f = [[XFStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];

    }
    return frames;
    
}

/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStatus:(UIRefreshControl *)control {
    
    NSString *url = @"https://api.weibo.com/2/statuses/friends_timeline.json";
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // 取出最前面的微博（最新的微博，ID最大的微博）
    XFStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XFStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
               
        // 将 XFStatus数组 转为 XFStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];

        
        NSRange range = NSMakeRange(0, newFrames.count);
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        
        [self.statusFrames insertObjects:newFrames atIndexes:indexSet];

        //刷新表格
        [self.tableView reloadData];
        //结束刷新
        [control endRefreshing];
        //显示微博刷新数
        [self showStatusCount:(int)newStatuses.count];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XFLog(@"请求失败-%@", error);
    }];


}


//显示微博刷新数
-(void)showStatusCount:(int)count {
    
    
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    label.y = 64 - label.height;
    
    
    if (count) {
        
        label.text = [NSString stringWithFormat:@"有%d条微博更新了",count];
    
    }else{
        
        label.text = @"没有新的微博";

    }

    //添加label
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    //出来的动画
    [UIView animateWithDuration:1.0 animations:^{
        
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [label removeFromSuperview];
        }];
        
        
    }];
    
    
    
}



//设置用户昵称
-(void)setupUserInfo {
    
    // https://api.weibo.com/2/users/show.json
    // access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    // uid	false	int64	需要查询的用户ID。
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        NSString *name = responseObject[@"name"];
        [titleButton setTitle:name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = name;
        
        [XFAccountTool saveAccount:account];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XFLog(@"请求失败");
        
    }];
    
}

//设置导航栏

-(void)setNavTheme {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendSearch) image:@"navigationbar_friendsearch"  heighlightImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop"  heighlightImage:@"navigationbar_pop_highlighted"];
    
    // 设置图片和文字
    NSString *name = [XFAccountTool account].name;
    XFTitleButton *homePageBtn = [[XFTitleButton alloc]init];
    [homePageBtn setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [homePageBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = homePageBtn;
    
}



-(void)titleClick:(UIButton *)titleButton{
    
    XFDropdownView *dropMenu = [XFDropdownView menu];
    
    dropMenu.delegate = self;
    
    XFTitleMenuViewController *vc = [[XFTitleMenuViewController alloc]init];
    
    vc.view.height = 200;

   //下拉列表的控制器
    dropMenu.contentController = vc;
    
    //显示
    [dropMenu showFrom:titleButton];

  
}

// 加载更多的微博数据
-(void)loadMoreStatus {
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    XFAccount *account = [XFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    XFStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [XFStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        // 将 HWStatus数组 转为 HWStatusFrame数组
        NSArray *newFrames = [self stausFramesWithStatuses:newStatuses];

        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        XFLog(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];
 
    
}

- (void)friendSearch
{
    NSLog(@"friendSearch");
}

- (void)pop
{
    NSLog(@"pop");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark XFDropdownViewDelegate代理方法
/**
 *  下拉菜单被销毁了
 */
- (void)dropdownMenuDidDismiss:(XFDropdownView *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向下
    titleButton.selected = NO;
}

/**
 *  下拉菜单显示了
 */
- (void)dropdownMenuDidShow:(XFDropdownView *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 让箭头向上
    titleButton.selected = YES;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.statusFrames.count;
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //获得cell
    XFStatusViewCell *cell = [XFStatusViewCell cellWithTableView:tableView];
        
   //给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];

   
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XFStatusFrame *frame = self.statusFrames[indexPath.row];
    
    return frame.cellHeight;
   
}

@end
