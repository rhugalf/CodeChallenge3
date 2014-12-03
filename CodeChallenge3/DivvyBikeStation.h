//
//  DivvyBikeStation.h
//  CodeChallenge3
//
//  Created by GLB-MXM0004 on 01/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DivvyBikeStation : NSObject
@property NSString *name;
@property NSString *availableBikes;
@property NSString *latitude;
@property NSString *longitude;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
