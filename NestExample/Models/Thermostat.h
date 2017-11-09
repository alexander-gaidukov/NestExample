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
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSNumber *currentTemperature;
@property (nonatomic, strong) NSNumber *targetTemperature;

- (instancetype)initWithId:(NSString *)thermostatId;

- (NSDictionary *)updateParams;

@end
