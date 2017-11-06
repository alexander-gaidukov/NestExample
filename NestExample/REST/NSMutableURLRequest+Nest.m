//
//  NSURLRequest+Nest.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "NSMutableURLRequest+Nest.h"
#import "NSURL+Nest.h"

@implementation NSMutableURLRequest (Nest)

- (instancetype)initWithBaseURL:(NSURL *)baseURL path:(NSString *)path method:(HTTPMethod)method params:(NSDictionary *)params {
    NSURL *url = [[NSURL alloc] initWithBaseURL:baseURL path:path method:method params:params];
    self = [self initWithURL:url];

    if (method == HTTPMethodGET) {
        self.HTTPMethod = @"GET";
    } else if (method == HTTPMethodPOST) {
        self.HTTPMethod = @"POST";
    } else if (method == HTTPMethodPUT) {
        self.HTTPMethod = @"PUT";
    } else if (method == HTTPMethodDelete) {
        self.HTTPMethod = @"DELETE";
    }
    
    if (method == HTTPMethodPUT || method == HTTPMethodDelete) {
        self.HTTPBody = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    }
    
    return self;
}

@end
