//
//  ViewController.m
//  Zaragoza
//
//  Created by Amr AbulAzm on 23/06/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "BusStop.h"
#import "BusStopEstimates.h"
#import "BusStopTableViewCell.h"
#import "cellViewController.h"
#import "cellViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *stopsArray;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Zaragoza Bus Info";
    self.stopsArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self fetchData];
//    [self testTable];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusStopTableViewCell" bundle:nil] forCellReuseIdentifier:BusStopTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) fetchData
{
    [self.manager GET:@"http://api.dndzgz.com/services/bus" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *locationsArray = [responseObject objectForKey:@"locations"];
        
        for (NSDictionary *location in locationsArray) {
            NSString *stopId = [location objectForKey:@"id"];
            NSString *stopTitle = [location objectForKey:@"title"];
            CLLocationDegrees latitude = [[location objectForKey:@"lat"] doubleValue];
            CLLocationDegrees longitude = [[location objectForKey:@"lon"] doubleValue];
            
            BusStop *stop = [[BusStop alloc] init];

            stop.name = stopTitle;
            stop.number = stopId;
            stop.latitude = latitude;
            stop.longitude = longitude;

            [self.stopsArray addObject: stop];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


#pragma mark - TableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = [self.stopsArray count];
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusStop *stop = [self.stopsArray objectAtIndex:indexPath.row];
    NSString *longitude = [[NSNumber numberWithDouble:stop.longitude] stringValue];
    NSString *latitude = [[NSNumber numberWithDouble:stop.latitude] stringValue];
    
    NSString *baseURL = @"http://maps.googleapis.com/maps/api/staticmap?center=";
    NSString *URLQuery = [NSString stringWithFormat:@"center=%@,%@&zoom=15&size=200x120&sensor=true", longitude,latitude];
    
    NSString *stringMap = [NSString stringWithFormat:@"%@%@", baseURL, URLQuery];
    NSLog(@"Stringcompiled: %@", stringMap);
    stringMap = [stringMap stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]; 
    
    NSURL *url = [NSURL URLWithString:stringMap];

    BusStopTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BusStopTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.busId.text = stop.number;
    cell.name.text = stop.name;
    
    
    //load Async
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    cell.imageView.image = image;

    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusStop *stop = [self.stopsArray objectAtIndex:indexPath.row];
    
    UIStoryboard *cellStoryboard = [UIStoryboard storyboardWithName:@"CellStoryboard" bundle:nil];
    cellViewController *cellViewController = [cellStoryboard instantiateViewControllerWithIdentifier:@"cellViewController"];
    cellViewController.busStopID = stop.number;
    [self.navigationController pushViewController:cellViewController animated:YES];
}

#pragma mark - Tests/ToBeDeleted


- (void)testTable
{
    BusStop *one = [[BusStop alloc] init];
    BusStop *two = [[BusStop alloc] init];
    BusStop *three = [[BusStop alloc] init];
    
    
    one.number = @"1";
    one.name = @"amr";
    two.number = @"2";
    two.name = @"amr2";
    three.number = @"1";
    three.name = @"amr3";
    
    [self.stopsArray addObject:one];
    [self.stopsArray addObject:two];
    [self.stopsArray addObject:three];
}

@end
