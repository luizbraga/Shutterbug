//
//  PlacesTVC.h
//  Shutterbug
//
//  Created by Luiz Braga on 12/6/14.
//  Copyright (c) 2014 Lehman College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTVC : UITableViewController

@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSDictionary *sectionWithRows;

@end
