//
//  Player.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Player.h"
#import "Gameplay.h"

@implementation Player

- (void)didLoadFromCCB
{
    self.position = ccp(115, 250);
//    self.zOrder = DrawingOrderHero;
    self.physicsBody.collisionType = @"player";
}

@end
