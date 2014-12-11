//
//  FlickrPhotosTVC.m
//  Shutterbug
//
//  Created by Sameh Fakhouri on 11/24/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "Photo.h"

@interface FlickrPhotosTVC ()

@end

@implementation FlickrPhotosTVC

- (void)setPhotos:(NSArray *)photos
{
    // Converto to an array of Photo objects
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in photos) {
        Photo *photo = [[Photo alloc]initWithDictionary:dict];
        [temp addObject:photo];
    }
    _photos = temp;
    
    [self.tableView reloadData];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photoProperties = [self.photos objectAtIndex:indexPath.row];
    NSDictionary *photo = photoProperties.properties;
    NSString *title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSString *description = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];

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
\
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    
    
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class   ]]) {
                    Photo *photoProperties = [self.photos objectAtIndex:indexPath.row];
                    // Add photo in the Recent List
                    [photoProperties addPhotoToRecentList];
                    // Transaction to ImageViewController
                    [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:photoProperties.properties];
                }
            }
        }
    }
    
}

- (void)prepareImageViewController:(ImageViewController *)ivc
                    toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}






@end
