//
//  UIImage+Extension.m
//  DribblePullDownAnimate
//
//  Created by Jashion on 2017/9/10.
//  Copyright © 2017年 BMu. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor: (UIColor *)color size: (CGSize)size{
    UIImage *image;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
