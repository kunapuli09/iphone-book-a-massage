//
//  DataController.h
//  massageToday
//
//  Created by Krishna Kunapuli on 8/10/13.
//  Copyright (c) 2013 Krishna Kunapuli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class Profile;

@interface DataController : NSObject <CLLocationManagerDelegate>
- (unsigned)countOfList;
- (Profile *)objectInListAtIndex:(unsigned)theIndex;
-(NSInteger)searchUsers;

@end
