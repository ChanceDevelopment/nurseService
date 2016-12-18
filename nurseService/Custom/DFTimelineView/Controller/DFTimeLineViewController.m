//
//  DFTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTimeLineViewController.h"
#import "DFLineCellAdapterManager.h"

#import "DFTextImageLineCellAdapter.h"
#import "DFBaseLineCell.h"
#import "DFLineLikeItem.h"
#import "DFLineCommentItem.h"
#import "DFActivityLineCellAdapter.h"
#import "DFActivityDetailLineCellAdapter.h"
#import "DFActivityCollectCellAdapter.h"
#import "DFUserActivityLineCellAdapter.h"
#import "DFUserActivityDetailLineCellAdapter.h"
#import "DFUserNewsActivityDetailLineCellAdapter.h"

#import "CommentInputView.h"
#import "HeCommentInputView.h"

//#import "HeActivityDetailVC.h"
#import "Tool.h"

@interface DFTimeLineViewController ()<DFLineCellDelegate, HeCommentInputViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableDictionary *itemDic;

@property (nonatomic, strong) NSMutableDictionary *commentDic;


@property (strong, nonatomic) HeCommentInputView *commentInputView;


@property (strong, nonatomic) NSString *currentItemId;

@property (assign, nonatomic) BOOL isSelectTableView; //用来区分是touch事件还是select table事件
@end

@implementation DFTimeLineViewController

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _items = [NSMutableArray array];
        
        _itemDic = [NSMutableDictionary dictionary];
        
        _commentDic = [NSMutableDictionary dictionary];
        
        
        
        DFLineCellAdapterManager *manager = [DFLineCellAdapterManager sharedInstance];
        
        DFTextImageLineCellAdapter *textImageCellAdapter = [[DFTextImageLineCellAdapter alloc] init];
        DFActivityLineCellAdapter *activityCellAdapter = [[DFActivityLineCellAdapter alloc] init];
        DFActivityDetailLineCellAdapter *activityDetailCellAdapter = [[DFActivityDetailLineCellAdapter alloc] init];
        DFActivityCollectCellAdapter *activityCollectCellAdapter = [[DFActivityCollectCellAdapter alloc] init];
        
        DFUserActivityLineCellAdapter *useractivityCellAdapter = [[DFUserActivityLineCellAdapter alloc] init];
        
        DFUserActivityDetailLineCellAdapter *useractivityDetailCellAdapter = [[DFUserActivityDetailLineCellAdapter alloc] init];
        
        DFUserNewsActivityDetailLineCellAdapter *userNewsActivityDetailLineCellAdapter =[[DFUserNewsActivityDetailLineCellAdapter alloc] init];
        
        [manager registerAdapter:LineItemTypeTextImage adapter:textImageCellAdapter];
        [manager registerAdapter:LineItemTypeActivity adapter:activityCellAdapter];
        [manager registerAdapter:LineItemTypeActivityDetail adapter:activityDetailCellAdapter];
        [manager registerAdapter:LineItemTypeCollectActivity adapter:activityCollectCellAdapter];
        [manager registerAdapter:LineItemTypeUserActivity adapter:useractivityCellAdapter];
        [manager registerAdapter:LineItemTypeUserActivityDetail adapter:useractivityDetailCellAdapter];
        [manager registerAdapter:LineItemTypeUserNewsActivityDetail adapter:userNewsActivityDetailLineCellAdapter];
        
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    _isSelectTableView = YES;
    [self initCommentInputView];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
//    [_commentInputView addNotify];
//    
//    [_commentInputView addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [_commentInputView removeNotify];
//    
//    [_commentInputView removeObserver];
}


