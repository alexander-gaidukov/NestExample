//
//  NSURL+Nest.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "NSURL+Nest.h"

@implementation NSURL (Nest)

- (instancetype)initWithBaseURL:(NSURL *)baseURL path:(NSString *)path method:(HTTPMethod)method params:(NSDictionary *)params {
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:NO];
    NSMutableString *basePath = [components.path mutableCopy];
    if(![basePath hasSuffix:@"/"]) {
        basePath = [[NSString stringWithFormat:@"%@/", basePath] mutableCopy];
    }
    
    NSMutableString *mutablePath = [path mutableCopy];
    if([mutablePath hasPrefix:@"/"]) {
        [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    components.path = [NSString stringWithFormat:@"%@%@", basePath, mutablePath];
    
    if (method == HTTPMethodGET || method == HTTPMethodDelete) {
        NSMutableArray *queryItems = [components.queryItems mutableCopy];
        for(NSString *key in params.allKeys) {
            NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:[params objectForKey:key]];
            [queryItems addObject: queryItem];
        }
        components.queryItems = queryItems;
    }
    
    return [self initWithString:components.URL.absoluteString];
}

@end
