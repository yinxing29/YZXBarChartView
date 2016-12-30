//
//  YZXBarChartViewv.m
//  YZXBarChartView
//
//  Created by 尹星 on 2016/12/23.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXBarChartView.h"

//原点坐标
#define origin_x 30.0
#define origin_y self.bounds.size.height - 30.0

//X轴终点坐标x,y
#define X_X self.bounds.size.width - 20.0
#define X_Y origin_y
//X轴最后一个刻度距X轴箭头距离
#define X_MAX 30.0

//Y轴终点坐标x
#define Y_X origin_x
//#define Y_Y 30.0

@interface YZXBarChartView ()

@property (nonatomic, assign) BOOL                    fontFlag;

@end

@implementation YZXBarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.coordinateColor = [UIColor blackColor];

        self.maxScaleValue = 100.0;
        self.calibrationIntervalValue = 10.0;
        
        self.annotationTitleFont = 10.0;
        self.coordinateContentFont = 10.0;
        self.fontFlag = NO;
    }
    return self;
}
//Y轴终点坐标y
static CGFloat Y_Y = 30.0;

- (void)drawRect:(CGRect)rect {
    if (self.titleArr.count != self.contentArr.count) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"所传入数据数量不同，无法对应" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
        return;
    }
    
    //传入颜色数量小于内容数量时添加随机颜色
    if (self.colorArr.count < self.titleArr.count) {
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObjectsFromArray:self.colorArr];
        for (int i = 0; i<self.titleArr.count; i++) {
            [colors addObject:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1]];
            if (colors.count == self.titleArr.count) {
                self.colorArr = colors;
                break;
            }
        }
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置title字体大小
    UIFont *font = [UIFont systemFontOfSize:self.annotationTitleFont];
    __block NSDictionary *arrts = @{NSFontAttributeName:font};
    __block CGRect annotationRect = CGRectZero;
    __block CGRect annotationTitleRect = CGRectZero;
    //计算一列放多少个annotation
    __block NSInteger number = self.titleArr.count % 2 == 0?self.titleArr.count / 2:self.titleArr.count / 2 + 1;
    if (self.titleArr.count >= 5) {
        number = 3;
    }
    //计算annotation高度(及title文本的高度)
    __block CGFloat annotationHeight = [self.titleArr[0] boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size.height;
    __weak typeof(self) weak_self = self;
    
    __block UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, number * (annotationHeight + 5) + 5)];
    if (!weak_self.hideAnnotation) {
        [self addSubview:scrollView];
    }
    //添加注释
    [self.titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!weak_self.hideAnnotation) {
            //设置scrollview的contextSize
            CGFloat contentSizeWidth = weak_self.titleArr.count % number == 0?weak_self.titleArr.count / number:weak_self.titleArr.count / number + 1;
            scrollView.contentSize = CGSizeMake((weak_self.bounds.size.width / 2.0) * contentSizeWidth, 0);
            //计算坐标Y轴终点的y
            Y_Y = scrollView.bounds.size.height + 15.0;
            annotationRect = CGRectMake(5 + (weak_self.bounds.size.width / 2.0) * (idx / number), 5 + ((idx % number) * (5 + annotationHeight)), annotationHeight, annotationHeight);
            annotationTitleRect = CGRectMake(5 + CGRectGetMaxX(annotationRect), 5 + ((idx % number) * (5 + annotationHeight)), weak_self.bounds.size.width / 2.0 - annotationHeight -  10.0, annotationHeight);
            NSLog(@"%@",NSStringFromCGRect(annotationRect));
            //添加注释
            UIView *view = [[UIView alloc] initWithFrame:annotationRect];
            view.backgroundColor = weak_self.colorArr[idx];
            [scrollView addSubview:view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:annotationTitleRect];
            label.font = font;
            label.textColor = weak_self.coordinateColor;
            label.text = obj;
            [scrollView addSubview:label];
        }else {
            Y_Y = 20.0;
        }
    }];

    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    //坐标原点
    CGContextMoveToPoint(context, origin_x, origin_y);
    //X轴
    CGContextAddLineToPoint(context, X_X, X_Y);
    //添加X轴
    CGContextDrawPath(context, kCGPathStroke);
    //画X轴箭头
    CGContextSetFillColorWithColor(context, self.coordinateColor.CGColor);
    CGPoint points[3];
    points[0] = CGPointMake(X_X, origin_y + 3.0);
    points[1] = CGPointMake(X_X + 6.0, X_Y);
    points[2] = CGPointMake(X_X, origin_y - 3.0);
    CGContextAddLines(context, points, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    //坐标原点
    CGContextMoveToPoint(context, origin_x, origin_y);
    //Y轴
    CGContextAddLineToPoint(context, Y_X, Y_Y);
    //添加Y轴
    CGContextDrawPath(context, kCGPathStroke);
    //画Y轴箭头
    CGContextSetFillColorWithColor(context, self.coordinateColor.CGColor);
    CGPoint YPoints[3];
    YPoints[0] = CGPointMake(origin_x, Y_Y - 6.0);
    YPoints[1] = CGPointMake(origin_x - 3.0, Y_Y);
    YPoints[2] = CGPointMake(origin_x + 3.0, Y_Y);
    CGContextAddLines(context, YPoints, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    /**
     添加X轴刻度
     */
    //计算X轴相邻两刻度之间的距离
    CGFloat scale_x = (X_X - X_MAX - origin_x) / (float)self.titleArr.count;
    if (self.titleArr.count <= 3) {
        scale_x = (X_X - X_MAX - origin_x) / (float)(self.titleArr.count + 1);
    }
    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    for (int i = 1; i<=self.titleArr.count; i++) {
        CGContextMoveToPoint(context, scale_x * i + origin_x, origin_y);
        CGContextAddLineToPoint(context, scale_x * i + origin_x, origin_y - 3.0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    //添加Y轴大刻度
    NSInteger scaleNumber = self.maxScaleValue / self.calibrationIntervalValue;
    //两个刻度之间的距离
    CGFloat scale_y = (origin_y - Y_Y - 10.0) / (float)scaleNumber;
    CGContextSetStrokeColorWithColor(context, self.coordinateColor.CGColor);
    for (int i = 1; i<=scaleNumber; i++) {
        CGContextMoveToPoint(context, origin_x, origin_y - scale_y * i);
        CGContextAddLineToPoint(context, origin_x + 3.0, origin_y - scale_y * i);
        CGContextDrawPath(context, kCGPathStroke);
        
        NSString *scaleValue = [NSString stringWithFormat:@"%.0f",self.calibrationIntervalValue * i];
        if (self.calibrationIntervalValue * i >= 10000.0) {
            scaleValue = [NSString stringWithFormat:@"%.0f万",self.calibrationIntervalValue * i / 10000.0];
        }
        CGSize scaleValueSize = [scaleValue boundingRectWithSize:CGSizeMake(origin_x, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
        NSLog(@"%@",NSStringFromCGSize(scaleValueSize));
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentRight;
        //画刻度
        [scaleValue drawInRect:CGRectMake(0, origin_y - scale_y * i - scaleValueSize.height / 2.0, origin_x, scaleValueSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.coordinateColor,NSParagraphStyleAttributeName:paragraph}];
    }
    
    //画柱状图(scale_x:X轴相邻两刻度之间的距离)
    //计算柱状图的宽度
    __block CGFloat barWidth = scale_x - scale_x / 3.0;
    __block UIFont *contentFont = [UIFont systemFontOfSize:self.coordinateContentFont];
    __block NSDictionary *contentArrts = @{NSFontAttributeName:contentFont};
    if (barWidth >= X_MAX / 2.0) {
        barWidth = X_MAX - 10.0;
    }
    
    //当柱形图宽度很小时，调整文本大小
    if (barWidth < annotationHeight && !self.fontFlag) {
        //文本的font之间相差2.0时，text的高度相差2.4
        contentFont = [UIFont systemFontOfSize:(self.coordinateContentFont - (int)(barWidth / 2.4))];
        contentArrts = @{NSFontAttributeName:contentFont};
    }
    
    [self.contentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat content_x = scale_x * (idx + 1) + origin_x;
        CGFloat content_scale = [obj floatValue] / (float)weak_self.maxScaleValue;
        CGFloat content_y = origin_y - scale_y * scaleNumber * content_scale;
        CGContextSetFillColorWithColor(context, weak_self.colorArr[idx].CGColor);
        CGContextAddRect(context, CGRectMake(content_x - barWidth / 2.0, content_y - 0.5, barWidth, scale_y * scaleNumber * content_scale));
        CGContextDrawPath(context, kCGPathFill);
        
        //根据font计算一行文本的高度
        CGFloat onelineHeight = [self.titleArr[idx] boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentArrts context:nil].size.height;
        
        CGSize titleSize = [self.titleArr[idx] boundingRectWithSize:CGSizeMake(self.bounds.size.height - (origin_y), onelineHeight * 2) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentArrts context:nil].size;
        
        //添加X轴刻度说明                                                                              (scale_x / 3.0 * 2.0) / 2.0
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(scale_x * (idx + 1) + origin_x - barWidth / 2.0, origin_y + 10.0, self.bounds.size.height - (origin_y), titleSize.height)];
        label.text = self.titleArr[idx];
        label.textColor = self.coordinateColor;
        label.font = contentFont;
        label.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self addSubview:label];
        
        //添加标注
        NSString *scaleValue = obj;
        if ([obj floatValue] >= 10000.0) {
            scaleValue = [NSString stringWithFormat:@"%.2f万",[obj floatValue] / 10000.0];
        }
        CGSize scaleValueSize = [scaleValue boundingRectWithSize:CGSizeMake(weak_self.bounds.size.width, weak_self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentArrts context:nil].size;
        //画内容
        [scaleValue drawInRect:CGRectMake(content_x - scaleValueSize.width / 2.0, content_y - 0.5 - scaleValueSize.height - 2.0, scaleValueSize.width, scaleValueSize.height) withAttributes:@{NSFontAttributeName:contentFont,NSForegroundColorAttributeName:self.coordinateColor}];
    }];
    
    //裁剪超出视图部分
    self.layer.masksToBounds = YES;
}

#pragma mark - setter
- (void)setTitleArr:(NSArray *)titleArr
{
    if (_titleArr != titleArr) {
        _titleArr = titleArr;
    }
    if (!self.colorArr) {
        NSMutableArray *color = [NSMutableArray array];
        //没有传入颜色的时候添加随机颜色
        for (int i = 0; i<self.titleArr.count; i++) {
            //添加随机颜色
            [color addObject:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1]];
        }
        self.colorArr = color;
    }
}

- (void)setContentArr:(NSArray *)contentArr
{
    if (_contentArr != contentArr) {
        _contentArr = contentArr;
    }
}

- (void)setCoordinateColor:(UIColor *)coordinateColor
{
    if (_coordinateColor != coordinateColor) {
        _coordinateColor = coordinateColor;
    }
}

- (void)setColorArr:(NSArray *)colorArr
{
    if (_colorArr != colorArr) {
        _colorArr = colorArr;
    }
}

- (void)setMaxScaleValue:(CGFloat)maxScaleValue
{
    if (_maxScaleValue != maxScaleValue) {
        _maxScaleValue = maxScaleValue;
    }
}

- (void)setCalibrationIntervalValue:(CGFloat)calibrationIntervalValue
{
    if (_calibrationIntervalValue != calibrationIntervalValue) {
        _calibrationIntervalValue = calibrationIntervalValue;
    }
}

- (void)setHideAnnotation:(BOOL)hideAnnotation
{
    if (_hideAnnotation != hideAnnotation) {
        _hideAnnotation = hideAnnotation;
    }
}

- (void)setAnnotationTitleFont:(CGFloat)annotationTitleFont
{
    if (_annotationTitleFont != annotationTitleFont) {
        _annotationTitleFont = annotationTitleFont;
    }
}

- (void)setCoordinateContentFont:(CGFloat)coordinateContentFont
{
    if (_coordinateContentFont != coordinateContentFont) {
        _coordinateContentFont = coordinateContentFont;
    }
    self.fontFlag = YES;
}

@end
