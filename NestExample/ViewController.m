//
//  ViewController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ViewController.h"
#import "AuthenticationManager.h"
#import "AuthenticationViewController.h"

@interface ViewController ()<AuthenticationViewControllerDelegate>

@property (nonatomic, strong, readonly) AuthenticationManager *authManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    if (![self.authManager isValidSession]) {
        dispatch_once(&onceToken, ^{
            AuthenticationViewController* authController = [[AuthenticationViewController alloc] initWithAuthenticationURL:self.authManager.authenticationURL redirectURL:self.authManager.redirectURL delegate: self];
            [self presentViewController:authController animated:YES completion:nil];
        });
        return;
    }
}


- (AuthenticationManager *)authManager {
    return [AuthenticationManager sharedInstance];
}

#pragma mark - AuthenticationViewControllerDelegate
- (void)authenticationViewControllerDidFinish:(AuthenticationViewController *)authenticationViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
