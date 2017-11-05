//
//  AuthenticationManager.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "AuthenticationManager.h"
#import "Constants.h"
#import "Keychain.h"
#import "AccessToken.h"

@interface AuthenticationManager()

@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *productSecret;
@property(nonatomic, strong, readonly) AccessToken *accessToken;

@end

@implementation AuthenticationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static AuthenticationManager *sharedInstance;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[AuthenticationManager alloc] initWithProductId:NestProductID productSecret:NestProductSecret];
    });
    
    return sharedInstance;
}

- (id)initWithProductId:(NSString *)productId productSecret:(NSString *) productSecret {
    
    if (self = [super init]) {
        self.productId = productId;
        self.productSecret = productSecret;
    }
    
    return self;
}

- (NSString *)token {
    return self.accessToken.token;
}

- (NSURL *)redirectURL {
    return [NSURL URLWithString:NestRedirectURLString];
}

- (NSURL *)authenticationURL {
    NSString *urlString = [NSString stringWithFormat:@"https://home.nest.com/login/oauth2?client_id=%@&state=STATE", self.productId];
    return [NSURL URLWithString:urlString];
}

- (BOOL)isValidSession {
    if (self.accessToken) {
        return  [[NSDate date] compare:self.accessToken.expirationDate] == NSOrderedAscending;
    }
    return NO;
 }

- (void)signInWithCode:(NSString *)code completion:(void (^)(BOOL, NSError * _Nullable))completionBlock {
    
}

#pragma mark private

- (AccessToken *)accessToken {
    NSData *accessTokenData = [Keychain loadForIdentifier:@"access_token"];
    if (accessTokenData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:accessTokenData];
    }
    return nil;
}

@end
