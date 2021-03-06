//
//  JSONDecodable.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONDecodable <NSObject>
- (instancetype)initWithJSON:(NSDictionary *)json;
@optional
- (void)updateWithJSON:(NSDictionary *)json;
@end
