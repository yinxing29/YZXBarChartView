//
//  YZXBarChartViewv.h
//  YZXBarChartView
//
//  Created by 尹星 on 2016/12/23.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXBarChartView : UIView

/**
 标题
 */
@property (nonatomic, strong) NSArray                    *titleArr;

/**
 内容
 */
@property (nonatomic, strong) NSArray                    *contentArr;

//选择性设置
/**
 柱状图颜色
 */
@property (nonatomic, strong) NSArray <UIColor *>        *colorArr;

/**
 坐标颜色
 */
@property (nonatomic, strong) UIColor                    *coordinateColor;

/**
 Y轴最大刻度(默认:100)
 */
@property (nonatomic, assign) CGFloat                    maxScaleValue;

/**
 Y轴刻度间隔值(默认：10)
 */
@property (nonatomic, assign) CGFloat                    calibrationIntervalValue;

/**
 是否隐藏标注
 */
@property (nonatomic, assign) BOOL                       hideAnnotation;

/**
 注释字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    annotationTitleFont;
/**
 坐标系内容字体大小(默认为10.0)
 */
@property (nonatomic, assign) CGFloat                    coordinateContentFont;

@end
