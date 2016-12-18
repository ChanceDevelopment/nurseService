//
//  CommentInputView.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/10.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "HeCommentInputView.h"

#define InputViewPadding 10
#define InputSendButtonWidth 50

#define InputViewObserveKeyPath @"inputViewOffsetY"

#define InputViewHeight 50

#define SendButtonColor [UIColor colorWithRed:255.0 / 255.0 green:174.0 / 255.0 blue:0.0 / 255.0 alpha:1.0]

@interface HeCommentInputView()<UITextFieldDelegate>

@property (strong,nonatomic) UIView *inputView;

@property (strong,nonatomic) UITextField *inputTextView;

@property (strong,nonatomic) UIButton *sendButton;

@property (strong, nonatomic) UIView *maskView;


@property (assign, nonatomic) CGFloat inputViewOffsetY;


@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;


@property (assign, nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (assign, nonatomic) NSUInteger keyboardAnimationCurve;


@end


@implementation HeCommentInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _keyboardAnimationDuration = 0.25;
        _keyboardAnimationCurve = 7;
        
        [self initView];
    }
    return self;
}


- (void)dealloc
{
    [_maskView removeGestureRecognizer:_panGestureRecognizer];
    [_maskView removeGestureRecognizer:_tapGestureRecognizer];
}




-(void) initView
{
    
    CGFloat x, y, width, height;
    
    
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [self addSubview:_maskView];
        _maskView.backgroundColor = [UIColor darkGrayColor];
        _maskView.alpha = 0.4;
//        _maskView.hidden = YES;
    }
    
    
    width = CGRectGetWidth(self.frame);
    height = InputViewHeight;
    x= 0;
    y= SCREENHEIGH - 200;
//    CGRectGetHeight(self.frame)- height;
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _inputView.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    _inputView.hidden = YES;
    _inputView.userInteractionEnabled = YES;
    [self addSubview:_inputView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:237.0 / 255.0 alpha:1.0];
    [_inputView addSubview:line];
    
    
    if (_sendButton == nil) {
        x = CGRectGetWidth(self.frame) - InputSendButtonWidth - InputViewPadding;
        width = InputSendButtonWidth;
        y = InputViewPadding;
        height = InputViewHeight - 2 * InputViewPadding;
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _sendButton.layer.cornerRadius = 5.0;
        _sendButton.clipsToBounds = YES;
        _sendButton.backgroundColor = SendButtonColor;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [_sendButton addTarget:self action:@selector(onInputSendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_sendButton];
    }
    
    if (_inputTextView == nil) {
        
        x = InputViewPadding;
        y = InputViewPadding;
        width = CGRectGetMinX(_sendButton.frame) - 2 * InputViewPadding;
        
        
        _inputTextView = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [_inputView addSubview:_inputTextView];
        
        UIView *nicknameSpaceView = [[UIView alloc]init];
        nicknameSpaceView.frame = CGRectMake(0, 0, 8, height);
        UIImageView *nickSpaceView = [[UIImageView alloc] init];
        nickSpaceView.frame = CGRectMake(0, 0, 10, height);
        [nicknameSpaceView addSubview:nickSpaceView];
        [_inputTextView setLeftView:nicknameSpaceView];
        [_inputTextView setLeftViewMode:UITextFieldViewModeAlways];
        
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.cornerRadius = 5.0;
        _inputTextView.layer.borderColor = [UIColor grayColor].CGColor;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        
        _inputTextView.delegate = self;
    }
    
    
    
    
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
        [_maskView addGestureRecognizer:_panGestureRecognizer];
        _panGestureRecognizer.maximumNumberOfTouches = 1;
        
    }
    
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
        [_maskView addGestureRecognizer:_tapGestureRecognizer];
    }
    
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendComment];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideInputView];
    if (textField.window.isKeyWindow) {
        [textField.window resignKeyWindow];
    }
}

-(void) onTableViewPanAndTap:(UIGestureRecognizer *) gesture
{
    [self hideInputView];
    if (_inputTextView.window.isKeyWindow) {
        [_inputTextView.window resignKeyWindow];
    }
}


-(void) onInputSendButtonClick:(UIButton *) button
{
    
    [self sendComment];
}

-(void) sendComment
{
    [self hideInputView];
    
    NSString *text = _inputTextView.text;
    
    if ([text isEqualToString:@""]) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onCommentCreate:text:)]) {
        [_delegate onCommentCreate:_commentId text:text];
    }
    
    _inputTextView.text = @"";
}


-(void) hideInputView
{
    self.hidden = YES;
    
    [_inputTextView resignFirstResponder];
    _inputTextView.placeholder = @"";
    _inputView.hidden = YES;
}

-(void)show
{
    _inputView.hidden = NO;
    self.hidden = NO;
    [self addSubview:_inputView];
    [self performSelector:@selector(becomeFirst) withObject:nil afterDelay:0.3];
}

- (void)becomeFirst
{
    [_inputTextView becomeFirstResponder];
    
}

-(void)setPlaceHolder:(NSString *)text
{
    _inputTextView.placeholder = text;
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com