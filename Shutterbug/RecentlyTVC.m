//
//  RecentlyTVC.m
//  Shutterbug
//
//  Created by Luiz Braga on 12/9/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "RecentlyTVC.h"
#import "ImageViewController.h"
#import "Photo.h"
#import "FlickrFetcher.h"

@interface RecentlyTVC ()

@end

@implementation RecentlyTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recentPhotos = [Photo loadRecents];
    [self.tableView reloadData];

}

- (void) viewWillAppear:(BOOL)animated {
    self.recentPhotos = [Photo loadRecents];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.recentPhotos count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"User Recent Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo = self.recentPhotos[indexPath.row];
    NSString *title = [photo valueForKeyPath:@"property.title"];
    NSString *description = [photo valueForKeyPath:@"property.description._content"];
    
    // if no title, use description as title
    // if no title, nor description, use Unknown
    if ([title isEqualToString:@""]) {
        if (![description isEqualToString:@""]) {
            title = description;
        } else {
            title = @"Unknown";
        }
        
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Recent View"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class   ]]) {
                    // Transaction to ImageViewController
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.recentPhotos[indexPath.row]];
                }
            }
        }
    }
    
}

- (void)prepareImageViewController:(ImageViewController *)ivc
                    toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:[photo valueForKey:@"property"] format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:@"property.title"];
}


@end
