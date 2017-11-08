//
//  ThermostatTableViewCell.h
//  NestExample
//
//  Created by Alexander Gaidukov on 11/8/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Thermostat;

@interface ThermostatTableViewCell : UITableViewCell

- (void)updateWithThermostat:(Thermostat *)thermostat;

@end
