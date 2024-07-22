//
//  ViewController.m
//  TestOC
//
//  Created by odd on 7/13/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:oneView];
    oneView.backgroundColor = [UIColor orangeColor];
    
    CGPoint originalCenter = oneView.center;
    oneView.layer.anchorPoint = CGPointMake(0, 0);
    oneView.center = originalCenter;

    
    
}


@end
