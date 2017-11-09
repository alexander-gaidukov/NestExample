//
//  ThermostatTableViewCell.m
//  NestExample
//
//  Created by Alexander Gaidukov on 11/8/17.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ThermostatTableViewCell.h"
#import "Thermostat.h"

#define MIN_TEMPERATURE 9.0
#define MAX_TEMPERATURE 32.0

@interface ThermostatTableViewCell()
@property(nonatomic, weak) IBOutlet UIView *containerView;
@property(nonatomic, weak) IBOutlet UILabel *currentTemperatureLabel;
@property(nonatomic, weak) IBOutlet UILabel *targetTemperatureLabel;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UISlider *temperatureSlider;

@property(nonatomic, assign) BOOL isSliding;

@end

@implementation ThermostatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 6.0;
    self.isSliding = NO;
    
    [self.temperatureSlider addTarget:self action:@selector(slidingDidBegin) forControlEvents:UIControlEventTouchDown];
    [self.temperatureSlider addTarget:self action:@selector(slidingDidEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.temperatureSlider addTarget:self action:@selector(slidingInProgress) forControlEvents:UIControlEventValueChanged];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.isSliding = NO;
}

- (void)updateWithThermostat:(Thermostat *)thermostat {
    self.nameLabel.text = thermostat.name ? thermostat.name : @"---";
    self.currentTemperatureLabel.text = thermostat.currentTemperature ? [NSString stringWithFormat:@"%.1f \u00b0C", thermostat.currentTemperature.doubleValue] : @"---";
    if (!self.isSliding) {
        [self showTargetTemperature:thermostat.targetTemperature];
    }
    
}

- (NSNumber *)temperatureFromSlider {
    double tTemperature = self.temperatureSlider.value * (MAX_TEMPERATURE - MIN_TEMPERATURE) + MIN_TEMPERATURE;
    
    return [NSNumber numberWithDouble:round(tTemperature * 2.0) / 2.0];
}

- (void)slidingDidBegin {
    self.isSliding = YES;
}

- (void)slidingDidEnd {
    self.isSliding = NO;
    NSNumber *temperature = [self temperatureFromSlider];
    [self showTargetTemperature: temperature];
    if (self.delegate) {
        [self.delegate thermostatTableViewCell:self didSetTargetTemperature:temperature];
    }
}

- (void)slidingInProgress {
    [self showTargetTemperature:[self temperatureFromSlider]];
}

- (void)showTargetTemperature: (NSNumber *)temperature {
    self.targetTemperatureLabel.text = temperature ? [NSString stringWithFormat:@"%.1f \u00b0C", temperature.doubleValue] : @"---";
    if (!self.isSliding) {
        self.temperatureSlider.value = temperature ? (temperature.doubleValue - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE) : 0.0;
    }
}

@end
