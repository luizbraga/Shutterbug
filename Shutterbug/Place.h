//
//  Place.h
//  Shutterbug
//
//  Created by Luiz Braga on 12/9/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;

- (instancetype) initWithID:(NSString *)ID
                   withCity:(NSString *)city
                  withState:(NSString *)state
                withCountry:(NSString *)country;

@end
