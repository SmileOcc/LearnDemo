//
//  MyURLSchemeHandler.h
//  LearnDemo
//
//  Created by odd on 7/16/24.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

extern NSString * _Nonnull const MOJI_URL_SCHEME_KEY;
extern NSString * _Nonnull const MOJI_URL_WORD_KEY;


NS_ASSUME_NONNULL_BEGIN

@interface MyURLSchemeHandler : NSObject<WKURLSchemeHandler>

+ (void)removeAllUrlCacheFile;

@end

NS_ASSUME_NONNULL_END
