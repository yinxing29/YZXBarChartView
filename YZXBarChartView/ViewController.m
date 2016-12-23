//
//  ViewController.m
//  YZXBarChartView
//
//  Created by 尹星 on 2016/12/21.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "YZXBarChartView.h"

@interface ViewController ()

@property (nonatomic, strong) YZXBarChartView                    *barChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barChartView.contentArr = @[@"12",@"25",@"36",@"68",@"91",@"100",@"12",@"25",@"36",@"68",@"91"];
    self.barChartView.titleArr = @[@"title1",@"title2",@"title3",@"title4",@"title5",@"title6",@"title1",@"title2",@"title3",@"title4",@"title5"];
    self.barChartView.colorArr = @[[UIColor orangeColor],[UIColor redColor],[UIColor grayColor],[UIColor whiteColor],[UIColor blueColor],[UIColor blackColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor brownColor]];
//    self.barChartView.hideAnnotation = YES;
    [self.view addSubview:self.barChartView];
}

- (YZXBarChartView *)barChartView
{
    if (!_barChartView) {
        _barChartView = [[YZXBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
        _barChartView.center = self.view.center;
        _barChartView.backgroundColor = [UIColor greenColor];
    }
    return _barChartView;
}


@end
