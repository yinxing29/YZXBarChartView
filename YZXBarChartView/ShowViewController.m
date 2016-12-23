//
//  ShowViewController.m
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ShowViewController.h"
#import "YZXBarChartView.h"

@interface ShowViewController ()

@property (nonatomic, strong) YZXBarChartView                    *barChartView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"柱状图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.barChartView];
}

- (YZXBarChartView *)barChartView
{
    if (!_barChartView) {
        _barChartView = [[YZXBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _barChartView.center = self.view.center;
        _barChartView.backgroundColor = [UIColor greenColor];
        _barChartView.contentArr = self.precentageArr;
        _barChartView.titleArr = self.titleArr;
        _barChartView.colorArr = self.colorsArr;
        _barChartView.maxScaleValue = self.maxScaleValue;
        _barChartView.calibrationIntervalValue = self.calibrationIntervalValue;
        _barChartView.hideAnnotation = self.hideAnnotation;
        _barChartView.coordinateColor = self.coordinateColor;
    }
    return _barChartView;
}

@end
