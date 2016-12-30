//
//  ShowViewController.h
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController

/**
 标题
 */
@property (nonatomic, strong) NSArray                    *titleArr;

/**
 百分比
 */
@property (nonatomic, strong) NSArray                    *precentageArr;

/**
 设置的颜色
 */
@property (nonatomic, strong) NSArray <UIColor *>        *colorsArr;

/**
 Y轴最大刻度
 */
@property (nonatomic, assign) CGFloat                    maxScaleValue;

/**
 Y轴刻度间隔值
 */
@property (nonatomic, assign) CGFloat                    calibrationIntervalValue;

/**
 是否隐藏注释
 */
@property (nonatomic, assign) BOOL                       hideAnnotation;

/**
 坐标颜色
 */
@property (nonatomic, strong) UIColor                    *coordinateColor;

/**
 注释字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    annotationTitleFont;

/**
 坐标系内容字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    coordinateContentFont;

@end
