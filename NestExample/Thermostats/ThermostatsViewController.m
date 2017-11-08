//
//  ThermostatsViewController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 08/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ThermostatsViewController.h"
#import "Structure.h"
#import "ThermostatManager.h"

@interface ThermostatsViewController ()

@property(nonatomic, strong) Structure *structure;
@property(nonatomic, strong) ThermostatManager *thermostatManager;

@end

@implementation ThermostatsViewController

- (instancetype)initWithStructure:(Structure *)structure {
    if (self = [super init]) {
        self.structure = structure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thermostatManager = [[ThermostatManager alloc] initWithThermostat:self.structure.thermostats.firstObject];
    [self.thermostatManager startUpdatingDataWithCompletion:nil];
}

@end
