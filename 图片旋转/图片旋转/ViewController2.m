//
//  ViewController2.m
//  图片旋转
//
//  Created by 罗文琦 on 2017/11/20.
//  Copyright © 2017年 罗文琦. All rights res
//

#import "ViewController2.h"
#import "UIImage+category.h"

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dis:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)rotation:(id)sender {
    //在本例子中,图片的最大高度设置为500,最大宽度为屏幕宽度,当然自己也可以根据自己的需要去调整自己的图片框的大小
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_2);
    if (self.imageView.frame.size.width >= [UIScreen mainScreen].bounds.size.width) { //过长
        //计算比例系数
        CGFloat kSacale = [UIScreen mainScreen].bounds.size.width/self.imageView.frame.size.width;
        //大小缩放
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform,kSacale, kSacale);
    }else{
        //判断当宽度缩放到屏幕宽度之后,高度与500哪一个更大
        CGFloat kSacale = [UIScreen mainScreen].bounds.size.width / self.imageView.frame.size.width;
        if (self.imageView.frame.size.height * kSacale >= 500) {
            kSacale = 500 / self.imageView.frame.size.height;
        }
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform,kSacale, kSacale);
    }
    //使用绘制的方法得到旋转之后的图片
    double rotationZ = [[self.imageView.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    self.imageView.image  =  [UIImage fixOrientation:self.imageView.image];//修正图片本身的旋转
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.imageView.image.size.width, self.imageView.image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotationZ);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.imageView.image.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap,rotationZ);
    CGContextScaleCTM(bitmap, 1, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.imageView.image.size.width / 2, -self.imageView.image.size.height / 2, self.imageView.image.size.width, self.imageView.image.size.height), [self.imageView.image CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //把最终的图片存到相册看看是否成功
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
