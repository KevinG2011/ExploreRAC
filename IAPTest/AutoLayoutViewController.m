//
//  AutoLayoutViewController.m
//  IAPTest
//
//  Created by Loriya on 2018/5/19.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "AutoLayoutViewController.h"

@interface AutoLayoutViewController ()

@end

@implementation AutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)buttonTapped:(UIButton*)sender {
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"X"]) {
        [sender setTitle:@"A very long title for this button" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"X" forState:UIControlStateNormal];
    }
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
