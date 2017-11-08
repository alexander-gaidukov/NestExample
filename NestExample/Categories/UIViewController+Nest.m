//
//  UIViewController+Nest.m
//  NestExample
//
//  Created by Alexander Gaidukov on 11/8/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "UIViewController+Nest.h"

@implementation UIViewController (Nest)

- (void)showErrorAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
