//
//  BusStop.h
//  Zaragoza
//
//  Created by Amr AbulAzm on 23/06/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BusStop : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;

@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) CLLocationDegrees latitude;

@property (nonatomic, strong) UIImage *mapImage;


@end
