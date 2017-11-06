//
//  Thermostat.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "Thermostat.h"

@interface Thermostat()
@property (nonatomic, strong) NSString *thermostatId;
@end

@implementation Thermostat

- (instancetype)initWith:(NSDictionary *)json {
    if(self = [super init]) {
        self.thermostatId = [json objectForKey:@"thermostat_id"];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)thermostatId {
    if(self = [super init]) {
        self.thermostatId = thermostatId;
    }
    
    return self;
}

@end
