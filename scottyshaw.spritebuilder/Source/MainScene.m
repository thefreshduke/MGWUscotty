//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
    CCPhysicsNode *_player; //keep this to allow tilt to move player on title screen
}

- (void)startGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