-(void) initCommentInputView
{
    if (_commentInputView == nil) {
        
        _commentInputView = [[HeCommentInputView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
        _commentInputView.hidden = YES;
        _commentInputView.delegate = self;
        [self.view addSubview:_commentInputView];
    }
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//父类重写子类的代理方法
#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFBaseLineItem *item = nil;
    @try {
        item = [_items objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    DFBaseLineCellAdapter *adapter = [self getAdapter:item.itemType];
    return [adapter getCellHeight:item];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"_items = %@, row = %ld",_items,indexPath.row);
    DFBaseLineItem *item = nil;
    @try {
        item = [_items objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    DFBaseLineCellAdapter *adapter = [self getAdapter:item.itemType];
    
    
    
    UITableViewCell *cell = [adapter getCell:tableView];
    
    ((DFBaseLineCell *)cell).delegate = self;
    
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    NSLog(@"%@",item.likesStr);
    [adapter updateCell:cell message:item];
    
    return cell;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击所有cell空白地方 隐藏toolbar
    NSInteger rows =  [tableView numberOfRowsInSection:0];
    for (int row = 0; row < rows; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        DFBaseLineCell *cell  = (DFBaseLineCell *)[tableView cellForRowAtIndexPath:indexPath];
        //如果当前toobar是显示的，如果点击cell任意位置，都是优先隐藏toolbar
        if ([cell isToolBarShow]) {
            [cell hideLikeCommentToolbar];
            return;
        }
        if ([cell isMenuItemShow]) {
            [cell hideEditMenu];
            return;
        }
    }
    
    if (_isSelectTableView) {
        if (_myTableDelegate && [_myTableDelegate respondsToSelector:@selector(didSelectTableAtIndexPath:)]) {
            [_myTableDelegate didSelectTableAtIndexPath:indexPath];
        }
    }
    else{
        _isSelectTableView = YES;
    }
    
}

- (void)delaySelectTableAtIndex:(NSIndexPath *)indexPath
{
    if (_myTableDelegate && [_myTableDelegate respondsToSelector:@selector(didSelectTableAtIndexPath:)]) {
        [_myTableDelegate didSelectTableAtIndexPath:indexPath];
    }
    
}

#pragma mark - Method

-(DFBaseLineCellAdapter *) getAdapter:(LineItemType)itemType
{
    DFLineCellAdapterManager *manager = [DFLineCellAdapterManager sharedInstance];
    return [manager getAdapter:itemType];
}

-(void)addItem:(DFBaseLineItem *)item
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    [self genJoinAttrString:item];
    
    //首先移除
    [self removeItmeWithItemId:item.itemId];
    [_items addObject:item];
    
   
    [_itemDic setObject:item forKey:item.itemId];
    
    [self.tableView reloadData];
}

-(void) addItem:(DFBaseLineItem *) item atIndex:(NSInteger)index
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    [self genJoinAttrString:item];
    
    //首先移除
    [self removeItmeWithItemId:item.itemId];
    [_items insertObject:item atIndex:index];
    
    
    [_itemDic setObject:item forKey:item.itemId];
    
    [self.tableView reloadData];
}

//修改某个item
-(void) modifyItem:(DFBaseLineItem *) item
{
    [self genLikeAttrString:item];
    [self genCommentAttrString:item];
    [self genJoinAttrString:item];
    
    //首先移除
    [self removeItmeWithItemId:item.itemId];
    [_items addObject:item];
    
    
    [_itemDic setObject:item forKey:item.itemId];
}

- (void)removeSingleItemWithItemID:(NSString *)itemID
{
    for (NSInteger index = 0; index < [_items count]; index++) {
        DFBaseLineItem *item = _items[index];
        if ([item.itemId isEqualToString:itemID]) {
            [_items removeObjectAtIndex:index];
            break;
        }
    }
    [_itemDic removeObjectForKey:itemID];
}
//移除某个item，如果itemID为nil，移除全部
- (void)removeItmeWithItemId:(NSString *)itemID
{
    if (itemID == nil) {
        [_items removeAllObjects];
        [_itemDic removeAllObjects];
    }
    else{
        [self removeSingleItemWithItemID:itemID];
    }
}

-(DFBaseLineItem *) getItem:(NSString *) itemId
{
    return [_itemDic objectForKey:itemId];
    
}

-(void)addLikeItem:(DFLineLikeItem *)likeItem itemId:(NSString *)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    if (likeItem == nil) {
        //likeItem为nil的时候是删除操作
        for (DFLineLikeItem *myItem in item.likes) {
            NSString *myItemID = myItem.itemID;
            NSArray *array = [myItemID componentsSeparatedByString:@"/"];
            if ([array count] > 0) {
                myItemID = array[1];
            }
            if ([myItemID isEqualToString:itemId]) {
                [item.likes removeObject:myItem];
                item.isLike = NO;
                break;
            }
        }
    }
    else{
        [item.likes insertObject:likeItem atIndex:0];
        item.isLike = YES;
    }
    

    item.likesStr = nil;
    item.cellHeight = 0;
    
    [self genLikeAttrString:item];
    
    [self.tableView reloadData];
}


-(void)addCommentItem:(DFLineCommentItem *)commentItem itemId:(NSString *)itemId replyCommentId:(NSString *)replyCommentId

{
    DFBaseLineItem *item = [self getItem:itemId];
    [item.comments addObject:commentItem];
    
    if (replyCommentId > 0) {
        DFLineCommentItem *replyCommentItem = [self getCommentItem:replyCommentId];
        commentItem.replyUserId = replyCommentItem.userId;
        commentItem.replyUserNick = replyCommentItem.userNick;
    }
    
    item.cellHeight = 0;
    [self genCommentAttrString:item];
    [self.tableView reloadData];
    
}

- (void)deleteCommentItem:(NSString *)commentID itemId:(NSString *)itemId
{
    DFBaseLineItem *item = [self getItem:itemId];
    for (DFLineCommentItem *commentitem in item.comments) {
        if ([commentitem.commentId isEqualToString:commentID]) {
            [item.comments removeObject:commentitem];
            break;
        }
    }
    
    item.cellHeight = 0;
    [self genCommentAttrString:item];
    [self.tableView reloadData];
}

-(void) addJoinItem:(DFLineJoinItem *) joinItem itemId:(NSString *) itemId
{
    //当joinItem为nil的时候是删除某个参加人
    DFBaseLineItem *item = [self getItem:itemId];
    if (!joinItem) {
        item.isJoin = NO;
        item.attendNum--;
        for (DFLineJoinItem *myItem in item.joins) {
            NSString *myItemID = myItem.joinId;
            NSArray *array = [myItemID componentsSeparatedByString:@"/"];
            if ([array count] > 0) {
                myItemID = array[1];
            }
            if ([myItemID isEqualToString:itemId]) {
                [item.joins removeObject:myItem];
                
                break;
            }
        }
    }
    else{
        [item.joins insertObject:joinItem atIndex:0];
        item.isJoin = YES;
        item.attendNum++;
    }
    
    
    item.joinStr = nil;
    item.cellHeight = 0;
    
    [self genJoinAttrString:item];
    
    [self.tableView reloadData];
}

-(DFLineCommentItem *)getCommentItem:(NSString *)commentId
{
    return [_commentDic objectForKey:commentId];
}





#pragma mark - DFLineCellDelegate

-(void)onComment:(NSString *)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.commentId = @"0";
    
    _commentInputView.hidden = NO;
//    _commentInputView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_commentInputView];
    [_commentInputView setPlaceHolder:@"评论"];
    [_commentInputView show];
}


-(void)onLike:(NSString *)itemId
{
    
}

- (void)onShare:(NSString *)itemId
{

}

-(void)onClickUser:(NSString *)userId
{
    
}


-(void)onClickComment:(NSString *)commentId itemId:(NSString *)itemId
{
    _currentItemId = itemId;
    
    _commentInputView.hidden = NO;
    
    _commentInputView.commentId = commentId;
    
    [_commentInputView show];
    
    DFLineCommentItem *comment = [_commentDic objectForKey:commentId];
    [_commentInputView setPlaceHolder:[NSString stringWithFormat:@"  回复: %@", comment.userNick]];
    
    _isSelectTableView = NO;
    
}



-(void)onCommentCreate:(NSString *)commentId text:(NSString *)text
{
    [self onCommentCreate:commentId text:text itemId:_currentItemId];
}


-(void)onCommentCreate:(NSString *)commentId text:(NSString *)text itemId:(NSString *) itemId
{
    
}





-(void) genLikeAttrString:(DFBaseLineItem *) item
{
    if (item.likes.count == 0) {
        item.likesStr = nil;
    }
    
    if (item.likesStr == nil) {
        NSMutableArray *likes = item.likes;
        NSString *result = @"";
        
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",like.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, like.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<likes.count;i++) {
            DFLineLikeItem *like = [likes objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%lu", (unsigned long)like.userId] range:NSMakeRange(position, like.userNick.length)];
            position += like.userNick.length+2;
        }
        
        item.likesStr = attrStr;
    }
    
}

-(void) genCommentAttrString:(DFBaseLineItem *)item
{
    NSMutableArray *comments = item.comments;
    
    [item.commentStrArray removeAllObjects];
    
    for (int i=0; i<comments.count;i++) {
        DFLineCommentItem *comment = [comments objectAtIndex:i];
        [_commentDic setObject:comment forKey:comment.commentId];
        
        NSString *resultStr;
        if (comment.replyUserId == 0) {
            resultStr = [NSString stringWithFormat:@"%@: %@",comment.userNick, comment.text];
        }else{
            resultStr = [NSString stringWithFormat:@"%@回复%@: %@",comment.userNick, comment.replyUserNick, comment.text];
        }
        
        NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc]initWithString:resultStr];
        if (comment.replyUserId == 0) {
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@", comment.userId] range:NSMakeRange(0, comment.userNick.length)];
        }else{
            NSUInteger localPos = 0;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@", comment.userId] range:NSMakeRange(localPos, comment.userNick.length)];
            localPos += comment.userNick.length + 2;
            [commentStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@", comment.replyUserId] range:NSMakeRange(localPos, comment.replyUserNick.length)];
        }
        
        NSLog(@"ffff: %@", resultStr);
        
        [item.commentStrArray addObject:commentStr];
    }
}

- (void)genJoinAttrString:(DFBaseLineItem *) item
{
    if (item.joins.count == 0) {
        return;
    }
    
    if (item.joinStr == nil) {
        NSMutableArray *joins = item.joins;
        NSString *result = @"";
        
        for (int i=0; i<joins.count;i++) {
            DFLineJoinItem *join = [joins objectAtIndex:i];
            if (i == 0) {
                result = [NSString stringWithFormat:@"%@",join.userNick];
            }else{
                result = [NSString stringWithFormat:@"%@, %@", result, join.userNick];
            }
        }
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:result];
        NSUInteger position = 0;
        for (int i=0; i<joins.count;i++) {
            DFLineJoinItem *join = [joins objectAtIndex:i];
            [attrStr addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@", join.userId] range:NSMakeRange(position, join.userNick.length)];
            position += join.userNick.length + 2;
        }
        
        item.joinStr = attrStr;
    }
    
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com