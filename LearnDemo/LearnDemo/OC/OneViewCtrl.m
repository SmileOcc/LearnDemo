//
//  OneCtrl.m
//  LearnDemo
//
//  Created by odd on 6/2/24.
//

#import "OneViewCtrl.h"
#import "BView.h"

@interface OneViewCtrl ()

@end

@implementation OneViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.redColor;
    
    BView *ccView = [[BView alloc] initWithFrame:CGRectMake(100, 100, 150, 300)];
    ccView.backgroundColor = UIColor.greenColor;
    [self.view addSubview:ccView];

    NSLog(@"这个也不会死锁0");

    dispatch_queue_t queue = dispatch_queue_create("serial", nil);
    dispatch_sync(queue, ^(void){
        NSLog(@"这个也不会死锁1");
    });
    NSLog(@"这个也不会死锁2");

}

+ (void)testaa {
    NSLog(@"这个也不会死锁0");
    dispatch_queue_t queue = dispatch_queue_create("serial", nil);
    dispatch_sync(queue, ^(void){
        NSLog(@"这个也不会死锁1");
    });
    NSLog(@"这个也不会死锁2");
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
