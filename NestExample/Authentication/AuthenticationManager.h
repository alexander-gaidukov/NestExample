//
//  AuthenticationManager.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationManager : NSObject

@property (nonatomic, strong, readonly) NSString *token;

+ (instancetype) sharedInstance;

- (BOOL)isValidSession;

@end
