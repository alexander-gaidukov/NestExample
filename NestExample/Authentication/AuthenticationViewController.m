//
//  AuthenticationViewController.m
//  NestExample
//
//  Created by Alexandr Gaidukov on 05/11/2017.
//  Copyright © 2017 Alexandr Gaidukov. All rights reserved.
//

#import "AuthenticationViewController.h"
#import <WebKit/WebKit.h>
#import "AuthenticationManager.h"

@interface AuthenticationViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) NSURL *authenticationURL;
@property (nonatomic, strong) NSURL *redirectURL;
@property (nonatomic, weak) id<AuthenticationViewControllerDelegate> delegate;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AuthenticationViewController

- (instancetype) initWithAuthenticationURL:(NSURL *)authURL redirectURL:(NSURL *)redirectURL delegate:(id<AuthenticationViewControllerDelegate>)delegate {
    if(self = [super init]) {
        self.authenticationURL = authURL;
        self.redirectURL = redirectURL;
        self.delegate = delegate;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.webView = [WKWebView new];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
                                              ]];
    
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
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.authenticationURL];
    [self.activityIndicator startAnimating];
    [self.webView loadRequest:request];
}

- (void)didTakeCode: (NSString *)code {
    [self.activityIndicator startAnimating];
    
    [[AuthenticationManager sharedInstance] signInWithCode:code completion:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            if (success) {
                if (self.delegate) {
                    [self.delegate authenticationViewControllerDidFinish:self];
                }
            } else {
                [self showErrorMessage:error.localizedDescription];
            }
        });
    }];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.activityIndicator stopAnimating];
    [self showErrorMessage:error.localizedDescription];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if([navigationAction.request.URL.host isEqualToString: self.redirectURL.host]) {
        NSURLComponents *componens = [NSURLComponents componentsWithURL:navigationAction.request.URL resolvingAgainstBaseURL:NO];
        NSArray<NSURLQueryItem *> *queryItems = componens.queryItems;
        NSString *code;
        for (NSURLQueryItem* queryItem in queryItems) {
            if ([queryItem.name isEqualToString:@"code"]) {
                code = queryItem.value;
                break;
            }
        }
        [self didTakeCode:code];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

@end
