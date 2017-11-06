//
//  AuthenticationViewController.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationViewController : UIViewController

- (instancetype)initWithAuthenticationURL:(NSURL *)authURL redirectURL:(NSURL *)redirectURL;

@end
