//
//  ThermostatTableViewCell.h
//  NestExample
//
//  Created by Alexander Gaidukov on 11/8/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thermostat;
@class ThermostatTableViewCell;

@protocol ThermostatTableViewCellDelegate<NSObject>
- (void)thermostatTableViewCell:(ThermostatTableViewCell *)cell didSetTargetTemperature:(NSNumber *)temperature;
@end

@interface ThermostatTableViewCell : UITableViewCell

@property(nonatomic, weak) id<ThermostatTableViewCellDelegate> delegate;

- (void)updateWithThermostat:(Thermostat *)thermostat;

@end
