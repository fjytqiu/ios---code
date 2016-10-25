//
//  TYJCarouselVC.h
//  投易家
//
//  Created by q on 16/8/15.
//  Copyright © 2016年 TYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYJCarouselVCDelegate <NSObject>
@optional
- (void)clickCarouselWithIndex:(NSInteger)index;
@end

@interface TYJCarouselVC : UIViewController

/*** 轮播图所加的view是控制器的view时 ***/
+ (instancetype)carouselWithFrame:(CGRect)frame  images:(NSArray *)images toController:(UIViewController *)controller;

/**
 *  广告轮播图
 *  1. controller 轮播图加在哪一个view上所在的控制器
 *  2. superView  轮播图加在哪一个view上
 */
/*** 轮播图所加的view不是控制器的view时 ***/
+ (instancetype)carouselWithFrame:(CGRect)frame images:(NSArray *)images toController:(UIViewController *)controller superView:(UIView *)superView;
@property (strong, nonatomic) NSArray *images;

@property (weak, nonatomic) id<TYJCarouselVCDelegate> delegate;

@end
