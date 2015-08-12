//
//  FMActionSheet.m
//  FollowmeiOS
//
//  Created by Subo on 15/8/6.
//  Copyright (c) 2015年 com.followme. All rights reserved.
//

#import "FMActionSheet.h"

#define DefaultButtonHeight 49
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define DefaultButtonTextFont [UIFont systemFontOfSize:17]
#define DefaultButtonTextColor [UIColor blackColor]
#define DefaultButtonBackgroundColor [UIColor whiteColor]

@interface FMActionSheet ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *lines;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIWindow *actionWindow;
@property (strong, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) id<FMActionSheetDelegate> delegate;
@property (nonatomic) BOOL isShow;

@end


@implementation FMActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)title
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                            delegate:(id<FMActionSheetDelegate>)delegate {
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles cancelButtonTitle:cancelButtonTitle delegate:delegate];
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
                     delegate:(id<FMActionSheetDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont systemFontOfSize:20];
        _titleBackgroundColor = [UIColor whiteColor];
        _titleHeight = DefaultButtonHeight;
        _buttonHeight = DefaultButtonHeight;
        _lineColor = [UIColor lightGrayColor];
        _maskBackgroundColor = [UIColor blackColor];
        _maskAlpha = 0.5;
        
        UIView *maskView = [[UIView alloc] init];
        [maskView setAlpha:0];
        [maskView setUserInteractionEnabled:NO];
        [maskView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [maskView setBackgroundColor:_maskBackgroundColor];
        [self addSubview:maskView];
        _maskView = maskView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [maskView addGestureRecognizer:tap];
        
        UIView *bottomView = [[UIView alloc] init];
        [self addSubview:bottomView];
        _bottomView = bottomView;
        
        if ([title length]) {
            UIImageView *topLine = [[UIImageView alloc] init];
            topLine.backgroundColor = _lineColor;
            [topLine setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1.0f)];
            [bottomView addSubview:topLine];
            [self.lines addObject:topLine];
            
            // 标题
            UILabel *label = [[UILabel alloc] init];
            [label setText:title];
            [label setTextColor:_titleColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setFont:_titleFont];
            [label setBackgroundColor:_titleBackgroundColor];
            [label setFrame:CGRectMake(0, 1, SCREEN_SIZE.width, _titleHeight)];
            [bottomView addSubview:label];
            _titleLabel = label;
        }
        
        CGFloat topY = _titleLabel ? CGRectGetMaxY(_titleLabel.frame) : 0;
        
        if (buttonTitles.count) {
            for (int i = 0; i < buttonTitles.count; i++) {
                UIImageView *line = [[UIImageView alloc] init];
                line.backgroundColor = _lineColor;
                CGFloat lineY = topY + i * (_buttonHeight + 1);
                [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
                [bottomView addSubview:line];
                [self.lines addObject:line];
                
                // 所有按钮
                UIButton *btn = [[UIButton alloc] init];
                [btn setTag:i];
                [btn setTitle:buttonTitles[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                CGFloat btnY = topY + i * (_buttonHeight + 1) + 1;
                [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, _buttonHeight)];
                [bottomView addSubview:btn];
                [self.buttons addObject:btn];
            }
        }
        
        topY = topY + self.buttons.count * (_buttonHeight + 1);
        UIImageView *line = [[UIImageView alloc] init];
        line.backgroundColor = _lineColor;
        [line setFrame:CGRectMake(0, topY, SCREEN_SIZE.width, 1.0f)];
        [bottomView addSubview:line];
        [self.lines addObject:line];
        
        // 取消按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setTag:buttonTitles.count];
        [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnY = topY + 1;
        [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, _buttonHeight)];
        [bottomView addSubview:cancelBtn];
        [self.buttons addObject:cancelBtn];
        _cancelButton = cancelBtn;
        
        CGFloat bottomH = CGRectGetMaxY(cancelBtn.frame);
        [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
        
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.actionWindow addSubview:self];
    }
    
    return self;
}

