//
//  ThermostatManager.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 08/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ThermostatManager.h"
#import "Thermostat.h"
#import "RESTClient.h"
#import "Constants.h"

#define POLL_INTERVAL 30.0f

@interface ThermostatManager()
@property (nonatomic, strong) Thermostat *thermostat;
@property (nonatomic, strong) RESTClient *client;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) void (^completionBlock)(NSError *);

@property (nonatomic, strong) NSURLSessionDataTask* task;

@end

@implementation ThermostatManager

- (void)dealloc {
    [self stopUpdatingData];
}

- (instancetype)initWithThermostat:(Thermostat *)thermostat {
    if(self = [super init]) {
        self.thermostat = thermostat;
        self.client = [[RESTClient alloc] initWithBaseURL:[NSURL URLWithString:NestAPIEndpoint]];
    }
    return self;
}

- (void)stopUpdatingData {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (self.completionBlock){
        self.completionBlock = nil;
    }
}

- (void)startUpdatingDataWithCompletion:(void (^)(NSError *))completionBlock {
    self.completionBlock = completionBlock;
    [self pollThermostatData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:POLL_INTERVAL target:self selector:@selector(pollThermostatData) userInfo:nil repeats:YES];
    });
}

- (void)pollThermostatData {
    
    if (self.task) { // loading is in progress
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.task = [self.client loadFromPath:[NSString stringWithFormat:@"devices/thermostats/%@/", self.thermostat.thermostatId] method:HTTPMethodGET params:[NSDictionary dictionary] success:^(NSDictionary *json) {
        if(!weakSelf) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.thermostat updateWith:json];
        if(strongSelf.delegate) {
            [strongSelf.delegate thermostatManagerDidUpdateThermostatData:self];
        }
        strongSelf.task = nil;
    } failure:^(NSError *error) {
        if(!weakSelf) {
            return;
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.completionBlock) {
            strongSelf.completionBlock(error);
        }
        strongSelf.task = nil;
    }];
}

@end
