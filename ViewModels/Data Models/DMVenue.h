//
//  DMVenue.h
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "DMBase.h"



@interface DMVenue : DMBase

@property (nonatomic, readonly) NSUInteger open;
@property (nonatomic, readonly) NSUInteger close;


+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;


@end
