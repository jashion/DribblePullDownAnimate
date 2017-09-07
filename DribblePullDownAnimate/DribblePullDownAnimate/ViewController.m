//
//  ViewController.m
//  DribblePullDownAnimate
//
//  Created by Jashion on 2017/9/2.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "ViewController.h"

#define RGB(r,g,b,a) [UIColor colorWithRed: r/255.f green: g/255.f blue: b/255.f alpha: a]

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(51, 50, 81, 1.0);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"TIMELINE";
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize: 16], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor: RGB(51, 50, 81, 1.0)];
    
    [self.view addSubview: self.scrollView];
    self.animatedView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    self.animatedView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview: self.animatedView];
}

//五阶贝塞尔曲线
//B(t) = P0 * (1-t)^5 + 5 * P1 * (1-t)^4 * t + 10 * P2 * (1-t)^3 * t^2 + 10 * P3 * (1-t)^2 * t^3 + 5 * P4 * (1-t) * t^4 + P5 * t^5 (t ∈ [0, 1]);
- (CGFloat)bezierXWithT: (CGFloat)t p0: (CGFloat)p0 p1: (CGFloat)p1 p2: (CGFloat)p2 p3: (CGFloat)p3 p4: (CGFloat)p4 p5: (CGFloat)p5 {
    CGFloat x = 0;
    if (t < 0 || t > 1.0) {
        return x;
    }
    x = (p0 * powf((1-t), 5)) + (5 * p1 * powf((1-t), 4) * t) + (10 * p2 * powf((1-t), 3) * powf(t, 2)) + (10 * p3 * powf((1-t), 2) * powf(t, 3)) + (5 * p4 * (1-t) * powf(t, 4)) + p5 * powf(t, 5);
    return x;
}

- (CGFloat)bezierYWithT: (CGFloat)t p0: (CGFloat)p0 p1: (CGFloat)p1 p2: (CGFloat)p2 p3: (CGFloat)p3 p4: (CGFloat)p4 p5: (CGFloat)p5 {
    CGFloat y = 0;
    if (t < 0 || t > 1.0) {
        return y;
    }
    y = (p0 * powf((1-t), 5)) + (5 * p1 * powf((1-t), 4) * t) + (10 * p2 * powf((1-t), 3) * powf(t, 2)) + (10 * p3 * powf((1-t), 2) * powf(t, 3)) + (5 * p4 * (1-t) * powf(t, 4)) + p5 * powf(t, 5);
    return y;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = -(64 + scrollView.contentOffset.y);
    CGFloat offsetX = [scrollView.panGestureRecognizer locationInView: self.scrollView].x;
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat height = CGRectGetHeight(scrollView.frame);
    
    CGPoint p0 = CGPointMake(0, 0);
    CGPoint p1 = CGPointMake(offsetX/2, 0);
    CGPoint p2 = CGPointMake(offsetX/2, offsetY);
    CGPoint p3 = CGPointMake(offsetX+(width-offsetX)/2, offsetY);
    CGPoint p4 = CGPointMake(offsetX+(width-offsetX)/2, 0);
    CGPoint p5 = CGPointMake(width, 0);
    
    CGFloat t = 0; // 0<=t<=1
    NSMutableArray *points = @[].mutableCopy;
    while (t <= 1.0) {
        CGFloat x = [self bezierXWithT: t p0: p0.x p1: p1.x p2: p2.x p3: p3.x p4: p4.x p5: p5.x];
        CGFloat y = [self bezierYWithT: t p0: p0.y p1: p1.y p2: p2.y p3: p3.y p4: p4.y p5: p5.y];
        [points addObject: [NSValue valueWithCGPoint: CGPointMake(x, y)]];
        t += 0.01;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(0, 0)];
    for (NSInteger index = 0; index < points.count; index++) {
        [path addLineToPoint: [points[index] CGPointValue]];
    }
    [path addLineToPoint: CGPointMake(width, 0)];
    [path addLineToPoint: CGPointMake(width, height)];
    [path addLineToPoint: CGPointMake(0, height)];
    [path addLineToPoint: CGPointMake(0, 0)];
    
    self.shapeLayer.path = path.CGPath;
    self.animatedView.layer.mask = self.shapeLayer;
}

#pragma mark - Custome methods
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: self.view.bounds];
        _scrollView.backgroundColor = RGB(121, 124, 161, 1.0);
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    }
    return _shapeLayer;
}

@end
