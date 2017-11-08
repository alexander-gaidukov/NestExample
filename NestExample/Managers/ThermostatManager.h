//
//  ThermostatManager.h
//  NestExample
//
//  Created by Alexandr Gaidukov on 08/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThermostatManager;
@class Thermostat;

@protocol ThermostatManagerDelegate<NSObject>
- (void)thermostatManagerDidUpdateThermostatData:(ThermostatManager *)thermostatManager;
@end

@interface ThermostatManager : NSObject
@property (nonatomic, strong, readonly) Thermostat *thermostat;
@property (nonatomic, weak) id<ThermostatManagerDelegate> delegate;
- (instancetype)initWithThermostat:(Thermostat *)thermostat;
- (void)startUpdatingDataWithCompletion:(void (^)(NSError *error))completionBlock;
- (void)stopUpdatingData;
@end
