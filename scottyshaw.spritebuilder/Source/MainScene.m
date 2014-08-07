//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import <CoreMotion/CoreMotion.h>

@implementation MainScene {
    CCPhysicsNode *_player; //keep this to allow tilt to move player on title screen
    CMMotionManager *_motionManager;
}

//- (void)didLoadFromCCB {
//    [_grid addObserver:self forKeyPath:@"score" options:0 context:NULL];
//    [[NSUserDefaults standardUserDefaults] addObserver:self
//                                            forKeyPath:@"highScore"
//                                               options:0
//                                               context:NULL];
//    // load high score
//    [self updateHighScore];
//}
//
//- (void)updateHighScore {
//    NSNumber *newHighScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
//    if (newHighScore) {
//        _highScoreLabel.string = [NSString stringWithFormat:@"%d", [newHighScore intValue]];
//    }
//}

- (void)startGame {
    float calibrationX = -_motionManager.accelerometerData.acceleration.x;
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationX] forKey:@"calibrationX"];
    float calibrationY = -_motionManager.accelerometerData.acceleration.y;
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationY] forKey:@"calibrationY"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

- (void)startTutorial {
    CCScene *tutorialScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] presentScene:tutorialScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
