//
//  AccessToken.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "AccessToken.h"

#define ACCESS_TOKEN_KEY @"access_token"
#define EXPIRES_IN_KEY @"expires_in"

@implementation AccessToken

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        self.token = [json objectForKey:ACCESS_TOKEN_KEY];
        NSTimeInterval timeInterval = [[json objectForKey:EXPIRES_IN_KEY] doubleValue];
        self.expirationDate = [[NSDate date] dateByAddingTimeInterval:timeInterval];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.token forKey:NSStringFromSelector(@selector(token))];
    [coder encodeObject:self.expirationDate forKey:NSStringFromSelector(@selector(expirationDate))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        self.token = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(token))];
        self.expirationDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(expirationDate))];
    }
    
    return self;
}

@end
