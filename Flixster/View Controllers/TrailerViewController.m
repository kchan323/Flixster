//
//  TrailerViewController.m
//  Flixster
//
//  Created by kchan23 on 6/28/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSArray *results;
@property (weak, nonatomic) IBOutlet WKWebView *webkitView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = [self.movie[@"id"] stringValue];
    NSString *postURLString = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US";
    NSString *halfURLString = [baseURLString stringByAppendingString:movieID];
    NSString *fullURLString = [halfURLString stringByAppendingString:postURLString];
    
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            self.results = dataDictionary[@"results"];
            NSString *baseURLString = @"https://www.youtube.com/watch?v=";
            NSString *key = self.results[0][@"key"];
            NSString *trailerURLString = [baseURLString stringByAppendingString:key];

            // Convert the url String to a NSURL object.
            NSURL *url = [NSURL URLWithString:trailerURLString];
            
            // Place the URL in a URL Request.
            NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval:10.0];
            // Load Request into WebView.
            [self.webkitView loadRequest:request];
        
        }
    }];
    [task resume];
}

- (IBAction)touchCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
