//
//  Profile.h
//  massageToday
//
//  Created by Krishna Kunapuli on 8/10/13.
//  Copyright (c) 2013 Krishna Kunapuli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImageView+WebCache.h>

@interface Profile : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *license;
@property (nonatomic, strong) NSString *insurance;
@property (nonatomic, strong) NSString *photoURL;
@end
