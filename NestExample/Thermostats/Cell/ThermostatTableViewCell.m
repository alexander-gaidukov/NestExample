//
//  ThermostatTableViewCell.m
//  NestExample
//
//  Created by Alexander Gaidukov on 11/8/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ThermostatTableViewCell.h"
#import "Thermostat.h"

#define MIN_THEMPERATURE 9.0
#define MAX_THEMPERATURE 32.0

@interface ThermostatTableViewCell()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, weak) IBOutlet UILabel *currentTemperatureLabel;
@property(nonatomic, weak) IBOutlet UILabel *targetTemperatureLabel;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UISlider *temperatureSlider;
@end

@implementation ThermostatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
}

- (void)updateWithThermostat:(Thermostat *)thermostat {
    self.nameLabel.text = thermostat.name ? thermostat.name : @"---";
    self.currentTemperatureLabel.text = thermostat.currentTemperature ? [NSString stringWithFormat:@"%.1f \u00b0C", thermostat.currentTemperature.doubleValue] : @"---";
    self.targetTemperatureLabel.text = thermostat.targetTemperature ? [NSString stringWithFormat:@"%.1f \u00b0C", thermostat.targetTemperature.doubleValue] : @"---";
    self.temperatureSlider.value = thermostat.targetTemperature ? (thermostat.targetTemperature.doubleValue - MIN_THEMPERATURE) / (MAX_THEMPERATURE - MIN_THEMPERATURE) : 0.0;
}

@end
