//
//  ViewController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "ViewController.h"
#import "AuthenticationManager.h"
#import "StructureManager.h"

@interface ViewController ()<StructureManagerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [StructureManager sharedInstance].delegate = self;
}

- (void)loadStructures {
    [self.activityIndicator startAnimating];
    [[StructureManager sharedInstance] loadStructuresWithCompletion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
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
        // Update tableView
    });
}

@end
