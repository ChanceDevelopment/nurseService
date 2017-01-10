//
//  NurseReportVC.m
//  nurseService
//
//  Created by 梅阳阳 on 17/1/10.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "NurseReportVC.h"
#import "HeBaseTableViewCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface NurseReportVC ()<UITextFieldDelegate>
{
}
@property(strong,nonatomic)UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property(strong,nonatomic)NSMutableArray *paperArray;

@end

@implementation NurseReportVC
@synthesize myTableView;
@synthesize photoScrollView;
@synthesize paperArray;

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
        label.text = @"护理报告";
        [label sizeToFit];
        self.title = @"护理报告";
        
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
    paperArray = [[NSMutableArray alloc] initWithCapacity:0];

}

- (void)initView
{
    [super initView];
    self.view.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [Tool setExtraCellLineHidden:myTableView];
    
    
    CGFloat scrollX = 5;
    CGFloat scrollY = 5;
    CGFloat scrollW = SCREENWIDTH - 2 * scrollX;
    CGFloat scrollH = 100;
    photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollX, scrollY, scrollW, scrollH)];
    [paperArray addObject:@"123"];
    [self addPhotoScrollView];
}


- (void)addPhotoScrollView
{
    CGFloat imageX = 0;
    CGFloat imageY = 5;
    CGFloat imageH = photoScrollView.frame.size.height - 2 * imageY;
    CGFloat imageW = imageH;
    CGFloat imageDistance = 5;
    NSInteger index = 0;
    for (NSString *url in paperArray) {
        NSString *imageurl = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,url];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"comonDefaultImage"]];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 5.0;
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [photoScrollView addSubview:imageview];
        imageX = imageX + imageW + imageDistance;
        imageview.tag = index + 10000;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanlargeImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        imageview.userInteractionEnabled = YES;
        [imageview addGestureRecognizer:tap];
        index++;
        
    }
    if (imageX > photoScrollView.frame.size.width) {
        photoScrollView.contentSize = CGSizeMake(imageX, 0);
    }
}

- (void)scanlargeImage:(UITapGestureRecognizer *)tap
{
    NSInteger index = 0;
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *url in paperArray) {
        NSString *imageurl = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,url];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:imageurl];
        
        UIImageView *srcImageView = [photoScrollView viewWithTag:index + 10000];
        photo.image = srcImageView.image;
        photo.srcImageView = srcImageView;
        [photos addObject:photo];
        index++;
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 10000;
    browser.photos = photos;
    [browser show];
}

- (void)enlargeImage:(UITapGestureRecognizer *)tap
{
    NSString *zoneCover = [NSString stringWithFormat:@"%@/%@",HYTIMAGEURL,paperArray[0]];
    
    UIImageView *srcImageView = (UIImageView *)tap.view;
    NSMutableArray *photos = [NSMutableArray array];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:zoneCover];
    photo.image = srcImageView.image;
    photo.srcImageView = srcImageView;
    [photos addObject:photo];
    browser.photos = photos;
    [browser show];
}

