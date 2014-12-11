//
//  Place.m
//  Shutterbug
//
//  Created by Luiz Braga on 12/9/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import "Place.h"

@implementation Place

- (instancetype) initWithID:(NSString *)ID
                   withCity:(NSString *)city
                  withState:(NSString *)state
                withCountry:(NSString *)country
{
    self = [super init];
    
    self.ID = ID;
    self.city = city;
    self.state = state;
    self.country = country;
    
    
    return self;
}

@end
