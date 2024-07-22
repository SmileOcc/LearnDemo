//
//  MyURLSchemeHandler.m
//  LearnDemo
//
//  Created by odd on 7/16/24.
//

#import "MyURLSchemeHandler.h"

NSString *const MOJI_URL_SCHEME_KEY = @"herald-hybrid";
NSString *const MOJI_URL_WORD_KEY   = @"/myhybrid/";


@implementation MyURLSchemeHandler

- (void)testRegister {//注册Scheme
    // 初始化 webViewConfiguration
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];

    // 需要通过 webViewConfiguration 注册
    [webViewConfiguration setURLSchemeHandler:
        [[MyURLSchemeHandler alloc] init] forURLScheme:@"herald-hybrid"];
    // MyURLSchemeHandler 是我的项目中实现的 WKURLSchemeHandler，下文详述如何实现

    // ...其他配置
    // 初始化 WKWebView
//    WKWebView *webView =
//        [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
    
    
//    将webView的请求修改为herald-hybrid开头
//
//    例如你跟后台约定，在url中包含/myhybrid/字段的请求，都需要拦截
//    那你就需要判断你的url是否包含该字段，然后替换http开头为herald-hybrid，这样你的其他请求就不会被拦截
//
//    NSString *urlStr = @"http://hybrid.myseu.cn/myhybrid/index.html";
//
//    if ([urlStr containsString:MOJI_URL_WORD_KEY]) {
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http" withString:MOJI_URL_SCHEME_KEY];
//    }
//
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

}

- (void)webView:(nonnull WKWebView *)webView startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {
    NSURL *URL        = urlSchemeTask.request.URL;
    NSString *urlPath = URL.absoluteString;
    NSLog(@"拦截到请求的URL：%@", URL);
    
    if (![urlPath containsString:MOJI_URL_WORD_KEY]) return; // 链接中不包含我们的关键字，则return
    
    //1.确定正在请求的文件是哪一个
    NSString *localFileName = [URL lastPathComponent];
    NSLog(@"本地文件名称：%@", localFileName);
    
    //2.读取本地文件数据/信息
    NSString *localFilePath = [MyURLSchemeHandler urlCacheRootFilePath];
    
    NSArray *pathArr   = [urlPath componentsSeparatedByString:MOJI_URL_WORD_KEY];
    NSString *lastPath = [NSString stringWithFormat:@"%@%@", MOJI_URL_WORD_KEY, pathArr.lastObject];
    NSLog(@"从url中提取的路径：%@", lastPath);
    
    localFilePath = [NSString stringWithFormat:@"%@%@", localFilePath, lastPath];
    NSLog(@"拼接之后的本地文件路径：%@", localFilePath);
    
    //3.判断本地是否有该文件，有的话使用本地离线数据
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath]) {
        // 读取文件数据
        NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:localFilePath];
        NSData *data       = [file readDataToEndOfFile];
        [file closeFile];

        NSURLResponse *tmpResponse = [MyURLSchemeHandler getURLResponseWithURL:URL data:data];
        [urlSchemeTask didReceiveResponse:tmpResponse];
        [urlSchemeTask didReceiveData:data];
        [urlSchemeTask didFinish];

        NSLog(@"使用本地缓存文件来加载数据");
        return;
    }
    
    //4.本地没有离线数据的话，就进行url请求，记得将MOJI_URL_SCHEME_KEY改回http，不然无法请求，然后将请求的资源保存到本地
    NSString *tmpUrl = [URL.absoluteString stringByReplacingOccurrencesOfString:MOJI_URL_SCHEME_KEY withString:@"http"];
    NSURL *tmpURL    = [NSURL URLWithString:tmpUrl];

    NSLog(@"开始请求数据, url = %@", tmpURL);
    NSURLSession *session      = NSURLSession.sharedSession;
    NSURLSessionDataTask *task = [session dataTaskWithURL:tmpURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            /*
             【注意】：这里不能直接使用response返回，所以需要手动构建tmpResponse
              1、response可能为空, 或者其中的content-type是不准确的，例如css的content-type返回的是application/javascript，应该用text/css
              2、【非常重要】response的url是tmpURL，是http开头的，这样的话js中嵌套的js会以http来请求，就无法再通过startURLSchemeTask拦截了，
                要改成最开始拦截的那个URL才行，这样js中的js也会以MOJI_URL_SCHEME_KEY开头去请求，从而被拦截到
             */
            NSURLResponse *tmpResponse = [MyURLSchemeHandler getURLResponseWithURL:URL data:data];
            
            [urlSchemeTask didReceiveResponse:tmpResponse];
            [urlSchemeTask didReceiveData:data];
            [urlSchemeTask didFinish];
            
            // 能走到这里的，都是符合条件的，不过还是添加一层判断
            if ([tmpUrl containsString:MOJI_URL_WORD_KEY]) {
                NSString *tmpName         = [NSString stringWithFormat:@"/%@", localFileName];
                NSString *pathWithoutName = [localFilePath stringByReplacingOccurrencesOfString:tmpName withString:@""];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:pathWithoutName]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:pathWithoutName withIntermediateDirectories:YES attributes:nil error:nil];
                    NSLog(@"新建的本地文件路径：%@", pathWithoutName);
                }
                
                NSError *error = nil;
                [data writeToFile:localFilePath options:0 error:&error];
                
                if (error) {
                    NSLog(@"新保存的本地文件，保存失败：%@", localFilePath);
                    NSLog(@"%s > failed for > %@", __PRETTY_FUNCTION__, error.localizedDescription);
                } else {
                    NSLog(@"新保存的本地文件，保存成功：%@", localFilePath);
                    NSLog(@"%s > done.", __PRETTY_FUNCTION__);
                }
            }
        } else {
            [urlSchemeTask didFailWithError:error];
        }
    }];
    [task resume];
}

