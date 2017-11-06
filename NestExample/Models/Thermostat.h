//
//  Thermostat.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONDecodable.h"

@interface Thermostat : NSObject<JSONDecodable>

@property (nonatomic, strong, readonly) NSString *thermostatId;

- (instancetype)initWithId:(NSString *)thermostatId;

@end
