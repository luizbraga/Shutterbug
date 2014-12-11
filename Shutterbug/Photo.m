//
//  Photo.m
//  Shutterbug
//
//  Created by Luiz Braga on 12/9/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype) initWithDictionary:(NSDictionary*)dictionary{
    self = [super init];
    
    self.properties = dictionary;
    
    return self;
    
}

#pragma mark - Persistence
- (void) addPhotoToRecentList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *recents = [Photo loadRecents];
    
    // Verify if dictionary already exists in Array
    NSPredicate *aPredicate = [NSPredicate predicateWithFormat:@"%K LIKE[c] %@", @"property.id", [self.properties valueForKey:@"id"]];
    NSArray *filteredArray = [recents filteredArrayUsingPredicate:aPredicate];
    // Add to recents
    if (![filteredArray count] != 0){
        NSMutableDictionary *recent = [[NSMutableDictionary alloc] init];
        [recent setValue:self.properties forKey:@"property"];
        [recents addObject:recent];
    }
    
    [userDefaults setObject:recents forKey:@"photos"];
    [userDefaults synchronize];
}

+ (NSMutableArray*) loadRecents {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentsLoaded = [userDefaults arrayForKey:@"photos"];
    NSMutableArray *recents = [[NSMutableArray alloc]init];
    
    if (recentsLoaded != nil) {
        recents = [recentsLoaded mutableCopy];
    } else {
        recents = [[NSMutableArray alloc] init];
    }
    return recents;
}

@end


