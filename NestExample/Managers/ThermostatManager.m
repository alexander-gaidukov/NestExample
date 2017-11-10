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

@interface ThermostatManager()
@property (nonatomic, strong) Thermostat *thermostat;
@property (nonatomic, strong) RESTClient *client;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) void (^completionBlock)(NSError *);
@property (nonatomic, assign) BOOL isUpdating;

@property (nonatomic, strong) NSURLSessionDataTask* task;
@property (nonatomic, strong) NSURLSessionDataTask* updateTask;

@end

@implementation ThermostatManager

- (void)dealloc {
    [self stopUpdatingData];
}

- (instancetype)initWithThermostat:(Thermostat *)thermostat {
    if(self = [super init]) {
        self.isUpdating = NO;
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
    
    self.isUpdating = NO;
}

- (void)startUpdatingDataWithCompletion:(void (^)(NSError *))completionBlock {
    self.isUpdating = YES;
    self.completionBlock = completionBlock;
    [self pollThermostatData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:NestAPIPollingInterval target:self selector:@selector(pollThermostatData) userInfo:nil repeats:YES];
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
        [strongSelf.thermostat updateWithJSON:json];
        if(strongSelf.delegate) {
            [strongSelf.delegate thermostatManagerDidUpdateThermostatData:self];
        }
        if(strongSelf.completionBlock) {
            strongSelf.completionBlock(nil);
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

- (void)setTargetTemperature:(NSNumber *)temperature withCompletion:(void (^)(NSError *))completionBlock {
    
    self.thermostat.targetTemperature = temperature;
    
    if (self.updateTask) { // cancel previous task
        [self.updateTask cancel];
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.updateTask = [self.client loadFromPath:[NSString stringWithFormat:@"devices/thermostats/%@/", self.thermostat.thermostatId] method:HTTPMethodPUT params:self.thermostat.updateParams success:^(NSDictionary *json) {
        if(completionBlock) {
            completionBlock(nil);
        }
        weakSelf.updateTask = nil;
    } failure:^(NSError *error) {
        if(completionBlock) {
            completionBlock(error);
        }
        weakSelf.updateTask = nil;
    }];
}

@end
