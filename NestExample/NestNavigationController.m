//
//  NestNavigationController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "NestNavigationController.h"
#import "AuthenticationManager.h"
#import "AuthenticationViewController.h"
#import "ViewController.h"

@interface NestNavigationController ()<AuthenticationManagerDelegate>

@property (nonatomic, strong, readonly) AuthenticationManager *authManager;

@end

@implementation NestNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.authManager.delegate = self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    if (![self.authManager isValidSession]) {
        dispatch_once(&onceToken, ^{
            [self showAuthenticationController];
        });
        return;
    }
    [self didLogin];
}

- (void)showAuthenticationController {
    AuthenticationViewController* authController = [[AuthenticationViewController alloc] initWithAuthenticationURL:self.authManager.authenticationURL redirectURL:self.authManager.redirectURL];
    [self presentViewController:authController animated:YES completion:nil];
}

- (AuthenticationManager *)authManager {
    return [AuthenticationManager sharedInstance];
}

- (void)didLogin {
    [(ViewController *)[self.viewControllers firstObject] loadStructures];
}

#pragma mark - AuthenticationManagerDelegate

- (void)authenticationManagerDidLogin:(AuthenticationManager *)authenticationManager {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self didLogin];
}

- (void)authenticationManagerDidLogout:(AuthenticationManager *)authenticationManager {
    [self showAuthenticationController];
    [self popToRootViewControllerAnimated:NO];
}

@end
