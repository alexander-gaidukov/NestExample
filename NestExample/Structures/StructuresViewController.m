//
//  ViewController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "StructuresViewController.h"
#import "AuthenticationManager.h"
#import "StructureManager.h"
#import "StructureTableViewCell.h"

@interface StructuresViewController ()<StructureManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *structuresTableView;

@end

@implementation StructuresViewController

- (void)loadView {
    [super loadView];
    //TableView
    self.structuresTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.structuresTableView];
    self.structuresTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.structuresTableView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
                                              [self.structuresTableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor],
                                              [self.structuresTableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.structuresTableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
                                              ]];
    [self configureTableView];
    // Activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor lightGrayColor];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
                                              [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
                                              ]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Structures";
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    self.structuresTableView.dataSource = self;
    self.structuresTableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [StructureManager sharedInstance].delegate = self;
}

- (void)configureTableView {
    self.structuresTableView.layoutMargins = UIEdgeInsetsZero;
    self.structuresTableView.separatorInset = UIEdgeInsetsZero;
    self.structuresTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.structuresTableView registerClass:[StructureTableViewCell class] forCellReuseIdentifier:NSStringFromClass([StructureTableViewCell class])];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadStructures) forControlEvents:UIControlEventValueChanged];
    [self.structuresTableView addSubview:self.refreshControl];
}

- (void)loadStructures {
    if (![self.refreshControl isRefreshing]) {
        [self.activityIndicator startAnimating];
    }
    
    [[StructureManager sharedInstance] loadStructuresWithCompletion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
        });
    }];
}

- (void)logout {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Nest Example" message:@"Do you really want to log out?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[AuthenticationManager sharedInstance] logout];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - StructureManagerDelegate
- (void)structureManagerDidUpdateData:(StructureManager *)structureManager {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.structuresTableView reloadData];
    });
}

#pragma matk - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [StructureManager sharedInstance].structures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StructureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([StructureTableViewCell class]) forIndexPath:indexPath];
    [cell configureWithStructure: [[StructureManager sharedInstance].structures objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

@end
