//
//  AuthenticationViewController.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticationViewController;

@protocol AuthenticationViewControllerDelegate<NSObject>
- (void)authenticationViewControllerDidFinish: (AuthenticationViewController *)authenticationViewController;
@end

@interface AuthenticationViewController : UIViewController

- (instancetype)initWithAuthenticationURL:(NSURL *)authURL redirectURL:(NSURL *)redirectURL delegate:(id<AuthenticationViewControllerDelegate>)delegate;

@end