- (void)show {
    if (self.isShow) {
        return;
    }
    
    _actionWindow.hidden = NO;
    [self prepareUI];
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
    [self setNeedsLayout];
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_maskView setAlpha:_maskAlpha];
                         [_maskView setUserInteractionEnabled:YES];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y -= frame.size.height;
                         [_bottomView setFrame:frame];
                         
                     }
                     completion:nil];
    
    self.isShow = YES;
}

- (void)layoutSubviews {

    if (_titleLabel) {
        UIImageView *topLine = [self.lines objectAtIndex:0];
        [topLine setFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 1)];
        
        [_titleLabel setFrame:CGRectMake(0, 1, SCREEN_SIZE.width, _titleHeight)];
    }
    CGFloat topY = _titleLabel ? CGRectGetMaxY(_titleLabel.frame) : 0;
    for (int index = 0; index < self.buttons.count; index++) {
        int lineIndex = _titleLabel ? index : index + 1;
        UIImageView *line = [self.lines objectAtIndex:lineIndex];
        CGFloat lineY = topY + index * (_buttonHeight + 1);
        [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1)];
        
        UIButton *button = [self.buttons objectAtIndex:index];
        CGFloat buttonY = lineY + 1;
        [button setFrame:CGRectMake(0, buttonY, SCREEN_SIZE.width, _buttonHeight)];
    }
    
    CGFloat bottomH = CGRectGetMaxY(_cancelButton.frame);
    [_bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height - bottomH, SCREEN_SIZE.width, bottomH)];
}

#pragma mark - ......::::::: Private Method :::::::......

- (UIFont *)buttonTextFontAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:buttonTextFontAtIndex:)]) {
        return [self.delegate actionSheet:self buttonTextFontAtIndex:index];
    }
    
    return DefaultButtonTextFont;
}

- (UIColor *)buttonTextColorAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:buttonTextColorAtIndex:)]) {
        return [self.delegate actionSheet:self buttonTextColorAtIndex:index];
    }
    
    return DefaultButtonTextColor;
}

- (UIColor *)buttonBackgroundColorAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:buttonBackgroundColorAtIndex:)]) {
        return [self.delegate actionSheet:self buttonBackgroundColorAtIndex:index];
    }
    
    return DefaultButtonBackgroundColor;
}

- (void)prepareUI {
    _maskView.backgroundColor = self.maskBackgroundColor;
    _titleLabel.font = self.titleFont;
    _titleLabel.textColor = self.titleColor;
    _titleLabel.backgroundColor = self.titleBackgroundColor;
    
    for (UIImageView *line in self.lines) {
        line.backgroundColor = self.lineColor;
    }
    
    for (int index = 0; index < [self.buttons count]; index++) {
        UIButton *button = self.buttons[index];
        [button setBackgroundColor:[self buttonBackgroundColorAtIndex:index]];
        [[button titleLabel] setFont:[self buttonTextFontAtIndex:index]];
        [button setTitleColor:[self buttonTextColorAtIndex:index] forState:UIControlStateNormal];
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [_maskView setAlpha:0];
                         [_maskView setUserInteractionEnabled:NO];
                         
                         CGRect frame = _bottomView.frame;
                         frame.origin.y += frame.size.height;
                         [_bottomView setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                         _actionWindow.hidden = YES;
                         
                         [self removeFromSuperview];
                         self.isShow = NO;
                     }];
}

- (void)didClickBtn:(UIButton *)btn {
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:btn.tag];
    }
}

#pragma mark - ......::::::: Getter and Setter :::::::......

- (UIWindow *)actionWindow {
    if (_actionWindow == nil) {
        
        _actionWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _actionWindow.windowLevel       = UIWindowLevelStatusBar;
        _actionWindow.backgroundColor   = [UIColor clearColor];
        _actionWindow.hidden = NO;
    }
    
    return _actionWindow;
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (NSMutableArray *)lines {
    if (!_lines) {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}

@end
