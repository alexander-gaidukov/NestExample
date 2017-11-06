//
//  AuthenticationManager.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AuthenticationManager;

@protocol AuthenticationManagerDelegate<NSObject>
- (void)authenticationManagerDidLogin:(AuthenticationManager *_Nonnull)authenticationManager;
- (void)authenticationManagerDidLogout:(AuthenticationManager *_Nonnull)authenticationManager;
@end

@interface AuthenticationManager : NSObject

@property (nonatomic, strong, readonly) NSString * _Nullable token;
@property (nonnull, strong, readonly) NSURL *authenticationURL;
@property (nonnull, strong, readonly) NSURL *redirectURL;
@property (nullable, weak) id<AuthenticationManagerDelegate>delegate;

+ (instancetype _Nonnull) sharedInstance;

- (BOOL)isValidSession;
- (void)signInWithCode:(NSString *_Nonnull)code completion: (void(^_Nonnull)(BOOL, NSError *_Nullable))completionBlock;

- (void)logout;
- (void)didLogout;

@end
