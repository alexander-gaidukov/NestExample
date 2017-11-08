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
#import "ThermostatTableViewCell.h"
#import "UIViewController+Nest.h"

@interface ThermostatsViewController ()<UITableViewDataSource, UITableViewDelegate, ThermostatManagerDelegate>

@property(nonatomic, strong) Structure *structure;
@property(nonatomic, strong) UITableView* thermostatsTableView;
@property(nonatomic, strong) NSMutableArray<ThermostatManager *> *managers;
@end

@implementation ThermostatsViewController

- (instancetype)initWithStructure:(Structure *)structure {
    if (self = [super init]) {
        self.structure = structure;
        self.managers = [NSMutableArray array];
        for (Thermostat *thermostat in structure.thermostats) {
            ThermostatManager *manager = [[ThermostatManager alloc] initWithThermostat:thermostat];
            manager.delegate = self;
            [self.managers addObject: manager];
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = UIColor.lightGrayColor;
    self.thermostatsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.thermostatsTableView];
    self.thermostatsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.thermostatsTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
                                              [self.thermostatsTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor],
                                              [self.thermostatsTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.thermostatsTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
                                              ]];
    [self configureTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thermostatsTableView.dataSource = self;
    self.thermostatsTableView.delegate = self;
}

- (void)configureTableView {
    self.thermostatsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.thermostatsTableView.backgroundColor = [UIColor clearColor];
    self.thermostatsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.thermostatsTableView.allowsSelection = NO;
    [self.thermostatsTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ThermostatTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ThermostatTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.managers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThermostatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ThermostatTableViewCell class]) forIndexPath:indexPath];
    ThermostatManager *manager = [self.managers objectAtIndex:indexPath.row];
    [cell updateWithThermostat: manager.thermostat];
    if (!manager.isUpdating) {
        [manager startUpdatingDataWithCompletion:^(NSError *error) {
            if (error) {
                [self showErrorAlertWithMessage:error.localizedDescription];
            }
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155.0;
}

#pragma mark - ThermostatManagerDelegate
- (void)thermostatManagerDidUpdateThermostatData:(ThermostatManager *)thermostatManager {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger index = [self.managers indexOfObject:thermostatManager];
        if (index) {
            ThermostatTableViewCell *cell = [self.thermostatsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (cell) {
                [cell updateWithThermostat: thermostatManager.thermostat];
            }
        }
    });
    
}

@end
