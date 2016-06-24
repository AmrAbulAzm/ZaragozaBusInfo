//
//  cellViewController.h
//  Zaragoza
//
//  Created by Amr AbulAzm on 24/06/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cellViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lines;
@property (weak, nonatomic) IBOutlet UILabel *estimates;

@property (nonatomic, strong) NSString *busStopID;

@end
