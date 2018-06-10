//
//  VisitorViewModel.m
//  ios-interview
//
//  Created by Jian on 6/8/18.
//  Copyright © 2018 Foursquare. All rights reserved.
//

#import "VisitorViewModel.h"
#import "DMVenue.h"
#import "DMVisitor.h"
#import "Keys.h"



@interface VisitorViewModel ()

@property (nonatomic, strong) DMVenue *venue;
@property (nonatomic, strong) NSMutableArray <DMVisitor *> *arrVisitors;

@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@end



@implementation VisitorViewModel

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock
{
    self = [super init];
    
    if (self)
    {
        self.updateBlock = updateBlock;
        self.errorBlock  = errorBlock;
    }
    
    return self;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    // parse venue data
    self.venue = [DMVenue parseDictionary: dict];
    
    // sort visitors by 1. arriveTime and 2. leaveTime
    NSArray *visitors = [self sortByTime: dict[kVisitors]];
    
    // parse and add visitors to self.arrVisitor
    [self addVisitors: visitors];
    
    // dispatch to main thread
    [Dispatch dispatchAsyncToMainQueue: ^{
        
        // notify viewController to reload viewModel's data
        self.updateBlock();
    }];
}


// MARK: # fetch

-(void)fetchVisitorsFromJsonFile: (NSString * _Nonnull)fileName
{
    // dispatch to background thread
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        // load json file to data
        NSString *file = [[NSBundle mainBundle] pathForResource: fileName
                                                         ofType: @"json"];
        NSData *data = [NSData dataWithContentsOfFile: file];
        
        // serialize json data
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data
                                                             options: kNilOptions
                                                               error: &error];
        
        if (dict)
        {
            // parse and process venue and visitor data
            [self updateWithDictionary: dict[kVenue]];
        }
        else
        {
            // send serialization error through errorBlock in the main thread
            [Dispatch dispatchObject: error
                            viaBlock: self.errorBlock];
        }
    }];
}

// O(nlgn)
-(NSArray *)sortByTime: (NSArray *)array
{
    // sort visitor array by
    //   1. arriveTime, and
    NSSortDescriptor *arrivalDescriptor = [NSSortDescriptor sortDescriptorWithKey: kArriveTime
                                                                        ascending: YES];
    //   2. leaveTime
    NSSortDescriptor *leaveDescriptor   = [NSSortDescriptor sortDescriptorWithKey: kLeaveTime
                                                                        ascending: YES];
    return [array sortedArrayUsingDescriptors: @[arrivalDescriptor, leaveDescriptor]];
}

-(void)addEmptySlotFromTime: (NSUInteger)startTime
                     toTime: (NSUInteger)endTime
{
    // venue has no visitor between startTime and endTime
    DMVisitor *noVisitor = [DMVisitor parseDictionary: @{kName: @"No Visitors",
                                                         kArriveTime: @(startTime),
                                                         kLeaveTime: @(endTime)}];
    [self.arrVisitors addObject: noVisitor];
}

// O(n)
-(void)addVisitors: (NSArray *)visitors
{
    NSUInteger open = self.venue.open;
    
    for (NSDictionary *dictVisitor in visitors)
    {
        // parse visitor data
        DMVisitor *visitor = [DMVisitor parseDictionary: dictVisitor];
        
        if (open < visitor.arrive)
        {
            // no visitor
            [self addEmptySlotFromTime: open
                                toTime: visitor.arrive];
        }
        
        // add visitor
        [self.arrVisitors addObject: visitor];
        
        // update open
        open = open < visitor.leave ? visitor.leave : open;
    }
    
    if (open != self.venue.close)
    {
        // no visitor
        [self addEmptySlotFromTime: open
                            toTime: self.venue.close];
    }
}


// MARK: - # getter

-(NSMutableArray *)arrVisitors
{
    if (!_arrVisitors)
    {
        _arrVisitors = [NSMutableArray new];
    }
    
    return _arrVisitors;
}


// MARK: - # helper

-(NSString *)displayTimeFromTime: (NSUInteger)time
{
    NSUInteger secondsPerMin = 60;
    NSUInteger minsPerHour   = secondsPerMin * secondsPerMin;
    
    NSUInteger hours = time / minsPerHour % 24;
    NSUInteger mins  = (time % minsPerHour) / 60;
    
    return [NSString stringWithFormat: @"%ld:%0.2ld", (long)hours, (long)mins];
}

-(DMVisitor * _Nonnull)visitorAtIndex: (NSInteger)index
{
    DMVisitor *visitor = self.arrVisitors[index];
    return visitor;
}


// MARK: - # public API's

-(NSInteger)numberOfVisitors
{
    return self.arrVisitors.count;
}

-(NSString * _Nullable)visitorIDAtIndex: (NSInteger)index
{
    DMVisitor *visitor = [self visitorAtIndex: index];
    return visitor.identity;
}

-(NSString * _Nonnull)visitorNameAtIndex: (NSInteger)index
{
    DMVisitor *visitor = [self visitorAtIndex: index];
    return visitor.name;
}

-(NSString * _Nonnull)visitorArriveTimeAtIndex: (NSInteger)index
{
    DMVisitor *visitor = [self visitorAtIndex: index];
    return [self displayTimeFromTime: visitor.arrive];
}

-(NSString * _Nonnull)visitorLeaveTimeAtIndex: (NSInteger)index
{
    DMVisitor *visitor = [self visitorAtIndex: index];
    return [self displayTimeFromTime: visitor.leave];
}



@end
