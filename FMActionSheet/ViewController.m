//
//  ViewController.m
//  FMActionSheet
//
//  Created by Subo on 15/8/6.
//  Copyright (c) 2015年 Subo. All rights reserved.
//

#import "ViewController.h"
#import "FMActionSheet.h"
#import "UIColor+HexString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    FMActionSheet *sheet = [[FMActionSheet alloc] initWithTitle:@"你确定这样好吗？"
                                                   buttonTitles:[NSArray arrayWithObjects:@"确定", nil]
                                              cancelButtonTitle:@"取消"
                                                       delegate:(id<FMActionSheetDelegate>)self];
    sheet.titleFont = [UIFont systemFontOfSize:20];
    sheet.titleBackgroundColor = [UIColor colorWithHexString:@"f4f5f8"];
    sheet.titleColor = [UIColor colorWithHexString:@"666666"];
    sheet.lineColor = [UIColor colorWithHexString:@"dbdce4"];
    
    [sheet show];
}

#pragma mark - ......::::::: UIActionSheetDelegate :::::::......

- (void)actionSheet:(FMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex:%ld",buttonIndex);
}

- (UIFont *)actionSheet:(FMActionSheet *)actionSheet buttonTextFontAtIndex:(NSInteger)bottonIndex {
    return [UIFont systemFontOfSize:20];
}

- (UIColor *)actionSheet:(FMActionSheet *)actionSheet buttonTextColorAtIndex:(NSInteger)bottonIndex {
    if (bottonIndex == 0) {
        return [UIColor colorWithHexString:@"f74b1f"];
    }
    
    return [UIColor colorWithHexString:@"999999"];
}

- (UIColor *)actionSheet:(FMActionSheet *)actionSheet buttonBackgroundColorAtIndex:(NSInteger)bottonIndex {
    return [UIColor whiteColor];
}

@end
