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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *currentTemperature;
@end

@implementation Thermostat

- (instancetype)initWith:(NSDictionary *)json {
    if(self = [super init]) {
        [self updateWith:json];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)thermostatId {
    if(self = [super init]) {
        self.thermostatId = thermostatId;
    }
    
    return self;
}

- (void)updateWith:(NSDictionary *)json {
    self.thermostatId = [json objectForKey:@"thermostat_id"];
    self.name = [json objectForKey:@"name_long"];
    self.currentTemperature = [json objectForKey:@"ambient_temperature_c"];
    self.targetTemperature = [json objectForKey:@"target_temperature_c"];
}

@end
