//
//  Player.h
//  cross
//
//  Created by Calvin Ho on 8/9/15.
//  Copyright (c) 2015 Calvin Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (strong, nonatomic) NSString* Name;
@property (strong, nonatomic) NSMutableArray* Moves;

-(id)initWithName:(NSString* ) Name;
@end
