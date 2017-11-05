//
//  AuthenticationManager.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationManager : NSObject

@property (nonatomic, strong, readonly) NSString * _Nullable token;
@property (nonnull, strong, readonly) NSURL *authenticationURL;
@property (nonnull, strong, readonly) NSURL *redirectURL;

+ (instancetype _Nonnull) sharedInstance;

- (BOOL)isValidSession;
- (void)signInWithCode:(NSString *_Nonnull)code completion: (void(^_Nonnull)(BOOL, NSError *_Nullable))completionBlock;

@end
