//
//  RESTClient.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTTPMethodPOST,
    HTTPMethodGET,
    HTTPMethodPUT,
    HTTPMethodDelete
} HTTPMethod;

@interface RESTClient : NSObject

- (instancetype) initWithBaseURL: (NSURL *)baseURL;

- (NSURLSessionDataTask *)loadFromPath:(NSString *)path
              method:(HTTPMethod)method
              params:(NSDictionary *)params
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *)) failure;

@end
