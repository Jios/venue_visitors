//
//  VisitorViewModel.h
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"
#import "SelfMacros.h"
#import "Dispatch.h"



@interface VisitorViewModel : NSObject

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock;

/*!
 @brief Load venue and visitor data from json file
 @param fileName File name of a json file
 @discussion The algorithm is to first sort the array of visitor dictionaries by arriveTime and leaveTime.  It iterates through the sorted dictionary-array and inserts parsed visitor and idle slot objects into array, arrVisitors.  It takes O(nlgn) to sort visitor array and O(n) to insert visitor objects.
 */
-(void)fetchVisitorsFromJsonFile: (NSString * _Nonnull)fileName;

-(NSInteger)numberOfVisitors;

-(NSString * _Nullable)visitorIDAtIndex: (NSInteger)index;
-(NSString * _Nonnull)visitorNameAtIndex: (NSInteger)index;
-(NSString * _Nonnull)visitorArriveTimeAtIndex: (NSInteger)index;
-(NSString * _Nonnull)visitorLeaveTimeAtIndex: (NSInteger)index;



@end
