//
//  DMVenue.m
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "DMVenue.h"
#import "DMBase_Protected.h"
#import "Keys.h"



@interface DMVenue ()

@property (nonatomic, assign) NSUInteger open;
@property (nonatomic, assign) NSUInteger close;

@end



@implementation DMVenue

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMVenue *venue = [DMVenue new];
    [venue updateWithDictionary: dict];
    return venue;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    [super updateWithDictionary: dict];
    
    self.open  = [dict[kOpenTime]  integerValue];
    self.close = [dict[kCloseTime] integerValue];
}


@end
