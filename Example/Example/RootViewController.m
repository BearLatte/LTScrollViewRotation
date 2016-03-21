//
//  RootViewController.m
//  Example
//
//  Created by Latte_Bear on 16/3/21.
//  Copyright © 2016年 Latte_Bear. All rights reserved.
//

#import "RootViewController.h"
#import "LTScrollViewRotation.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LTScrollViewRotation *rotation = [[LTScrollViewRotation alloc] initWithFrame:CGRectMake(0, 100, 312, 142) animationDuration:2.0];
    
    NSMutableArray *viewArray = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rotation.bounds.size.width, rotation.bounds.size.height)];
        testImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d",i + 1]];
        testImageView.contentMode = UIViewContentModeScaleAspectFill;
        testImageView.clipsToBounds = YES;
        [viewArray addObject:testImageView];
    }
    
    [rotation setContentViewAtIndex:^UIView *(NSInteger pageIndex) {
        return [viewArray objectAtIndex:pageIndex];
    }];
    [rotation setTotalPagesNumber:^NSInteger{
        return 5;
    }];
    [rotation setTapActionBlock:^(NSInteger pageIndex) {
        NSLog(@"点击了第%ld个页面",(long)pageIndex);
    }];
    [self.view addSubview:rotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
