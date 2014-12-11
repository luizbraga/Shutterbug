//
//  Photo.h
//  Shutterbug
//
//  Created by Luiz Braga on 12/9/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSDictionary *properties; // of a flickr photo

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
+ (NSMutableArray*) loadRecents;
- (void) addPhotoToRecentList;

@end
