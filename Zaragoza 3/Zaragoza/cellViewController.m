//
//  cellViewController.m
//  Zaragoza
//
//  Created by Amr AbulAzm on 24/06/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "cellViewController.h"
#import "AFNetworking.h"
#import "BusStopEstimates.h"

@interface cellViewController ()

@property (nonatomic, strong) NSMutableArray *estimatesArray;
@property (nonatomic, strong) NSMutableString *linesString;
@property (nonatomic, strong) NSMutableString *estimatesString;


@end

@implementation cellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Estimates";
    self.estimatesArray = [NSMutableArray array];
    self.linesString = [NSMutableString new];
    self.estimatesString = [NSMutableString new];
    [self fetchEstimates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    self.lines.text = self.linesString;
    self.estimates.text = self.estimatesString;
}

- (void)fetchEstimates
{
    NSString *busStopString = [NSString stringWithFormat:@"http://api.dndzgz.com/services/bus/%@", self.busStopID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:busStopString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSONasdasd: %@", responseObject);
        NSArray *estimatesArray = [responseObject objectForKey:@"estimates"];
        
        for (NSDictionary *estimate in estimatesArray) {
            
            NSString *estimatedTime = [estimate objectForKey:@"estimate"];
            NSString *line = [estimate objectForKey:@"line"];
            
            BusStopEstimates *busStopEstimates = [[BusStopEstimates alloc]init];
            
            busStopEstimates.timeEstimate = estimatedTime;
            busStopEstimates.line = line;
            
            [self.estimatesArray addObject: busStopEstimates];
        }
        
        [self createStrings];
        [self updateUI];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        self.lines.text = @"Problem with API, not me :)";
    }];
}

- (void)createStrings
{
    for (BusStopEstimates *busStopEstimates in self.estimatesArray)
    {
        [self.linesString appendString: [NSString stringWithFormat:@" %@", busStopEstimates.line]];
        [self.estimatesString appendString: [NSString stringWithFormat:@" %@", busStopEstimates.timeEstimate]];
    }
}



@end
