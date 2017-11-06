//
//  NSURLRequest+Nest.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTClient.h"

@interface NSMutableURLRequest (Nest)

- (instancetype)initWithBaseURL:(NSURL *)baseURL path:(NSString *)path method:(HTTPMethod)method params:(NSDictionary *)params;

@end
