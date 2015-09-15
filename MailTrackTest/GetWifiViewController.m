//
//  GetWifiViewController.m
//  MailTrackTest
//
//  Created by Javi Alzueta on 15/9/15.
//  Copyright (c) 2015 Javier Alzueta. All rights reserved.
//

#import "GetWifiViewController.h"
@import SystemConfiguration.CaptiveNetwork;

#define SSID_KEY @"SSID"
#define EMBED_HTML @"<html> <head></head> <body> <script> function getWifiSSID(){ return \"%@\"; } document.write(getWifiSSID()); </script> </body> </html>"
#define NO_SSID @"Not active Wi-Fi detected"
#define SSID_FORMAT_TEXT @"Active Wi-Fi: %@"

@interface GetWifiViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GetWifiViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MailTrack Test";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configNavBar];
    [self loadHtml];
}

#pragma mark - Utils

- (void) configNavBar{
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshBarButtonItem;
}

- (void) loadHtml {
    NSString *ssid = [self currentWifiSSID];
    NSString *embedHTML = [NSString stringWithFormat:EMBED_HTML, ssid];
    self.webView.userInteractionEnabled = NO;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString: embedHTML baseURL: nil];
}

- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = NO_SSID;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[SSID_KEY]) {
            ssid = [NSString stringWithFormat:SSID_FORMAT_TEXT, info[SSID_KEY]];
        }
    }
    return ssid;
}

#pragma mark - Actions

- (void) refresh: (id) sender{
    [self loadHtml];
}

@end
