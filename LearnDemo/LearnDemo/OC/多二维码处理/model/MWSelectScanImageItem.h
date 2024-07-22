//
//  MWSelectScanImageItem.h
//  LearnDemo
//
//  Created by odd on 7/22/24.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface MWSelectScanImageItem : NSObject

@property (nonatomic, strong) NSString *qrcodeStr;
@property (nonatomic, assign) CGRect qrcodeFrame;

// 判断point 是否在二维码范围内
- (BOOL)isPointInQrcodeFrame:(CGPoint)targetPoint;


@end

NS_ASSUME_NONNULL_END
