//
//  Structure.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "Structure.h"
#import "Thermostat.h"

#define STRUCTURE_ID_KEY @"structure_id"
#define STRUCTURE_NAME_KEY @"name"
#define THERMOSTATS_KEY @"thermostats"

@interface Structure()
@property (nonatomic, strong) NSString *structureId;
@end

@implementation Structure

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        self.structureId = [json objectForKey:STRUCTURE_ID_KEY];
        self.name = [json objectForKey:STRUCTURE_NAME_KEY];
        NSMutableArray* thermostats = [@[] mutableCopy];
        NSArray *thermostatIds = [json objectForKey:THERMOSTATS_KEY];
        if (thermostatIds.count > 0) {
            for (NSString* thermostatId in thermostatIds) {
                [thermostats addObject:[[Thermostat alloc] initWithId:thermostatId]];
            }
        }
        self.thermostats = thermostats;
    }
    return self;
}

@end
