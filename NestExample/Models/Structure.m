//
//  Structure.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "Structure.h"
#import "Thermostat.h"

@interface Structure()
@property (nonatomic, strong) NSString *structureId;
@end

@implementation Structure

- (instancetype)initWith:(NSDictionary *)json {
    if (self = [super init]) {
        self.structureId = [json objectForKey:@"structure_id"];
        self.name = [json objectForKey:@"name"];
        NSMutableArray* thermostats = [@[] mutableCopy];
        NSArray *thermostatIds = [json objectForKey:@"thermostats"];
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
