//
//  DataController.m
//  massageToday
//
//  Created by Krishna Kunapuli on 8/10/13.
//  Copyright (c) 2013 Krishna Kunapuli. All rights reserved.
//

#import "DataController.h"
#import "Profile.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"



@interface DataController ()
@property (nonatomic, copy, readwrite) NSMutableArray *list;
@property (nonatomic, copy, readwrite) NSString *postalCode;
@end


@implementation DataController
@synthesize list;
@synthesize postalCode;
//local variables for reverse geo coding
CLLocationManager *locationManager;
CLGeocoder *geocoder;
CLPlacemark *placemark;


- (id)init {
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];    }
    return self;
}

// Custom set accessor to ensure the new list is mutable.
- (void)setList:(NSMutableArray *)newList {
    if (list != newList) {
        list = [newList mutableCopy];
    }
}

// Accessor methods for list.
- (unsigned)countOfList {
    return [list count];
}

- (Profile *)objectInListAtIndex:(unsigned)theIndex {
    return [list objectAtIndex:theIndex];
}

-(NSInteger)searchUsers
{
    NSLog(@"Calling search with postalCode%@",postalCode);
    NSString *zip = [NSString stringWithFormat:@"zip=%@", @"94102"];
    NSMutableArray *profileList = [[NSMutableArray alloc] init];
    NSString* zipEncoded = [zip stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* profileURL = [NSString stringWithFormat:@"http://localhost:9000/data/searchresults?%@", zipEncoded];
	NSError* error = nil;
	NSURLResponse* response = nil;
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
	NSURL* URL = [NSURL URLWithString:profileURL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setURL:URL];
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[request setTimeoutInterval:30];
	NSLog(@"Requesting URL %@", profileURL);
	NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (error)
	{
		NSLog(@"Error performing request %@", profileURL);
		return 0;
	}
    
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"Here is what we got %@", jsonString);
	
	NSDictionary *results = [jsonString objectFromJSONString];
    // Search for year to match
	for (NSDictionary *jsonProfile in results)
	{
        Profile *profile = [[Profile alloc] init];
		NSString *name = [jsonProfile objectForKey:@"name"];
        profile.name = name;
        NSString *phone = [jsonProfile objectForKey:@"phone"];
        profile.phone = phone;
        NSString *licence = [jsonProfile objectForKey:@"licence"];
        profile.license = licence;
        NSString *insurance = [jsonProfile objectForKey:@"insurance"];
        profile.insurance = insurance;
        NSString *photoURL = [jsonProfile objectForKey:@"photo"];
        profile.photoURL = photoURL;
        [profileList addObject:profile];
	}
    
	self.list = profileList;
	return 0;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;    
    if (currentLocation != nil) {
        NSString* longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString* latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"longitude, latitude: %@ %@", longitude, latitude);
        // Stop Location Manager
        [locationManager stopUpdatingLocation];
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                self.postalCode = placemark.postalCode;
                NSLog(@"Zip Code is %@", postalCode);               
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
}

@end
