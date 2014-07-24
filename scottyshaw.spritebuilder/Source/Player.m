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
    #define screenWidth [[CCDirector sharedDirector] viewSize].width
    #define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    self.position = ccp(screenWidth/2, screenHeight/2);
    self.physicsBody.collisionType = @"playerCollision";
}

@end