- (void)webView:(nonnull WKWebView *)webView stopURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {
    // nothing
}

+ (NSURLResponse *)getURLResponseWithURL:(NSURL *)URL data:(NSData *)data {
    NSString *pathExtension = [URL pathExtension];
    NSString *MIMEType      = [MyURLSchemeHandler getMIMETypeFromPathExtension:pathExtension];
    return [[NSURLResponse alloc] initWithURL:URL MIMEType:MIMEType expectedContentLength:data.length textEncodingName:nil];
}

+ (NSString *)getMIMETypeFromPathExtension:(NSString *)pathExtension {
    NSString *MIMEType = @"text/plain";
    
    if ([pathExtension isEqualToString:@"html"]) {
        MIMEType = @"text/html";
    } else if ([pathExtension isEqualToString:@"js"]) {
        MIMEType = @"application/javascript";
    } else if ([pathExtension isEqualToString:@"css"]) {
        MIMEType = @"text/css";
    } else if ([pathExtension isEqualToString:@"png"]) {
        MIMEType = @"image/png";
    } else if ([pathExtension isEqualToString:@"jpeg"]) {
        MIMEType = @"image/jpeg";
    } else if ([pathExtension isEqualToString:@"json"]) {
        MIMEType = @"application/json";
    } else if ([pathExtension isEqualToString:@"xml"]) {
        MIMEType = @"application/xml";
    } else if ([pathExtension isEqualToString:@"pdf"]) {
        MIMEType = @"application/pdf";
    } else if ([pathExtension isEqualToString:@"gif"]) {
        MIMEType = @"image/gif";
    } else if ([pathExtension isEqualToString:@"mp3"]) {
        MIMEType = @"audio/mpeg";
    } else if ([pathExtension isEqualToString:@"mp4"]) {
        MIMEType = @"video/mp4";
    } else if ([pathExtension isEqualToString:@"zip"]) {
        MIMEType = @"application/zip";
    }
    
    return MIMEType;
}

+ (NSString *)urlCacheRootFilePath {
    NSString *filePath = [MyURLSchemeHandler documentsDirectoryPath];
    return [filePath stringByAppendingPathComponent:MOJI_URL_SCHEME_KEY];
}

+ (NSString *)documentsDirectoryPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (void)removeAllUrlCacheFile {
    NSString *path = [MyURLSchemeHandler urlCacheRootFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

@end
