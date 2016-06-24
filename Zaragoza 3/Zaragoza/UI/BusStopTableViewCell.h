//
//  AppDelegate.h
//  Zaragoza
//
//  Created by Amr AbulAzm on 23/06/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *BusStopTableViewCellIdentifier = @"BusStopTableViewCellIdentifier";

@interface BusStopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *busId;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
