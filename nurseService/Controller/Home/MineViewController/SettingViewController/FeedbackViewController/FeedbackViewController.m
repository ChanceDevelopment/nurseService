//
//  FeedbackViewController.m
//  nurseService
//
//  Created by 梅阳阳 on 16/12/25.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "FeedbackViewController.h"
#import "DelMenuItem.h"

@interface FeedbackViewController ()<UITextFieldDelegate,MenuItemDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    NSMutableArray *items;
    NSMutableArray *detailImageArr;
    BOOL isInEditingMode;
    CGFloat imageWide;
    UIView *imageBgView;
}
@property (strong, nonatomic) IBOutlet UITextField *feedbackField;
@end

@implementation FeedbackViewController
@synthesize feedbackField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = APPDEFAULTTITLETEXTFONT;
        label.textColor = APPDEFAULTTITLECOLOR;
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"意见反馈";
        [label sizeToFit];
        self.title = @"意见反馈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initializaiton];
    [self initView];
}

- (void)initializaiton
{
    [super initializaiton];
}

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    
    imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, feedbackField.frame.origin.y+feedbackField.frame.size.height+10, SCREENWIDTH, 200)];
    [self.view addSubview:imageBgView];
    imageBgView.userInteractionEnabled = YES;
    [imageBgView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *imageBgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageButton)];
    imageBgTap.numberOfTapsRequired = 1;
    imageBgTap.numberOfTouchesRequired = 1;
    [imageBgView addGestureRecognizer:imageBgTap];
    
    items = [[NSMutableArray alloc] init];
    [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"reduce.png"] imageurl:@"" movable:NO]];
    [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"add.png"] imageurl:@"" movable:NO]];
    
    detailImageArr = [[NSMutableArray alloc] init];
    [self resetContentView];
    
}

- (void)resetContentView{
    //全部移除
    for (DelMenuItem *item in items) {
        [item removeFromSuperview];
    }
    
    int counter = 0; //计数
    int _x = 5;
    int _y = 5;
    imageWide = SCREENWIDTH/2-55;//(MAINSCREEN_WIDTH-30)/3;
    for (NSInteger i = items.count-1; i < items.count; i--) {
        DelMenuItem *item = [items objectAtIndex:i];
        item.tag = i;
        [item setFrame:CGRectMake(_x+imageWide*(counter%3), _y+(counter/3)*90, imageWide, imageWide)];
        [imageBgView addSubview:item];
        item.delegate = self;
        item.isInEditingMode = NO;
        counter = counter+1;
    }
}


// 编辑模式下,点击空白区域,显示 "+" "-"
- (void)showImageButton{
    if (isInEditingMode) {
        [self disableEditingMode];
        NSArray *tempItem = [NSArray arrayWithArray:items];
        if (items.count > 0) {
            [items removeAllObjects];
        }
        [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"reduce.png"] imageurl:@"" movable:NO]];
        [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"add.png"] imageurl:@"" movable:NO]];
        [items addObjectsFromArray:tempItem];
        
        [self resetContentView];
    }
}

- (void) disableEditingMode {
    // loop thu all the items of the board and disable each's editing mode
    for (DelMenuItem *item in items){
        [item disableEditing];
    }
    isInEditingMode = NO;
    [self resetContentView];
}

- (void)hideImageButton{
    int i = 0;
    do {
        DelMenuItem *menuItem = [items objectAtIndex:0];
        [menuItem removeFromSuperview];
        [items removeObjectAtIndex:0];
        [self resetDelMenuItemTag];
        i ++;
    } while (i == 1);
}

//删除后重新设置tag
- (void)resetDelMenuItemTag{
    //重新设定tag值
    __block int counter = 0; //计数
    for (NSInteger i = items.count-1; i >= 0; i--) {
        
        DelMenuItem *item = [items objectAtIndex:i];
        [UIView animateWithDuration:0.2 animations:^{
            [item updateTag:i];
            [item setFrame:CGRectMake(5+imageWide*(counter%3), 5+(counter/3)*90, imageWide, imageWide)];
            counter = counter + 1;
        }];
    }
}

#pragma mark MenuItemDelegate
//删除指定图片
- (void)removeFromSpringboard:(int)index{
    [detailImageArr removeObjectAtIndex:index];
    
    NSLog(@"dele:%d",index);
    DelMenuItem *menuItem = [items objectAtIndex:index];
    [menuItem removeFromSuperview];
    [items removeObjectAtIndex:index];
    
    //只剩一张时要重新显示出 + -
    if (items.count == 0) {
        [self showImageButton];
    }else{
        [self resetDelMenuItemTag];
    }
}

- (void)launch:(int)index{
    if (index == 0) {
        // -
        if (isInEditingMode || items.count == 2) {
            return;
        }
        //开启编辑模式
        isInEditingMode = YES;
        
        for (DelMenuItem *item in items) {
            [item enableEditing];
        }
        //隐藏 "+" "-"
        [self hideImageButton];
        
    }else if (index == 1){
        // +
        if ([items count] >= 5) {
            [self showHint:@"亲!最多只能上传3张图片"];
            return;
        }
        
        [self openPhotoActionSheet];
    }else{
        return;
    }
}

