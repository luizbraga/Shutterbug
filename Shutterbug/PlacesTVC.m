//
//  PlacesTVC.m
//  Shutterbug
//
//  Created by Luiz Braga on 12/6/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "PlacesTVC.h"
#import "FlickrFetcher.h"
#import "Place.h"
#import "JustPostedFlickrPhotosTVC.h"

@interface PlacesTVC ()

@end

@implementation PlacesTVC

# pragma mark - Initialization and update
- (void)setPlaces:(NSArray *)places
{
    NSMutableArray *tempPlace = [[NSMutableArray alloc]init];
    // Create an array of Place objects to make it easier to read and implement
    for (NSDictionary *dict in places){
        Place *place = [[Place alloc]initWithID:[dict valueForKeyPath:FLICKR_PLACE_ID]
                                       withCity:[[[dict valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","] objectAtIndex:0]
                                      withState:[[[dict valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","] objectAtIndex:1]
                                    withCountry:[[[dict valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","] lastObject]];
        
        [tempPlace addObject:place];
    }
    _places = tempPlace;
    [self updateCountries];
    [self updateRows];
    [self.tableView reloadData];
}

- (void) updateCountries {
    NSMutableArray *countries = [[NSMutableArray alloc]init];
    
    for (Place *place in self.places) {
        [countries addObject:place.country];
    }
    // Remove duplicates
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    for (NSString* country in countries){
        if (![temp containsObject:country]) {
            [temp addObject:country];
        }
    }
    self.countries = [temp sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void) updateRows {
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];

    for (NSString *country in self.countries){
        NSMutableArray *tempRows = [[NSMutableArray alloc]init];
        for (Place *place in self.places){
            if ([place.country isEqualToString:country]) {
                [tempRows addObject:place];
            }
        }
        [temp setObject:tempRows forKey:country];
    }
    
    self.sectionWithRows = temp;
}

#pragma mark - Tools and Moduling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Place*) findPlaceUsingIndexPath:(NSIndexPath*) indexPath{
    NSArray *placeArray = [self.sectionWithRows objectForKey:[self.countries objectAtIndex:indexPath.section]];
    return [placeArray objectAtIndex:indexPath.row];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.countries count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.countries objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //[[self.sectionWithRows objectForKey:[self.countries objectAtIndex:section]] count];

    return [[self.sectionWithRows objectForKey:[self.countries objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //Place *place = self.places[indexPath.row];
    
    Place *place = [self findPlaceUsingIndexPath:indexPath];
        
        
    cell.textLabel.text = place.city;
    cell.detailTextLabel.text = place.state;
    
    
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Place id"]) {
                if ([segue.destinationViewController isKindOfClass:[JustPostedFlickrPhotosTVC class   ]]) {
                //    [self preparePlaceViewController:segue.destinationViewController withPlaceID: [self findPlaceUsingIndexPath:indexPath].ID];
                    JustPostedFlickrPhotosTVC *photoVC = (JustPostedFlickrPhotosTVC *)segue.destinationViewController;
                    photoVC.placeId = [self findPlaceUsingIndexPath:indexPath].ID;
                }
            }
        }
    }
}


@end
