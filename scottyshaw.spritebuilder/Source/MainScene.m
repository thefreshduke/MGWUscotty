//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
    CCPhysicsNode *_player;
}

//+ (MainScene *)scene
//{
//	return [[self alloc] init];
//}
//
//- (id)init
//{
//    // Apple recommend assigning self with supers return value
//    self = [super init];
//    if (!self) return(nil);
//    
//    // Create a colored background (Dark Grey)
//    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
//    [self addChild:background];
//    
//    // Hello world
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Respect My Authoritah!" fontName:@"Chalkduster" fontSize:36.0f];
//    label.positionType = CCPositionTypeNormalized;
//    label.color = [CCColor redColor];
//    label.position = ccp(0.5f, 0.5f); // Middle of screen
//    [self addChild:label];
//    
//    // Helloworld scene button
//    CCButton *helloWorldButton = [CCButton buttonWithTitle:@"[ Start ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    helloWorldButton.positionType = CCPositionTypeNormalized;
//    helloWorldButton.position = ccp(0.5f, 0.35f);
//    [helloWorldButton setTarget:self selector:@selector(onSpinningClicked:)];
//    [self addChild:helloWorldButton];
//    
//    // done
//	return self;
//}

- (void)startGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
