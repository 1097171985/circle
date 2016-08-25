//
//  ViewController.m
//  XHGCircleImageView
//
//  Created by xiaohuge on 16/3/30.
//  Copyright © 2016年 xiaohuge. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Image.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()


@property(nonatomic,strong)UIImageView *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self  createCircle];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)createCircle{
    
    self.image = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-20, HEIGHT/2-20,100, 100)];
    
    //UIImage *image = [UIImage imageNamed:@"狗狗.jpg"];
    self.image.backgroundColor = [UIColor greenColor];
    
    UIImage *yuanlai = [UIImage imageNamed:@"WechatIMG1"];
    
    CGSize size =yuanlai.size;
    
    float imageSize;
    
    NSLog(@"size==height%f====width%f",size.height,size.width);
    if (size.height >= size.width) {
        
        imageSize = size.width;
    }else{
        
        imageSize = size.height;
    }
    
    UIImage *onelai = [self getSquareImage:yuanlai RangeCGRect:CGRectMake(0, 0, imageSize, imageSize) centerBool:YES];
    
    [self saveImage:onelai];
    
     UIImage *image = [UIImage hu_circleImage:onelai];
    
     [self saveImage:image];

     UIImage *totalImage = [self getClearRectImage:image];
//    
     [self saveImage:totalImage];
//    
     self.image.image = totalImage;
    
     [self.view addSubview:self.image];
}

-(void)saveImage:(UIImage *)image{
    
    NSData *data1;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data1 = UIImageJPEGRepresentation(image, 1);
    }
    else
    {
        data1 = UIImagePNGRepresentation(image);
    }
   // 图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data1 attributes:nil];
            //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    
     NSLog(@"filePath===%@",filePath);
    
}



-(UIImage*)getSquareImage:(UIImage
                        *)image RangeCGRect:(CGRect)range
            centerBool:(BOOL)centerBool{
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    float  imgWidth = image.size.width;
    float  imgHeight = image.size.height;
    float  viewWidth =  range.size.width;
    float  viewHidth =  range.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgWidth-viewWidth)/2,
                   (imgHeight-viewHidth)/2,viewWidth,viewHidth);
    else{
        if(viewHidth<viewWidth)
        {
            if(imgWidth<= imgHeight){
              rect= CGRectMake(0,0,imgWidth, imgWidth*viewHidth/viewWidth);
            }else{
                float  width = viewWidth*imgHeight/viewHidth;
                float  x = (imgWidth - width)/2;
                if(x > 0){
                  rect = CGRectMake(x,0, width, imgHeight);
                }else{
                    rect=CGRectMake(0,0,imgWidth, imgWidth*viewHidth/viewWidth);
                }
            }
        }else{
            if(imgWidth<= imgHeight){
                float height = viewHidth*imgWidth/viewWidth;
                if(height < imgHeight){
                    rect = CGRectMake(0,0,imgWidth, height);
                }else
                {
                    rect = CGRectMake(0,0,viewWidth*imgHeight/viewHidth,imgHeight);
                }
            }else
            {
                float width = viewWidth*imgHeight/viewHidth;
                if(width < imgWidth)
                {
                    float x = (imgWidth - width)/2;
                    rect = CGRectMake(x,0,width, imgHeight);
                }else
                {
                    rect =CGRectMake(0,0,imgWidth, imgHeight);
                }
            }
        }
    }
    
    CGImageRef  SquareImageRef =
    CGImageCreateWithImageInRect(image.CGImage,rect);
    CGRect    SquareImageBounds = CGRectMake(0,0,CGImageGetWidth(SquareImageRef),CGImageGetHeight(SquareImageRef));
    
    UIGraphicsBeginImageContext(SquareImageBounds.size);
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context,SquareImageBounds,SquareImageRef);
    UIImage* SquareImage = [UIImage imageWithCGImage:SquareImageRef];
    UIGraphicsEndImageContext();
    
    return  SquareImage;
}


- (UIImage *)getClearRectImage:(UIImage *)image{
    
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //默认绘制的内容尺寸和图片一样大 ,从某一点开始绘制
    [image drawAtPoint:CGPointZero];
    
    CGFloat bigRaduis = image.size.width/5;
    
    CGRect cirleRect = CGRectMake(image.size.width/2-bigRaduis, image.size.height/2-bigRaduis, bigRaduis*2, bigRaduis*2);
    
    //CGContextAddArc(ctx,image.size.width/2-bigRaduis,image.size.height/2-bigRaduis, bigRaduis, 0.0, 2*M_PI, 0);
    
    CGContextAddEllipseInRect(ctx,cirleRect);
    
    CGContextClip(ctx);
    
    CGContextClearRect(ctx,cirleRect);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
    
}


















-(UIImage *)getTopHalfImageWithImage:(UIImage *)image{
    //  上半部
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height/2.0), NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height/2.0);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height/2.0);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, CGRectMake(0, -image.size.height/2.0, image.size.width, image.size.height/2.0), image.CGImage);
    
    //    CGContextClipToRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height/2.0));
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)getBottomHalfImageWithImage:(UIImage *)image alpha:(CGFloat)alpha{
    
    //  下半部
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height/2.0), NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height/2.0);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height/2.0);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height/2.0), image.CGImage);
    
    CGContextClipToRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height/2.0));
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)getHoloImageWithImage:(UIImage *)image alpha:(CGFloat)alpha{
    
    @synchronized (self) {
        
        UIImage *image1 = [self getTopHalfImageWithImage:image];
        
        UIImage *image2 = [self getBottomHalfImageWithImage:image alpha:alpha];
        
        CGSize size = CGSizeMake(image.size.width, image.size.height);
        UIGraphicsBeginImageContext(size);
        [image1 drawInRect:CGRectMake(0, -image1.size.height, size.width, image.size.height)];
        [image2 drawInRect:CGRectMake(0, image.size.height/2.0, size.width, image.size.height)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return resultImage;
    }
}



//设置图片透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
        
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}


#pragma mark 圆形剪辑
-(UIImage *)circleImageWithName:(UIImage *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    //加载原图
    UIImage *oldImage = name;
    
    CGFloat imageW = oldImage.size.width+22*borderWidth;
    CGFloat imageH = oldImage.size.height+22*borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    //
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    [borderColor set];
    
    CGFloat bigRaduis = imageW*0.5;
    CGFloat centerX   = bigRaduis;//圆心
    CGFloat centerY   = bigRaduis;
    CGContextAddArc(ctx, centerX, centerY, bigRaduis, 0, M_PI*2, 0);
    CGContextFillPath(ctx);//画圆.
    
    //5.小圆
    CGFloat samllRadius = bigRaduis-borderWidth;
    CGContextAddArc(ctx, centerX, centerY, samllRadius, 0, M_PI*2, 0);
    
    //裁剪
    CGContextClip(ctx);
    
    //6画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    //7取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //8.结束上下文
    UIGraphicsEndPDFContext();
    
    return newImage;
}


//合并2张图片
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
