//
//  Structure.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 06/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONDecodable.h"

@class Thermostat;

@interface Structure : NSObject<JSONDecodable>

@property (nonatomic, strong, readonly) NSString *structureId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<Thermostat *> *thermostats;

@end
