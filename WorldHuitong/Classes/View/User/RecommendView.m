//
//  RecommendView.m
//  WorldHuitong
//
//  Created by TXHT on 16/4/29.
//  Copyright © 2016年 huitongp2p.com. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView

+(UIView*)headViewWithController:(UIViewController*)controllere  Url:(NSString *)url
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = HT_BG_COLOR;
    
    //二维码
    UIImageView *barcodes = [[UIImageView alloc]init];
    CGFloat W = (kScreenWidth ) / 2;
    CGFloat X = (kScreenWidth - W) / 2;
    barcodes.frame = CGRectMake(X, 80, W, W - 10);
    [barcodes setImage:[UIImage imageNamed:@"天下汇通"]];
    
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:url] withSize:250.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    barcodes.image = customQrcode;
    [headView addSubview:barcodes];
    
    //lable扫一扫二维码，推荐好友一起理财
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 + W + W / 2 +10, kScreenWidth, 21)];
    [lable setFont:[UIFont systemFontOfSize:14]];
    lable.text = @"扫一扫二维码，推荐好友一起领钱";
    lable.textAlignment =  NSTextAlignmentCenter;
    [headView addSubview:lable];
    
    //按钮
   UIButton * recommendBtn = [[UIButton alloc]init];
    recommendBtn.frame = CGRectMake(15, 20 + W + W / 2 +10 + 60, kScreenWidth - 30, 44);
    [headView addSubview:recommendBtn];
    [recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [recommendBtn setBackgroundColor:HT_COLOR];
    [recommendBtn addTarget:controllere action:@selector(recommendAction) forControlEvents:UIControlEventTouchUpInside];
    [[HTView shareHTView]setView:recommendBtn cornerRadius:4];
    [recommendBtn setTitle:@"我要推荐" forState:UIControlStateNormal];
    [headView addSubview:recommendBtn];
    //
    headView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - 64 * 2);
    
    
    
    return headView;



}


-(void)recommendAction
{



}

#pragma mark - InterpolatedUIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



@end