- (void) enableEditingMode {
    for (DelMenuItem *item in items)
        [item enableEditing];
    isInEditingMode = YES;
}

- (void)openPhotoActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相册",@"来自拍照", nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开本地相册
            [self pickerPhotoLibrary];
            break;
        case 1:  //打开照相机拍照
            [self pickerCamer];
            break;
            
    }
}

#pragma mark -
#pragma mark ImagePicker method
//从相册中打开照片选择画面(图片库)：UIImagePickerControllerSourceTypePhotoLibrary
//启动摄像头打开照片摄影画面(照相机)：UIImagePickerControllerSourceTypeCamera

//按下相机触发事件
-(void)pickerCamer
{
    //照相机类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断属性值是否可用
    if([UIImagePickerController isSourceTypeAvailable:sourceType]){
        //UIImagePickerController是UINavigationController的子类
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        //设置可以编辑
        imagePicker.allowsEditing = YES;
        //设置类型为照相机
        imagePicker.sourceType = sourceType;
        //进入照相机画面
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

//当按下相册按钮时触发事件
-(void)pickerPhotoLibrary
{
    //图片库类型
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *photoAlbumPicker = [[UIImagePickerController alloc] init];
    photoAlbumPicker.delegate = self;
    photoAlbumPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    //设置可以编辑
    photoAlbumPicker.allowsEditing = YES;
    //设置类型
    photoAlbumPicker.sourceType = sourceType;
    //进入图片库画面
    [self presentViewController:photoAlbumPicker animated:YES completion:nil];
}


#pragma mark -
#pragma mark imagePickerController method
//当拍完照或者选取好照片之后所要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage *userImage = [info objectForKey:UIImagePickerControllerEditedImage];
        CGSize sizeImage = userImage.size;
        float a = [self getSize:sizeImage];
        if (a > 0) {
            CGSize size = CGSizeMake(sizeImage.width/a, sizeImage.height/a);
            userImage = [self scaleToSize:userImage size:size];
        }
        
        NSData *data;
        if (UIImagePNGRepresentation(userImage) == nil)
        {
            data = UIImageJPEGRepresentation(userImage, 0.6);
        }
        else
        {
            data = UIImagePNGRepresentation(userImage);
        }
        
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        [items addObject:[DelMenuItem initWithImage:userImage imageurl:@"" movable:YES]];
        [detailImageArr addObject:encodedImageStr];

        
        [self dismissViewControllerAnimated:YES completion:^{
//            [uploadButton setBackgroundImage:userImage forState:UIControlStateNormal];
//            [uploadButton setBackgroundImage:userImage forState:UIControlStateHighlighted];
            [self resetContentView];
        }];
    }
}

-(float)getSize:(CGSize)size
{
    float a = size.width / 480.0;
    if (a > 1) {
        return a;
    }
    else
        return -1;
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


//相应取消动作
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commitAction:(UIButton *)sender {

    if ([feedbackField.text isEqualToString:@""]) {
        [self.view makeToast:@"请输入您的意见" duration:1.2 position:@"center"];
        return;
    }

    NSString *pic = @"";
    for (int i = 0; i < detailImageArr.count; i++) {
        NSString *temp = [NSString stringWithFormat:@"%@",detailImageArr[i]];
        pic = [pic stringByAppendingString:temp];
    }
    if (pic.length > 0) {
        pic = [pic substringFromIndex:1];
    }
    
    NSString *userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:USERIDKEY];
    NSDictionary * params  = @{@"userId" : [NSString stringWithFormat:@"%@",userAccount],
                               @"identity" : @"1",
                               @"content" : feedbackField.text,
                               @"complaintPic" : pic};
    
    NSLog(@"%@",params);
    [self showHudInView:self.view hint:@"提交中..."];
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:@"nurseAnduser/complaintAdd.action" params:params success:^(AFHTTPRequestOperation* operation,id response){
        [self hideHud];
        NSString *respondString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *respondDict = [NSMutableDictionary dictionaryWithDictionary:[respondString objectFromJSONString]];
        if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"200"]) {
            NSLog(@"success");
            [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.2f];
        }else if ([[[respondDict valueForKey:@"errorCode"] stringValue] isEqualToString:@"400"]){
            NSLog(@"faile");
        }
        [self.view makeToast:[NSString stringWithFormat:@"%@",[respondDict valueForKey:@"data"]] duration:1.2 position:@"center"];
    } failure:^(NSError* err){
        NSLog(@"err:%@",err);
        [self hideHud];
        [self.view makeToast:ERRORREQUESTTIP duration:2.0 position:@"center"];
    }];
}

- (void)backToRootView{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
