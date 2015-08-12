//
//  FMActionSheet.h
//  FollowmeiOS
//
//  Created by Subo on 15/8/6.
//  Copyright (c) 2015年 com.followme. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FMActionSheetDelegate;

@interface FMActionSheet : UIView

/**
 *  遮罩层背景颜色, 默认为blackColor
 */
@property (strong, nonatomic) UIColor *maskBackgroundColor;
/**
 *  遮罩层的alpha值，默认为0.5
 */
@property (nonatomic) CGFloat maskAlpha;

/**
 *  Default: [UIFont systemFontOfSize:20]
 */
@property (strong, nonatomic) UIFont *titleFont;
/**
 *  default: blackColor
 */
@property (strong, nonatomic) UIColor *titleColor;
/**
 *  default: whiteColor
 */
@property (strong, nonatomic) UIColor *titleBackgroundColor;

/**
 *  分割线颜色, default: lightGrayColor
 */
@property (strong, nonatomic) UIColor *lineColor;
/**
 *  按钮高度 默认为49
 */
@property (assign,nonatomic) CGFloat buttonHeight;
/**
 *  标题的高度 默认为49
 */
@property (assign,nonatomic) CGFloat titleHeight;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                            delegate:(id<FMActionSheetDelegate>)delegate;

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
                     delegate:(id<FMActionSheetDelegate>)delegate;

- (void)show;

@end

@protocol FMActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (UIFont *)actionSheet:(FMActionSheet *)actionSheet buttonTextFontAtIndex:(NSInteger)bottonIndex;
- (UIColor *)actionSheet:(FMActionSheet *)actionSheet buttonTextColorAtIndex:(NSInteger)bottonIndex;
- (UIColor *)actionSheet:(FMActionSheet *)actionSheet buttonBackgroundColorAtIndex:(NSInteger)bottonIndex;

@end
