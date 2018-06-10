//
//  DMVisitor.m
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "DMVisitor.h"
#import "DMBase_Protected.h"
#import "Keys.h"



@interface DMVisitor ()

@property (nonatomic, assign) NSUInteger arrive;
@property (nonatomic, assign) NSUInteger leave;

@end



@implementation DMVisitor

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMVisitor *visitor = [DMVisitor new];
    [visitor updateWithDictionary: dict];
    return visitor;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    [super updateWithDictionary: dict];
    
    self.arrive = [dict[kArriveTime] unsignedIntegerValue];
    self.leave  = [dict[kLeaveTime]  unsignedIntegerValue];
}



@end