#pragma mark - TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 4;
            break;
        }
        case 1:
        {
            return 7;
            break;
        }
        case 2:
        {
            return 2;
            break;
        }
        case 3:
        {
            return 2;
            break;
        }
            
        default:
            break;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    static NSString *cellIndentifier = @"OrderFinishedTableViewCell";
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    //    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[dataArr objectAtIndex:row]];
    
    HeBaseTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[HeBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier cellSize:cellSize];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (section) {
        case 0:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (row) {
                case 0:
                {
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.text = @"姓名： zhangsan";
                    nameLabel.font = [UIFont systemFontOfSize:15.0];
                    nameLabel.textColor = [UIColor blackColor];
                    [cell addSubview:nameLabel];
                    break;
                }
                case 1:
                {
                    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    ageLabel.backgroundColor = [UIColor clearColor];
                    ageLabel.text = @"年龄： 22";
                    ageLabel.font = [UIFont systemFontOfSize:15.0];
                    ageLabel.textColor = [UIColor blackColor];
                    [cell addSubview:ageLabel];
            
                    break;
                }
                case 2:
                {
                    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    sexLabel.backgroundColor = [UIColor clearColor];
                    sexLabel.text = @"性别： 男";
                    sexLabel.font = [UIFont systemFontOfSize:15.0];
                    sexLabel.textColor = [UIColor blackColor];
                    [cell addSubview:sexLabel];
            
                    break;
                }
                case 3:
                {
                    UILabel *idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, cellSize.height)];
                    idCardLabel.backgroundColor = [UIColor clearColor];
                    idCardLabel.text = @"身份证号： 412232324433232";
                    idCardLabel.font = [UIFont systemFontOfSize:15.0];
                    idCardLabel.textColor = [UIColor blackColor];
                    [cell addSubview:idCardLabel];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (row) {
                case 0:
                {
                    cell.backgroundColor = APPDEFAULTORANGE;
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"服务信息";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:titleLabel];
                    break;
                }
                case 1:
                {
                    UILabel *nurseItemsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    nurseItemsLabel.backgroundColor = [UIColor clearColor];
                    nurseItemsLabel.text = @"护理项目：\n 新生儿护理套餐123";
                    nurseItemsLabel.numberOfLines = 0;
                    nurseItemsLabel.font = [UIFont systemFontOfSize:15.0];
                    nurseItemsLabel.textColor = [UIColor blackColor];
                    [cell addSubview:nurseItemsLabel];
                    
                    break;
                }
                case 2:
                {
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    timeLabel.backgroundColor = [UIColor clearColor];
                    timeLabel.text = @"护理时间： 09/09";
                    timeLabel.font = [UIFont systemFontOfSize:15.0];
                    timeLabel.textColor = [UIColor blackColor];
                    [cell addSubview:timeLabel];
                    
                    break;
                }
                case 3:
                {
                    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    nickLabel.backgroundColor = [UIColor clearColor];
                    nickLabel.text = @"护士昵称： ttt";
                    nickLabel.font = [UIFont systemFontOfSize:15.0];
                    nickLabel.textColor = [UIColor blackColor];
                    [cell addSubview:nickLabel];
                    
                    break;
                }
                case 4:
                {
                    UILabel *orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    orderIdLabel.backgroundColor = [UIColor clearColor];
                    orderIdLabel.text = @"单号： 2009101111";
                    orderIdLabel.font = [UIFont systemFontOfSize:15.0];
                    orderIdLabel.textColor = [UIColor blackColor];
                    [cell addSubview:orderIdLabel];
                    
                    break;
                }
                case 5:
                {
                    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, cellSize.height)];
                    remarkLabel.backgroundColor = [UIColor clearColor];
                    remarkLabel.text = @"备注： 2009101111";
                    remarkLabel.font = [UIFont systemFontOfSize:15.0];
                    remarkLabel.textColor = [UIColor blackColor];
                    [cell addSubview:remarkLabel];
                    
                    break;
                }
                case 6:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"图片资料";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    titleLabel.textColor = [UIColor blackColor];
                    [cell addSubview:titleLabel];
                    
                    CGRect photoFrame = photoScrollView.frame;
                    photoFrame.origin.y = CGRectGetMaxY(titleLabel.frame);
                    photoScrollView.frame = photoFrame;
                    [cell addSubview:photoScrollView];
                
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2:
        {
            switch (row) {
                case 0:
                {
                    cell.backgroundColor = APPDEFAULTORANGE;
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"护理报告";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:titleLabel];
        
                    break;
                }
                case 1:
                {
                    CGFloat weightLabelY = 0;
                    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, weightLabelY, 80, 44)];
                    weightLabel.backgroundColor = [UIColor clearColor];
                    weightLabel.text = @"出生体重:";
                    weightLabel.textColor = [UIColor blackColor];
                    weightLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:weightLabel];
                    
                    CGFloat weightFieldY = 44;
                    UITextField *weightField = [[UITextField alloc] initWithFrame:CGRectMake(10, weightFieldY, 200, 44)];
                    [cell addSubview:weightField];
                    weightField.delegate = self;
                    weightField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    weightField.backgroundColor = [UIColor clearColor];
                    weightField.layer.borderColor = [UIColor blackColor].CGColor;
                    weightField.layer.borderWidth = 1;
                    weightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    weightField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    weightField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    weightField.clearButtonMode = UITextFieldViewModeWhileEditing;

                    UILabel *weightUnit = [[UILabel alloc] initWithFrame:CGRectMake(210, weightFieldY, 200, 44)];
                    weightUnit.backgroundColor = [UIColor clearColor];
                    weightUnit.text = @"KG";
                    weightUnit.textColor = [UIColor blackColor];
                    weightUnit.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:weightUnit];
                    
                    CGFloat bornDateLabelY = 44+weightFieldY;
                    UILabel *bornDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, bornDateLabelY, 80, 44)];
                    bornDateLabel.backgroundColor = [UIColor clearColor];
                    bornDateLabel.text = @"出生日期:";
                    bornDateLabel.textColor = [UIColor blackColor];
                    bornDateLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:bornDateLabel];

                    CGFloat bornDateFieldY = 44+bornDateLabelY;
                    UITextField *bornDateField = [[UITextField alloc] initWithFrame:CGRectMake(10, bornDateFieldY, 200, 44)];
                    [cell addSubview:bornDateField];
                    bornDateField.delegate = self;
                    bornDateField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    bornDateField.backgroundColor = [UIColor clearColor];
                    bornDateField.layer.borderColor = [UIColor blackColor].CGColor;
                    bornDateField.layer.borderWidth = 1;
                    bornDateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    bornDateField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    bornDateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    bornDateField.clearButtonMode = UITextFieldViewModeWhileEditing;

                    CGFloat tempLabelY = 44+bornDateFieldY;
                    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, tempLabelY, 80, 44)];
                    tempLabel.textColor = [UIColor blackColor];
                    tempLabel.backgroundColor = [UIColor clearColor];
                    tempLabel.text = @"体温:";
                    tempLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:tempLabel];

                    CGFloat tempFieldY = 44+tempLabelY;
                    UITextField *tempDateField = [[UITextField alloc] initWithFrame:CGRectMake(10, tempFieldY, 200, 44)];
                    [cell addSubview:tempDateField];
                    tempDateField.delegate = self;
                    tempDateField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    tempDateField.backgroundColor = [UIColor clearColor];
                    tempDateField.layer.borderColor = [UIColor blackColor].CGColor;
                    tempDateField.layer.borderWidth = 1;
                    tempDateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    tempDateField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    tempDateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    tempDateField.clearButtonMode = UITextFieldViewModeWhileEditing;

                    UILabel *tempUnit = [[UILabel alloc] initWithFrame:CGRectMake(210, tempFieldY, 200, 44)];
                    tempUnit.backgroundColor = [UIColor clearColor];
                    tempUnit.text = @"℃";
                    tempUnit.textColor = [UIColor blackColor];
                    tempUnit.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:tempUnit];
                    
                    CGFloat bornWayY = 44+tempFieldY;
                    UILabel *bornWayL = [[UILabel alloc] initWithFrame:CGRectMake(10, bornWayY, 80, 44)];
                    bornWayL.textColor = [UIColor blackColor];
                    bornWayL.backgroundColor = [UIColor clearColor];
                    bornWayL.text = @"出生方式:";
                    bornWayL.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:bornWayL];
                    
                    

                    CGFloat shitLabelY = 44*7;
                    
                    UILabel *shitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, shitLabelY, 80, 44)];
                    shitLabel.backgroundColor = [UIColor clearColor];
                    shitLabel.text = @"大便次数:";
                    shitLabel.textColor = [UIColor blackColor];
                    shitLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:shitLabel];
                    
                    CGFloat shitFieldY = 44+shitLabelY;
                    UITextField *shitField = [[UITextField alloc] initWithFrame:CGRectMake(10, shitFieldY, 200, 44)];
                    [cell addSubview:shitField];
                    shitField.delegate = self;
                    shitField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    shitField.backgroundColor = [UIColor clearColor];
                    shitField.layer.borderColor = [UIColor blackColor].CGColor;
                    shitField.layer.borderWidth = 1;
                    shitField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    shitField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    
                    CGFloat shitColorLabelY = 44+shitFieldY;
                    UILabel *shitColorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, shitColorLabelY, 80, 44)];
                    shitColorLabel.backgroundColor = [UIColor clearColor];
                    shitColorLabel.text = @"大便颜色:";
                    shitColorLabel.textColor = [UIColor blackColor];
                    shitColorLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:shitColorLabel];
                    
                    CGFloat shitColorFieldY = 44+shitColorLabelY;
                    UITextField *shitColorField = [[UITextField alloc] initWithFrame:CGRectMake(10, shitColorFieldY, 200, 44)];
                    [cell addSubview:shitColorField];
                    shitColorField.delegate = self;
                    shitColorField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    shitColorField.backgroundColor = [UIColor clearColor];
                    shitColorField.layer.borderColor = [UIColor blackColor].CGColor;
                    shitColorField.layer.borderWidth = 1;
                    shitColorField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitColorField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    shitColorField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitColorField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    
                    CGFloat shitShapeY = 44+shitColorFieldY;
                    UILabel *shitShapeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, shitShapeY, 80, 44)];
                    shitShapeLabel.textColor = [UIColor blackColor];
                    shitShapeLabel.backgroundColor = [UIColor clearColor];
                    shitShapeLabel.text = @"大便形状:";
                    shitShapeLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:shitShapeLabel];
                    
                    CGFloat shitShapeFieldY = 44+shitShapeY;
                    UITextField *shitShapeField = [[UITextField alloc] initWithFrame:CGRectMake(10, shitShapeFieldY, 200, 44)];
                    [cell addSubview:shitShapeField];
                    shitShapeField.delegate = self;
                    shitShapeField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    shitShapeField.backgroundColor = [UIColor clearColor];
                    shitShapeField.layer.borderColor = [UIColor blackColor].CGColor;
                    shitShapeField.layer.borderWidth = 1;
                    shitShapeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitShapeField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    shitShapeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    shitShapeField.clearButtonMode = UITextFieldViewModeWhileEditing;

                    CGFloat cryLabelY = 44+shitShapeFieldY;
                    UILabel *cryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, cryLabelY, 80, 44)];
                    cryLabel.textColor = [UIColor blackColor];
                    cryLabel.backgroundColor = [UIColor clearColor];
                    cryLabel.text = @"哭声:";
                    cryLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:cryLabel];
                    
                    CGFloat cryFieldY = 44+cryLabelY;
                    UITextField *cryField = [[UITextField alloc] initWithFrame:CGRectMake(10, cryFieldY, 200, 44)];
                    [cell addSubview:cryField];
                    cryField.delegate = self;
                    cryField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    cryField.backgroundColor = [UIColor clearColor];
                    cryField.layer.borderColor = [UIColor blackColor].CGColor;
                    cryField.layer.borderWidth = 1;
                    cryField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    cryField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    cryField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    cryField.clearButtonMode = UITextFieldViewModeWhileEditing;

                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 3:
        {
            switch (row) {
                case 0:
                {
                    cell.backgroundColor = APPDEFAULTORANGE;
                    
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, cellSize.height)];
                    titleLabel.backgroundColor = [UIColor clearColor];
                    titleLabel.text = @"补充记录";
                    titleLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:titleLabel];
                    
                    break;
                }
                case 1:
                {
                    CGFloat addInfoLabelY = 0;
                    UILabel *addInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, addInfoLabelY, 80, 44)];
                    addInfoLabel.backgroundColor = [UIColor clearColor];
                    addInfoLabel.text = @"补充记录:";
                    addInfoLabel.textColor = [UIColor blackColor];
                    addInfoLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:addInfoLabel];
                    
                    
                    CGFloat addInfoFieldY = addInfoLabelY+44;
                    UITextField *addInfoField = [[UITextField alloc] initWithFrame:CGRectMake(10, addInfoFieldY, SCREENWIDTH-20, 150)];
                    [cell addSubview:addInfoField];
                    addInfoField.placeholder  = @"特殊说明";
                    addInfoField.delegate = self;
                    addInfoField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
                    addInfoField.backgroundColor = [UIColor clearColor];
                    addInfoField.layer.borderColor = [UIColor blackColor].CGColor;
                    addInfoField.layer.borderWidth = 1;
                    addInfoField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    addInfoField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    addInfoField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    addInfoField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    
                    CGFloat addInfoTipY = addInfoFieldY+150;
                    UILabel *addInfoTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, addInfoTipY, 200, 44)];
                    addInfoTipLabel.backgroundColor = [UIColor clearColor];
                    addInfoTipLabel.text = @"剩余输入140个字";
                    addInfoTipLabel.textColor = [UIColor blackColor];
                    addInfoTipLabel.font = [UIFont systemFontOfSize:15.0];
                    [cell addSubview:addInfoTipLabel];
                    
                    CGFloat buttonW = 100;
                    CGFloat buttonH = 30;
                    CGFloat buttonX = SCREENWIDTH-220;
                    CGFloat buttonY = addInfoTipY+44;
                    UIButton *strongerBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
                    strongerBtn.backgroundColor = [UIColor clearColor];
                    strongerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                    strongerBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
                    strongerBtn.layer.borderWidth = 1.0f;//设置边框颜色
                    strongerBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
                    [strongerBtn setTitle:@"加强护理" forState:UIControlStateNormal];
                    [strongerBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:strongerBtn];
                    
                    UIButton *serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX+buttonW+10, buttonY, buttonW, buttonH)];
                    serviceBtn.backgroundColor = [UIColor clearColor];
                    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
                    serviceBtn.layer.cornerRadius = 4.0;//2.0是圆角的弧度，根据需求自己更改
                    serviceBtn.layer.borderWidth = 1.0f;//设置边框颜色
                    serviceBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
                    [serviceBtn setTitle:@"建议就诊" forState:UIControlStateNormal];
                    [serviceBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:serviceBtn];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            return 44;
            break;
        }
        case 1:{
            switch (row) {
                case 0:
                    return 40;
                    break;
                case 1:
                    return 60;
                    break;
                case 2:
                    return 44;
                    break;
                case 3:
                    return 44;
                    break;
                case 4:
                    return 44;
                    break;
                case 5:
                    return 44;
                    break;
                case 6:
                    return 44*4;
                    break;
                default:
                    break;
            }
        }
        case 2:{
            switch (row) {
                case 0:
                    return 40;
                    break;
                case 1:
                    return 750;
                    break;
                
                default:
                    break;
            }
        }
        case 3:{
            switch (row) {
                case 0:
                    return 40;
                    break;
                case 1:
                    return 300;
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
    
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = [UIColor colorWithWhite:237.0 /255.0 alpha:1.0];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSLog(@"row = %ld, section = %ld",row,section);
}

#pragma mark textField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
