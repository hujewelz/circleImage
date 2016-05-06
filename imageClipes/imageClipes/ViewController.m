//
//  ViewController.m
//  imageClipes
//
//  Created by mac on 16/2/2.
//  Copyright (c) 2016年 jinhuadiqigan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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

- (IBAction)clipesAction:(id)sender {
    
   self.imageView.image = [self circleImageImage:self.imageView.image size:self.imageView.frame.size radius:200 borderWidth:0 borderColor:nil];
   // self.imageView.image = [self image];
}

- (UIImage *)circleImageImage:(UIImage *)image size:(CGSize)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    // 1.加载原图
   // UIImage *oldImage = image;
    
    // 2.开启上下文
    CGFloat imageW = size.width;// + 3 * borderWidth;
    CGFloat imageH = size.height ;//+ 3 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    
    // 3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat borderRadius = radius + borderWidth > MIN(imageW, imageH) ? MIN(imageW, imageH) : radius + borderWidth;
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageW, imageH) cornerRadius:borderRadius];
    [borderColor setFill];
    CGContextAddPath(ctx, borderPath.CGPath);
    CGContextFillPath(ctx);
    
    
    CGFloat roundW = imageW - 2*borderWidth;
    CGFloat roundH = imageH - 2*borderWidth;
    CGFloat clipRadius = MIN(radius,  MIN(imageH, imageW));
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, roundW, roundH) cornerRadius:clipRadius];
    
    CGContextAddPath(ctx, roundPath.CGPath);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [image drawInRect:CGRectMake(0, 0, imageW, imageH)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cache stringByAppendingPathComponent:@"a.png"];

    
    [imageData writeToFile:path atomically:YES];
    
    return newImage;
}

- (UIImage *)image {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [cache stringByAppendingPathComponent:@"a.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    NSLog(@"path: %@", path);
    return image;
}

@end
