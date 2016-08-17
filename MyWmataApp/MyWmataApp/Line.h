//
//  Line.h
//  MyWmataApp
//
//  Created by Aashima Singh on 6/21/16.
//  Copyright © 2016 Aashima Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stations.h"

@interface Line : NSObject

@property (nonatomic, strong) NSString *lineCode;
@property (nonatomic, strong) NSString *lineName;
@property (nonatomic, strong) NSArray *stationList;

@end
