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
#import "Player.h"
#import "Enemy.h"

@implementation Gameplay {
    CCNode *_levelNode;
    Player *_player;
//    CCSprite *_enemy;
    CCPhysicsNode *_physicsNode;
}

//+ (Gameplay *)scene
//{
//    return [[self alloc] init];
//}
//
//// -----------------------------------------------------------------------

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = TRUE;
    //cartman off center
    //enemy way too big
}

//- (id)init
//{
//    // Apple recommend assigning self with supers return value
//    self = [super init];
//    if (!self) return(nil);
//    
//    // Enable touch handling on scene node
//    self.userInteractionEnabled = YES;
////    [[OALSimpleAudio sharedInstance] playBg:@"ResourcePack/Sounds/background-music-aac.caf" loop:YES];
////    [[OALSimpleAudio sharedInstance] playEffect:@"M1-Garand-Reloading.caf"];
////    [[OALSimpleAudio sharedInstance] playEffect:@"Authoritah.caf"];
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
- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    int minDuration = 1.0;
    int maxDuration = 2.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    self.enemyArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(spawnEnemy:) interval:randomDuration];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}
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
//#pragma mark - _enemy Spawn
//// -----------------------------------------------------------------------
//
- (void)spawnEnemy:(CCTime)dt {
    
//    CCSprite *_enemy = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/1-up.png"];
//    Enemy *_enemy = (Enemy*) [CCBReader load: @"Enemy"];
    
    
    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"SimpleEnemy"];
//    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"Enemy"]; //no force applied for some reason?
    
    //    CC_DEGREES_TO_RADIANS(<#__ANGLE__#>) is sin/cos in degrees or radians?
        // value between 0.f and 1.f
        //    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
        //    CGFloat range = maximumYPosition - minimumYPosition;
        
    int i = arc4random_uniform(360); //degrees or radians?
    
//    [_physicsNode addChild: _enemy];
//    [self.enemyArray addObject: _enemy];
    
//    CGPoint enemyPos = [_physicsNode convertToNodeSpace:ccp(_player.position.x + cos(i) * 100, _player.position.y + sin(i) * 100)];
    _enemy.position = ccp(_player.position.x + cos(i) * 200, _player.position.y + sin(i) * 200);
//    _enemy.position = ccp(_player.position.x + 100, _player.position.y + 100);
//    _enemy.position = _player.position;
//    _enemy.position = ccp(100, 100);
//    _enemy.position = enemyPos;
    
//    CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
//    _currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
    
    [_physicsNode addChild: _enemy];
    [self.enemyArray addObject: _enemy]; // should this go after CGPoint force?

    i = arc4random_uniform(360);
    CGPoint offset = ccp(cos(i), sin(i));
    CGPoint normalizedOffset = ccpNormalize(offset);
    CGPoint force = ccpMult(normalizedOffset, 20000); //set random speed for enemy?

//////    _enemy.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _enemy.contentSize} cornerRadius:0];
//    _enemy.physicsBody.collisionGroup = @"enemyGroup";
    _enemy.physicsBody.collisionType  = @"enemyCollision";
    [_enemy.physicsBody applyForce:force];
   
    //enemy shooting lasers
    
//    CCAction *actionRemove = [CCActionRemove action];
//    [_enemy runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}

- (void) update:(CCTime)delta {
    [self updateEnemyArray];
//    [self updateEnemyProjectileArray];
//    [self updatePlayerProjectileArray];
}

- (void) updateEnemyArray {
    
    #define screenWidth [[CCDirector sharedDirector] viewSize].width
    #define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.enemyArray.count; i++) {
        CGPoint enemyPos = ((CCSprite*) self.enemyArray[i]).position;
        CGPoint playerPos = ccp(screenWidth/2, screenHeight/2);
        CGPoint distance = ccpSub(enemyPos, playerPos);
        
        if (ccpLength(distance) >= 225 || ccpLength(distance) <= 150) {
            [self.enemyArray[i] removeFromParent];
            [self.enemyArray removeObjectAtIndex:i];
        }
    }
}

//- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy wildcard:(CCNode *)object {
//    [enemy removeFromParent];
//    [self.enemyArray removeObject:enemy];
//    [object removeFromParent];
//}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy projectileCollision:(CCNode *)projectile {
    [enemy removeFromParent];
    [self.enemyArray removeObject:enemy];
    [projectile removeFromParent];
//    [self.playerProjectileArray removeObject:projectile];
    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
    return YES;
}

//- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(CCNode *)player wildcard:(CCNode *)object {
//    return YES;
//}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerCollision:(CCNode *)player {
    [enemy removeFromParent];
    [self.enemyArray removeObject:enemy];
    [player removeFromParent];
    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] presentScene:recapScene];
//    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    //    [self lose];
    return YES;
}
//
//- (void)lose {
////    CCLOG(@"You are dead");
////    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
////    if (self.score > [highScore intValue]) {
////        // new high score!
////        highScore = [NSNumber numberWithInt:self.score];
////        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"highScore"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////    }
//    Recap *gameEndPopover = (Recap *)[CCBReader load:@"Recap"];
//    gameEndPopover.positionType = CCPositionTypeNormalized;
//    gameEndPopover.position = ccp(0.5, 0.5);
//    gameEndPopover.zOrder = INT_MAX;
////    [gameEndPopover setMessage:message score:self.score];
//    [self addChild:gameEndPopover];
//}

//- (void)goToRecap {
//    CCScene *menuScene = [CCBReader loadAsScene:@"Recap"];
//    //    [[CCDirector sharedDirector] presentScene:menuScene];
//    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
//    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
//}

//- (void)lose {
//    CCLOG(@"You are dead");
//    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"highScore"];
//    if (self.score > [highScore intValue]) {
//        // new high score!
//        highScore = [NSNumber numberWithInt:self.score];
//        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"highScore"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    RecapScene *gameEndPopover = (RecapScene *)[CCBReader load:@"GameEnd"];
//    gameEndPopover.positionType = CCPositionTypeNormalized;
//    gameEndPopover.position = ccp(0.5, 0.5);
//    gameEndPopover.zOrder = INT_MAX;
//    [gameEndPopover setMessage:message score:self.score];
//    [self addChild:gameEndPopover];
//}

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
