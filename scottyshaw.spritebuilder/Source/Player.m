//
//  Player.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Player.h"

@implementation Player

- (void)didLoadFromCCB
{
//    self.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    self.physicsBody.collisionType = @"playerCollision";
}

@end
