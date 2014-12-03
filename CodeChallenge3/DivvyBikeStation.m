//
//  DivvyBikeStation.m
//  CodeChallenge3
//
//  Created by GLB-MXM0004 on 01/12/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "DivvyBikeStation.h"

@implementation DivvyBikeStation

-(instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [self init];
    
    if(self){
        self.name = [dictionary objectForKey:@"stAddress1"];
        self.availableBikes = [dictionary objectForKey:@"availableBikes"];
        self.latitude = [dictionary objectForKey:@"latitude"];
        self.longitude = [dictionary objectForKey:@"longitude"];
    }
    
    return self;
}

@end
