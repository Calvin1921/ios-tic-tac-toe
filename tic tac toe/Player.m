//
//  Player.m
//  cross
//
//  Created by Calvin Ho on 8/9/15.
//  Copyright (c) 2015 Calvin Ho. All rights reserved.
//

#import "Player.h"

@implementation Player
-(id)initWithName:(NSString* ) Name{
    self = [super init];
    if(self){
        self.Name = Name;
        self.Moves = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
