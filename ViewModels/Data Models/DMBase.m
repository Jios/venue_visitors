//
//  DMBase.m
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "DMBase.h"
#import "Keys.h"



@interface DMBase ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identity;

@end



@implementation DMBase

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    self.name     = dict[kName];
    self.identity = dict[kID];
}


@end
