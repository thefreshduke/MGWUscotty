//
//  Enemy.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
//    CCNode *_enemy;
    // add enemy/laser collision group
//}

//#define ARC4RANDOM_MAX      0x100000000

// visibility on a 3,5-inch iPhone ends a 88 points and we want some meat
//static const CGFloat minimumYPosition = 200.f;
// visibility ends at 480 and we want some meat
//static const CGFloat maximumYPosition = 380.f;

//- (void)didLoadFromCCB {
//    _enemy.physicsBody.collisionGroup = @"enemyGroup";
//    _enemy.physicsBody.collisionType = @"enemyCollision";
//    _enemy.physicsBody.sensor = YES;
//}

//- (void)spawnEnemy:(CCTime)dt {
    // value between 0.f and 1.f
//    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
//    CGFloat range = maximumYPosition - minimumYPosition;
//    
//    int i = arc4random_uniform(360);
//    _enemy.position = ccp(self.contentSize.width/2 + cos(i) * self.contentSize.width, self.contentSize.height/2 + cos(i) * self.contentSize.height);
//    self.enemyArray add
    
//    CGPoint offset    = ccpSub(touchLocation, _player.position);
    //    float   ratio     = offset.y/offset.x;
    //    CGPoint normalizedOffset = ccpNormalize(offset);
    //    CGPoint force = ccpMult(normalizedOffset, 200);
    //    //    [projectile.physicsBody applyForce:force];
    
//    int i = arc4random_uniform(90);
//    switch (arc4random_uniform(4)) {
//        case 0: _enemy.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 1
//        case 1: _enemy.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 2
//        case 2: _enemy.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 3
//        case 3: _enemy.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 4
//    }
//}

//- (void)addMonster:(CCTime)dt {
//    
////    CCSprite *monster = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/1-up.png"];
//    
//    // 1 - set random X and Y coordinates for enemy spawn points
//    //    int minY = monster.contentSize.height / 2;
//    //    int maxY = self.contentSize.height - monster.contentSize.height / 2;
//    //    int rangeY = maxY - minY;
//    //    int randomY = (arc4random() % rangeY) + minY;
//    //
//    //    int minX = monster.contentSize.height / 2;
//    //    int maxX = self.contentSize.width - monster.contentSize.width / 2;
//    //    int rangeX = maxX - minX;
//    //    int randomX = (arc4random() % rangeX) + minX;
//    
//    // 2 - use switch cases to determine which quadrant the enemy spawns on
//    //    CC_DEGREES_TO_RADIANS(<#__ANGLE__#>) is sin/cos in degrees or radians?
//    int i = arc4random_uniform(90);
//    switch (arc4random_uniform(4)) {
//        case 0: _enemy.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 1
//        case 1: _enemy.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 2
//        case 2: _enemy.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 3
//        case 3: _enemy.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 4
//    }
//    //    int i = arc4random() % 4;
//    //    switch (i) {
//    //        case 0: monster.position = CGPointMake(_player.position.x + cos(arc4random_uniform(360)),); // spawn right
//    //        case 1: monster.position = CGPointMake((self.contentSize.width + monster.contentSize.width/2) * -1, randomY); // spawn left
//    //        case 2: monster.position = CGPointMake(randomX, self.contentSize.height + monster.contentSize.height/2); // spawn up
//    //        case 3: monster.position = CGPointMake(randomX, (self.contentSize.height + monster.contentSize.height/2) * -1); // spawn down
//    
//    //        case 0: monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY); // spawn right
//    //        case 1: monster.position = CGPointMake((self.contentSize.width + monster.contentSize.width/2) * -1, randomY); // spawn left
//    //        case 2: monster.position = CGPointMake(randomX, self.contentSize.height + monster.contentSize.height/2); // spawn up
//    //        case 3: monster.position = CGPointMake(randomX, (self.contentSize.height + monster.contentSize.height/2) * -1); // spawn down
//    //    }
//    //    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY); // original spawn statement before switch cases
//    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
//    monster.physicsBody.collisionGroup = @"monsterGroup";
//    monster.physicsBody.collisionType  = @"monsterCollision";
//    [_physicsWorld addChild:monster];
//    
//    // 3 - set random durations for enemy movement across the screen
//    int minDuration = 2.0;
//    int maxDuration = 4.0;
//    int rangeDuration = maxDuration - minDuration;
//    int randomDuration = (arc4random() % rangeDuration) + minDuration;
//    
//    // 4 - use switch cases to determine which side the enemy moves towards
//    //    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, randomY)];
//    CCAction *actionMove;
//    
//    i = arc4random_uniform(91);
//    switch (arc4random_uniform(4)) {
//        case 0: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height)]; // move to quadrant 1
//        case 1: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height)]; // move to quadrant 2
//        case 2: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height)]; // move to quadrant 3
//        case 3: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height)]; // move to quadrant 4
//    }
//
//    CCAction *actionRemove = [CCActionRemove action];
//    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
//}

@end
