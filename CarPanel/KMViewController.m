//
//  KMViewController.m
//  CarPanel
//
//  Created by KoujiMiura on 2012/12/22.
//  Copyright (c) 2012年 KoujiMiura. All rights reserved.
//

#import "KMViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface KMViewController ()

@end

@implementation KMViewController
UIWebView   *_webViewMeter;
UIWebView   *_webViewMap;
MKMapView   *mapView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect bounds = [[UIScreen mainScreen]bounds];
//    _webView = [[UIWebView alloc]initWithFrame:bounds];
    _webViewMeter = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.height/2.5, bounds.size.width)];
    [self.view addSubview:_webViewMeter];

    _webViewMap = [[UIWebView alloc]initWithFrame:CGRectMake(_webViewMeter.bounds.size.width,
                                                            0,
                                                            bounds.size.height-_webViewMeter.bounds.size.width,
                                                            bounds.size.width)];
#if 1
    [self.view addSubview:_webViewMap];
#else
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(_webViewMeter.bounds.size.width,
                                                          0,
                                                          bounds.size.height-_webViewMeter.bounds.size.width,
                                                          bounds.size.width)];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
#endif
    
    [self _updateHTMLContent];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
	MKCoordinateRegion zoom = mapView.region;
	zoom.span.latitudeDelta = 0.005;
	zoom.span.longitudeDelta = 0.005;
	[mapView setRegion:zoom animated:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)_updateHTMLContent
{
    if ((!_webViewMeter)||(!_webViewMap)) {
        return;
    }

    NSString *pathMeter = [[NSBundle mainBundle] pathForResource:@"meter" ofType:@"html"];
    [_webViewMeter loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathMeter]]];
#if 1
    NSString *pathMap = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    [_webViewMap loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathMap]]];
#endif
    return;
}

@end
