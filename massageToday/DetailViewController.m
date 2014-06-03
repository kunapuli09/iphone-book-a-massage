//
//  DetailViewController.m
//  massageToday
//
//  Created by Krishna Kunapuli on 8/10/13.
//  Copyright (c) 2013 Krishna Kunapuli. All rights reserved.
//

#import "DetailViewController.h"
#import "Profile.h"

@implementation DetailViewController

@synthesize profile;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Details", @"Detail view navigation title");
    //self.navigationItem.leftBarButtonItem = self.;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // There are three sections, for date, genre, and characters, in that order.
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	/*
	 The number of rows varies by section.
	 */
    NSInteger rows = 0;
    switch (section) {
        case 0:
        case 1:
            // For genre and date there is just one row.
            rows = 1;
            break;
        case 2:
            // For the characters section, there are as many rows as there are characters.
            rows = 1;
            break;
        case 3:
            rows = 1;
            break;
        default:
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set the text in the cell for the section/row.
    
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            cellText = profile.phone;
            cell.textLabel.text = cellText;
            break;
        case 1:
            cellText = profile.license;
            cell.textLabel.text = cellText;
            break;
        case 2:
            cell.textLabel.text = profile.license;
            break;
        case 3:
            [cell.imageView setImageWithURL:[NSURL URLWithString:profile.photoURL]
                           placeholderImage:[UIImage imageNamed:profile.photoURL]];
        default:
            break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark Section header titles

/*
 HIG note: In this case, since the content of each section is obvious, there's probably no need to provide a title, but the code is useful for illustration.
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Phone", @"Date section title");
            break;
        case 1:
            title = NSLocalizedString(@"License", @"Genre section title");
            break;
        case 2:
            title = NSLocalizedString(@"Insurance", @"Main Characters section title");
            break;
        case 3:
            title = NSLocalizedString(@"Therapist Photo", @"Main Characters section title");
            break;
        default:
            break;
    }
    return title;
}
@end
