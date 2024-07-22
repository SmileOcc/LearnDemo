//
//  UIImage+QRCode.h
//  LearnDemo
//
//  Created by odd on 7/22/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QRCode)

// 获取图片二维码信息
- (NSArray <CIFeature*> *)imageQRFeatures;

- (UIImage *)drawQRBorder:(UIImage *)targetImage features:(CIQRCodeFeature *)feature;

- (NSArray <NSString *> *)qrCodeListStr;


@end

NS_ASSUME_NONNULL_END
