//
//  Recap.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Recap.h"

@implementation Recap

- (void)startGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

- (void)returnToMenu {
    CCScene *menuScene = [CCBReader loadAsScene:@"MainScene"];
    //    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

@end
