//
//  DMVisitor.h
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "DMBase.h"



@interface DMVisitor : DMBase

@property (nonatomic, readonly) NSUInteger arrive;
@property (nonatomic, readonly) NSUInteger leave;


+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;

@end
