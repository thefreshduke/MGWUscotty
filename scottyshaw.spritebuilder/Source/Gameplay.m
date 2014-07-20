//
//  Gameplay.m
//  scottyshaw
//
//  Created by Scotty Shaw on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "MainScene.h"
#import "Recap.h"

@implementation Gameplay {
    CCPhysicsNode *_player;
    CCPhysicsNode *_enemy;
    CCPhysicsNode *_physicsWorld;
}

//+ (Gameplay *)scene
//{
//    return [[self alloc] init];
//}
//
//// -----------------------------------------------------------------------
//
//- (id)init
//{
//    // Apple recommend assigning self with supers return value
//    self = [super init];
//    if (!self) return(nil);
//    
//    // Enable touch handling on scene node
//    self.userInteractionEnabled = YES;
//    [[OALSimpleAudio sharedInstance] playBg:@"ResourcePack/Sounds/background-music-aac.caf" loop:YES];
//    //    [[OALSimpleAudio sharedInstance] playEffect:@"M1-Garand-Reloading.caf"];
//    //    [[OALSimpleAudio sharedInstance] playEffect:@"Cartman.caf"];
//    
//    // Create a colored background (Light Grey)
//    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
//    [self addChild:background];
//    
//    _physicsWorld = [CCPhysicsNode node];
//    _physicsWorld.gravity = ccp(0,0);
//    // _physicsWorld.debugDraw = YES;
//    _physicsWorld.collisionDelegate = self;
//    [self addChild:_physicsWorld];
//    
//    // Add a sprite
//    _player = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/cartman.png"];
//    // off-left player position
//    //    _player.position  = ccp(self.contentSize.width/8, self.contentSize.height/2);
//    // centralized player position
//    _player.position  = ccp(self.contentSize.width/2, self.contentSize.height/2);
//    _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0]; // 1
//    _player.physicsBody.collisionGroup = @"playerGroup"; // 2
//    _player.physicsBody.collisionType  = @"playerCollision";
//    
//    [_physicsWorld addChild:_player];
//    
//    //    _weapon = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/ak47.png"];
//    //    _weapon.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
//    
//    // Animate sprite with action
//    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
//    //[_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
//    
//    // Create a back button
//    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    backButton.positionType = CCPositionTypeNormalized;
//    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
//    [backButton setTarget:self selector:@selector(onBackClicked:)];
//    [self addChild:backButton];
//    
//    // Kill count
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:18.0f];
//    label.positionType = CCPositionTypeNormalized;
//    label.color = [CCColor redColor];
//    label.position = ccp(0.15f, 0.95f); // Middle of screen
//    [self addChild:label];
//    
//    // done
//	return self;
//}
//
//// -----------------------------------------------------------------------
//
//- (void)dealloc
//{
//    // clean up code goes here
//}
//
//// -----------------------------------------------------------------------
//#pragma mark - Enter & Exit
//// -----------------------------------------------------------------------
//
//- (void)onEnter
//{
//    // always call super onEnter first
//    [super onEnter];
//    
//    int minDuration = 1.0;
//    int maxDuration = 2.0;
//    int rangeDuration = maxDuration - minDuration;
//    int randomDuration = (arc4random() % rangeDuration) + minDuration;
//    
//    [self schedule:@selector(addMonster:) interval:randomDuration];
//    
//    // In pre-v3, touch enable and scheduleUpdate was called here
//    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
//    // Per frame update is automatically enabled, if update is overridden
//    
//}
//
//// -----------------------------------------------------------------------
//
//- (void)onExit
//{
//    // always call super onExit last
//    [super onExit];
//}
//
//// -----------------------------------------------------------------------
//#pragma mark - Touch Handler
//// -----------------------------------------------------------------------
//
//- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    // 1
//    CGPoint touchLocation = [touch locationInNode:self];
//    
//    // 2
//    CGPoint offset    = ccpSub(touchLocation, _player.position);
//    float   ratio     = offset.y/offset.x;
//    CGPoint normalizedOffset = ccpNormalize(offset);
//    CGPoint force = ccpMult(normalizedOffset, 200);
//    //    [projectile.physicsBody applyForce:force];
//    int     targetX   = _player.contentSize.width/2 + self.contentSize.width;
//    int     targetY   = (targetX*ratio) + _player.position.y;
//    CGPoint targetPosition = ccp(targetX,targetY);
//    
//    // 3
//    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/jack-o-lantern.png"];
//    projectile.position = _player.position;
//    projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
//    projectile.physicsBody.collisionGroup = @"playerGroup";
//    projectile.physicsBody.collisionType  = @"projectileCollision";
//    [_physicsWorld addChild:projectile];
//    
//    // 4
//    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:0.5f position:targetPosition];
//    CCActionRemove *actionRemove = [CCActionRemove action];
//    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
//    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:0.25f angle:360];
//    [projectile runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
//    
//    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/M1-Garand.caf"];
//    //    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Mauser-K98.caf"];
//}
//
//// -----------------------------------------------------------------------
//#pragma mark - Button Callbacks
//// -----------------------------------------------------------------------
//
//- (void)onBackClicked:(id)sender
//{
//    // back to intro scene with transition
//    CCScene *mainScene = [CCBReader loadAsScene:@"mainScene"];
//    [[CCDirector sharedDirector] presentScene:mainScene];
////    [[CCDirector sharedDirector] replaceScene:[@"mainScene"] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
//}
//
//// -----------------------------------------------------------------------
//#pragma mark - Monster Spawn
//// -----------------------------------------------------------------------
//
//- (void)addMonster:(CCTime)dt {
//    
//    CCSprite *monster = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/1-up.png"];
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
//        case 0: monster.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 1
//        case 1: monster.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y + sin(i) * self.contentSize.height); // move to quadrant 2
//        case 2: monster.position = CGPointMake(_player.position.x - cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 3
//        case 3: monster.position = CGPointMake(_player.position.x + cos(i) * self.contentSize.height, _player.position.y - sin(i) * self.contentSize.height); // move to quadrant 4
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
//    //    switch (i) {
//    //        case 0: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-self.contentSize.width, self.contentSize.height - randomY)]; // move left
//    //        case 1: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(self.contentSize.width, self.contentSize.height - randomY)]; // move right
//    //        case 2: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(self.contentSize.width - randomX, -self.contentSize.height)]; // move down
//    //        case 3: actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(self.contentSize.width - randomX, self.contentSize.height)]; // move up
//    //    }
//    
//    //    CCAction *actionMove = [C7y7CActionMoveTo actionWithDuration:randomDuration position:CGPointMake(_player.position.x + cos(arc4random_uniform(360)) * self.contentSize.height, _player.position.y + sin(arc4random_uniform(360)) * self.contentSize.height)];
//    
//    //    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, self.contentSize.height - randomY)];
//    CCAction *actionRemove = [CCActionRemove action];
//    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
//}
//
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster projectileCollision:(CCNode *)projectile {
//    [monster removeFromParent];
//    [projectile removeFromParent];
//    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
//    return YES;
//}
//
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair monsterCollision:(CCNode *)monster playerCollision:(CCNode *)player {
//    [monster removeFromParent];
//    [player removeFromParent];
//    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
//    [[CCDirector sharedDirector] presentScene:gameplayScene];
////    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
//    //    [self lose];
//    return YES;
//}
//
////- (void)lose {
////    CCLOG(@"You are dead");
////    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
////    if (self.score > [highScore intValue]) {
////        // new high score!
////        highScore = [NSNumber numberWithInt:self.score];
////        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"highScore"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////    }
////    RecapScene *gameEndPopover = (RecapScene *)[CCBReader load:@"GameEnd"];
////    gameEndPopover.positionType = CCPositionTypeNormalized;
////    gameEndPopover.position = ccp(0.5, 0.5);
////    gameEndPopover.zOrder = INT_MAX;
////    [gameEndPopover setMessage:message score:self.score];
////    [self addChild:gameEndPopover];
////}
//
- (void)returnToMenu {
    CCScene *menuScene = [CCBReader loadAsScene:@"MainScene"];
//    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

- (void)goToRecap {
    CCScene *menuScene = [CCBReader loadAsScene:@"Recap"];
    //    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

@end
