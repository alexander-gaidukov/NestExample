//
//  Thermostat.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "Thermostat.h"

#define DEVICE_ID_KEY @"device_id"
#define DEVICE_NAME_KEY @"name_long"
#define AMBIENT_TEMPERATURE_KEY @"ambient_temperature_c"
#define TARGET_TEMPERATURE_KEY @"target_temperature_c"

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
    self.thermostatId = [json objectForKey:DEVICE_ID_KEY];
    self.name = [json objectForKey:DEVICE_NAME_KEY];
    self.currentTemperature = [json objectForKey:AMBIENT_TEMPERATURE_KEY];
    self.targetTemperature = [json objectForKey:TARGET_TEMPERATURE_KEY];
}

- (NSDictionary *)updateParams {
    return @{TARGET_TEMPERATURE_KEY : self.targetTemperature};
}

@end
