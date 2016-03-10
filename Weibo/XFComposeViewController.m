//
//  XFComposeViewController.m
//  Weibo
//
//  Created by Fay on 15/10/9.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "XFComposeViewController.h"
#import "XFAccountTool.h"
#import "XFAccount.h"
#import "XFTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "XFComposeToolbar.h"
#import "XFComposePhotosView.h"
#import "XFEmotionKeyboard.h"
#import "XFEmotion.h"
#import "XFEmotionTextView.h"


@interface XFComposeViewController ()<UITextViewDelegate,XFComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 输入控件 */
@property (nonatomic, weak) XFEmotionTextView *textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) XFComposeToolbar *toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (nonatomic,weak)XFComposePhotosView *photoView;
/** 表情键盘 */
@property (nonatomic, strong) XFEmotionKeyboard *emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeybaord;


@end

@implementation XFComposeViewController

- (XFEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[XFEmotionKeyboard alloc] init];
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 256;
    }
    return _emotionKeyboard;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏内容
    [self setupNav];
    //设置输入框
    [self setupInput];
    //设置工具条
    [self setupToolbar];
    //添加图片
    [self setupPhotoView];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//设置导航栏内容
-(void)setupNav {
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSString *name = [XFAccountTool account].name;
    NSString *prefix = @"发微博";

    if (name) {

    UILabel *titleView = [[UILabel alloc]init];
    titleView.height = 100;
    titleView.width = 200;
    titleView.numberOfLines = 0;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.y = 50;
        
    NSString *str = [NSString stringWithFormat:@"%@\n%@", prefix, name];
    // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字属性）
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
    titleView.attributedText = attStr;
    self.navigationItem.titleView = titleView;
    }else{
        self.title = prefix;
    }
    
    
}

//添加工具条
-(void)setupToolbar {

    XFComposeToolbar *toolbar = [[XFComposeToolbar alloc]init];
    toolbar.height = 44;
    toolbar.x = 0;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.width = self.view.width;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;

}


//设置输入框
-(void)setupInput {
    
    XFEmotionTextView *textView = [[XFEmotionTextView alloc]init];
    textView.placeholder = @"分享新鲜事...";
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:textView];
    textView.delegate = self;
    self.textView = textView;
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"EmotionDidSelectNotification" object:nil];
    //键盘删除的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtn) name:@"EmotionDidDeleteNotification" object:nil];
}

//添加相册
-(void)setupPhotoView {
    
    XFComposePhotosView *photoView = [[XFComposePhotosView alloc]init];
    photoView.width = self.view.width;
    photoView.height = 400;
    photoView.y = 130;
    [self.textView addSubview:photoView];
    self.photoView = photoView;
    
}


#pragma mark - 监听方法
/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification
{
    XFEmotion *emotion = notification.userInfo[@"SelectEmotionKey"];
    [self.textView insertEmotion:emotion];
    
}

/**
 *  键盘删除按钮
 */
-(void)deleteBtn {
    
    [self.textView deleteBackward];
    
}


/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            
            self.toolbar.y = self.view.height - self.toolbar.height;
        } else {
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }

    }];
    
}

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - XFComposeToolbarDelegate

-(void)composeToolbar:(XFComposeToolbar *)toolbar didClickButton:(XFComposeToolbarButtonType)buttonType {
    
    
    switch (buttonType) {
        case XFComposeToolbarButtonTypeCamera: // 拍照
            [self openCamera];
            break;
            
        case XFComposeToolbarButtonTypePicture: // 相册
            [self openAlbum];
            break;
            
        case XFComposeToolbarButtonTypeMention: // @
            XFLog(@"--- @");
            break;
            
        case XFComposeToolbarButtonTypeTrend: // #
            XFLog(@"--- #");
            break;
            
        case XFComposeToolbarButtonTypeEmotion: // 表情\键盘
            
            [self switchkeyBoard];
            break;
    }
  
    
}

//切换键盘
-(void)switchkeyBoard {
    
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emotionKeyboard;
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;

    }else {
        self.textView.inputView = nil;
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;

    }
    // 开始切换键盘
    self.switchingKeybaord = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //弹出键盘
        [self.textView becomeFirstResponder];
        
        // 结束切换键盘
        self.switchingKeybaord = NO;
    });
    
    
}

#pragma mark - 其他方法


-(void)openCamera {
    
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    
}

-(void)openAlbum {
    
    
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    
}


- (void)openImagePickerController:(UIImagePickerControllerSourceType)type {
    
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}




#pragma mark - UIImagePickerControllerDelegate
/**
 * 从UIImagePickerController选择完图片后就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //添加图片
    [self.photoView addPhoto:image];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}





-(void)textDidChange {
    
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
    
}


-(void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


/**
 * 发布带有图片的微博
 */
- (void)sendWithImage
{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    /**	pic true binary 微博的配图。*/
    
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage *image = [self.photoView.photos firstObject];
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

/**
 * 发布没有图片的微博
 */
- (void)sendWithNoImage
{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数:
    /**	status true string 要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。*/
    /**	access_token true string*/
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [XFAccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}




//发微博
-(void)send {
   
    if (self.photoView.photos.count) {
        [self sendWithImage];
    }else {
        [self sendWithNoImage];
    }
    
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
