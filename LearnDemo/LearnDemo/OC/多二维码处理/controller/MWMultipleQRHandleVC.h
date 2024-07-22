//
//  MWMultipleQRHandleVC.h
//  LearnDemo
//
//  Created by odd on 7/22/24.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MutipleQRHandleTypeButton,
    MutipleQRHandleTypeTouch,
} MutipleQRHandleType;


NS_ASSUME_NONNULL_BEGIN

@interface MWMultipleQRHandleVC : UIViewController

@property (nonatomic, assign) MutipleQRHandleType type;
@property (nonatomic, strong) UIImage *displayImage;
@property (nonatomic, strong) NSArray *features;
@property (nonatomic, copy) void(^selectScanStrBlock)(NSString *scanStr);

@end

NS_ASSUME_NONNULL_END



