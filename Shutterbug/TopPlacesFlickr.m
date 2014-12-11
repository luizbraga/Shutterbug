//
//  TopPlacesFlickr.m
//  Shutterbug
//
//  Created by Luiz Braga on 12/7/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "TopPlacesFlickr.h"
#import "FlickrFetcher.h"

@interface TopPlacesFlickr ()

@end

@implementation TopPlacesFlickr


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPlaces];
}

- (IBAction)fetchPlaces
{
    [self.refreshControl beginRefreshing];
    
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization
                                             JSONObjectWithData:jsonResults
                                             options:0
                                             error:NULL];
        
        NSLog(@"Flickr Result = %@", propertyListResults);
        NSArray *topPlaces = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.places = topPlaces;
            NSLog(@"Finished");
        });
        
    });
    
    
    
    
}

@end
