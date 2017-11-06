//
//  RESTClient.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "RESTClient.h"
#import "NSMutableURLRequest+Nest.h"
#import "AuthenticationManager.h"

@interface RESTClient()
@property(nonatomic, strong) NSURL *baseURL;
@end

@implementation RESTClient

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    if (self = [super init]) {
        self.baseURL = baseURL;
    }
    return self;
}

- (NSURLSessionDataTask *)loadFromPath:(NSString *)path method:(HTTPMethod)method params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithBaseURL:self.baseURL path:path method:method params:params];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [AuthenticationManager sharedInstance].token] forHTTPHeaderField:@"Authorization"];
    return [self loadRequest:request success:success failuer:failure];
}

- (NSURLSessionDataTask *)loadRequest:(NSMutableURLRequest *)request success:(void (^)(NSDictionary *))success failuer:(void(^)(NSError * error))failure {
    __weak typeof(self) weakSelf = self;
    
    __block NSURLSessionDataTask *task = nil;
    
    task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!weakSelf) {
            return;
        }
        
        __strong typeof(self) strongSelf = weakSelf;
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSInteger contentLength = [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (httpResponse.statusCode == 401 && contentLength == 0) {
            [[AuthenticationManager sharedInstance] didLogout];
        } else if (httpResponse.statusCode == 401 || httpResponse.statusCode == 307) {
            [request setURL:response.URL];
            task = [strongSelf loadRequest:request success:success failuer:failure];
        } else if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
            if (success) {
                success(json);
            }
        } else {
            NSError *err = error;
            if([json objectForKey:@"message"]) {
                err = [[NSError alloc] initWithDomain:@"Nest" code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: [json objectForKey:@"message"]}];
            }
            if(failure) {
                failure(error);
            }
        }
    }];
    
    [task resume];
    return task;
}

@end
