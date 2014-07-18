//
//  Gameplay.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode *_player;
    CCPhysicsNode *_enemy;
}

//- (id) init
//{
//    if ((self = [super init])) {
//        CGSize winSize = [CCDirector sharedDirector].winSize;
//        CCSprite *player = [CCSprite spriteWithFile:@"player.png"];
//        player.position = ccp(player.contentSize.width/2, winSize.height/2);
//        [self addChild:player];
//    }
//    return self;
//}

//- (void) addMonster {
//    
//    CCSprite * monster = [CCSprite spriteWithFile:@"1-up_Mushroom.png"];
//    
//    // Determine where to spawn the monster along the Y axis
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    int minY = monster.contentSize.height / 2;
//    int maxY = winSize.height - monster.contentSize.height/2;
//    int rangeY = maxY - minY;
//    int actualY = (arc4random() % rangeY) + minY;
//    
//    // Create the monster slightly off-screen along the right edge,
//    // and along a random position along the Y axis as calculated above
//    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
//    [self addChild:monster];
//    
//    // Determine speed of the monster
//    int minDuration = 2.0;
//    int maxDuration = 4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int actualDuration = (arc4random() % rangeDuration) + minDuration;
//    
//    // Create the actions
//    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
//                                                position:ccp(-monster.contentSize.width/2, actualY)];
//    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
//        [node removeFromParentAndCleanup:YES];
//    }];
//    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
//    
//}

- (void)returnToMenu {
    CCScene *menuScene = [CCBReader loadAsScene:@"MainScene"];
//    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

@end
