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

#define ACCESS_TOKEN_KEYCHAIN_KEY @"access_token"

@interface AuthenticationManager()

@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *productSecret;
@property(nonatomic, strong) AccessToken *accessToken;

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
    AccessToken *accessToken = self.accessToken;
    if (accessToken) {
        return  [[NSDate date] compare: accessToken.expirationDate] == NSOrderedAscending;
    }
    return NO;
 }

- (void)signInWithCode:(NSString *)code completion:(void (^)(BOOL, NSError * _Nullable))completionBlock {
    NSString *urlString = [NSString stringWithFormat:@"https://api.home.nest.com/oauth2/access_token?client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code", self.productId, self.productSecret, code];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        BOOL success = NO;
        
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (json) {
                AccessToken *accessToken = [[AccessToken alloc] initWith:json];
                self.accessToken = accessToken;
                success = YES;
                if (self.delegate) {
                    [self.delegate authenticationManagerDidLogin:self];
                }
            }
        }
        
        if (completionBlock) {
            completionBlock(success, error);
        }
        
    }] resume];
}

- (void)logout {
    NSString* urlString = [NSString stringWithFormat:@"https://api.home.nest.com/oauth2/access_tokens/%@", self.token];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"DELETE";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request] resume];
    
    [self didLogout];
}

- (void)didLogout {
    self.accessToken = nil;
    if (self.delegate) {
        [self.delegate authenticationManagerDidLogout:self];
    }
}

#pragma mark private

- (AccessToken *)accessToken {
    NSData *accessTokenData = [Keychain loadForIdentifier:ACCESS_TOKEN_KEYCHAIN_KEY];
    if (accessTokenData) {
        return  [NSKeyedUnarchiver unarchiveObjectWithData:accessTokenData];
    }
    return nil;
}

- (void)setAccessToken:(AccessToken *)accessToken {
    if (accessToken) {
        [Keychain saveValue:[NSKeyedArchiver archivedDataWithRootObject:accessToken] forIdentifier:ACCESS_TOKEN_KEYCHAIN_KEY];
    } else {
        [Keychain deleteItemForIdentifier:ACCESS_TOKEN_KEYCHAIN_KEY];
    }
}

@end
