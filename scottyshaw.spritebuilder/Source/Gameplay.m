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
#import <CoreMotion/CoreMotion.h>

@implementation Gameplay {
    CCNode *_levelNode;
    Player *_player;
    //    CCSprite *_enemy;
    CCPhysicsNode *_physicsNode;
    CMMotionManager *_motionManager; //create only one instance of a motion manager
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
    
    _motionManager = [[CMMotionManager alloc] init];
    
    //enemy too big?
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

//    [_physicsWorld addChild:_player];

//    //    _weapon = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/ak47.png"];
//    //    _weapon.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);

//    // Animate sprite with action
//    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
//    //[_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];

//    // Create a back button
//    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
//    backButton.positionType = CCPositionTypeNormalized;
//    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
//    [backButton setTarget:self selector:@selector(onBackClicked:)];
//    [self addChild:backButton];

//    // Kill count
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:18.0f];
//    label.positionType = CCPositionTypeNormalized;
//    label.color = [CCColor redColor];
//    label.position = ccp(0.15f, 0.95f); // Middle of screen
//    [self addChild:label];

//    // done
//	return self;
//}

//// -----------------------------------------------------------------------

//- (void)dealloc
//{
//    // clean up code goes here
//}

//// -----------------------------------------------------------------------
//#pragma mark - Enter & Exit
//// -----------------------------------------------------------------------

- (void)onEnter
{
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    // always call super onEnter first
    [super onEnter];
    _player.position = ccp(screenWidth/2, screenHeight/2);
    [_motionManager startAccelerometerUpdates];
    
    int minDuration = 1.0;
    int maxDuration = 2.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    self.enemyArray = [[NSMutableArray alloc] init];
    self.playerProjectileArray = [[NSMutableArray alloc] init];
    self.enemyProjectileArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(spawnEnemy:) interval:randomDuration];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInteractionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

//// -----------------------------------------------------------------------

//- (void)onExit
//{
//    // always call super onExit last
//    [super onExit];
//}

//// -----------------------------------------------------------------------
//#pragma mark - Touch Handler
//// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CCSprite* _playerProjectile = (CCSprite *)[CCBReader load: @"PlayerWeapon"];
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    // 2
    _playerProjectile.position = _player.position;
    [_physicsNode addChild:_playerProjectile];
    [self.playerProjectileArray addObject: _playerProjectile];
    CGPoint offset    = ccpSub(touchLocation, _player.position);
    //    float   ratio     = offset.y/offset.x;
    CGPoint normalizedOffset = ccpNormalize(offset);
    //    CGPoint projectileOrigin = 0;
    CGPoint force = ccpMult(normalizedOffset, 50000); //projectiles work just fine if player is not a child of the physicsNode in spritebuilder/Gameplay; unable to die however... mushrooms don't contact with player despite moving through the same spot
    _playerProjectile.physicsBody.collisionType  = @"playerProjectileCollision";
    [_playerProjectile.physicsBody applyForce:force];
    //    int     targetX   = _player.contentSize.width/2 + self.contentSize.width;
    //    int     targetY   = (targetX*ratio) + _player.position.y;
    //    CGPoint targetPosition = ccp(targetX,targetY);
    
    // 3
    //    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"ResourcePack/Art/jack-o-lantern.png"];
    //    _projectile.position = _player.position;
    //    _projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:_projectile.contentSize.width/2.0f andCenter:_projectile.anchorPointInPoints];
    //    _projectile.physicsBody.collisionGroup = @"playerGroup";
    //    _projectile.physicsBody.collisionType  = @"projectileCollision";
    
    // 4
    //    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:0.5f position:targetPosition];
    //    CCActionRemove *actionRemove = [CCActionRemove action];
    //    [_projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    //    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:0.25f angle:360];
    //    [_projectile runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/M1-Garand.caf"];
    //    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Mauser-K98.caf"];
}

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

//// -----------------------------------------------------------------------
//#pragma mark - _enemy Spawn
//// -----------------------------------------------------------------------

- (void)spawnEnemy:(CCTime)delta {
    for (int i = 0; i < (arc4random_uniform(2) + 1); i++) { //spawn multiple enemies simultaneously
        
        CCSprite* _enemy = (CCSprite *)[CCBReader load: @"SimpleEnemy"];
        //    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"Enemy"]; //no force applied for some reason?
        
        //    CC_DEGREES_TO_RADIANS(<#__ANGLE__#>) is sin/cos in degrees or radians?
        // value between 0.f and 1.f
        //    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
        //    CGFloat range = maximumYPosition - minimumYPosition;
        
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
        
        int i = arc4random_uniform(360); //degrees or radians?
        
//        _enemy.position = ccp(_player.position.x + cos(i) * screenWidth, _player.position.y + sin(i) * screenWidth);
        _enemy.position = ccp(screenWidth/2 + cos(i) * 300, screenHeight/2 + sin(i) * 300);
        
        [_physicsNode addChild: _enemy];
        [self.enemyArray addObject: _enemy];
        
        i = arc4random_uniform(360);
        //    CGPoint offset = ccp(cos(i), sin(i));
//        CGPoint enemyDestination = ccp(cos(i) * (100 + arc4random_uniform(150)) + _player.position.x, sin(i) * (200 + arc4random_uniform(150)) + _player.position.y);
        CGPoint enemyDestination = ccp(cos(i) * (100 + arc4random_uniform(150)) + screenWidth/2, sin(i) * (200 + arc4random_uniform(150)) + screenHeight/2);
        
        // can tighten 200-radius for denser enemy ramming... maybe adjust other circle radiuses to happen closer off-screen
        
        CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyDestination, _enemy.position));
        CGPoint force = ccpMult(normalizedOffset, 12000 + arc4random_uniform(20000)); //set randomized speed
        
        _enemy.physicsBody.collisionType = @"enemyCollision";
        [_enemy.physicsBody applyForce:force];
    }
}

//    enemy only fires within a certain radius of the player
//    aims at an enemyAimCircle
//    add some randomized time length of cooldown before firing again?

- (void)enemyShootFromLocationX:(float)enemyPosX fromLocationY:(float)enemyPosY{
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    CCSprite* _enemyProjectile = (CCSprite *)[CCBReader load: @"EnemyWeapon"];
    _enemyProjectile.position = ccp(enemyPosX, enemyPosY);
    int i = arc4random_uniform(360);
    [_physicsNode addChild: _enemyProjectile];
    [self.enemyProjectileArray addObject: _enemyProjectile];
    CGPoint enemyAim = ccp(cos(i) * arc4random_uniform(150) + screenWidth/2, sin(i) * arc4random_uniform(150) + screenHeight/2);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyAim, _enemyProjectile.position));
    CGPoint force = ccpMult(normalizedOffset, 25000);
    _enemyProjectile.physicsBody.collisionType = @"enemyProjectileCollision";
    //    _enemyProjectile.physicsBody.collisionType = @"enemyProjectileCollision1";
    //    _enemyProjectile.physicsBody.collisionType = @"enemyProjectileCollision2";
    [_enemyProjectile.physicsBody applyForce:force];
}

- (void) update:(CCTime)delta {
    [self updateEnemyArray];
    [self updatePlayerProjectileArray];
    [self updateEnemyProjectileArray];
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    //define movement variables
    
    CGFloat newXPosition = _player.position.x - acceleration.y * 1000 * delta;
    newXPosition = clampf(newXPosition, 30, screenWidth-25);
    CGFloat newYPosition = _player.position.y + acceleration.x * 1000 * delta + 12;
    newYPosition = clampf(newYPosition, 20, screenHeight-25);
    _player.position = CGPointMake(newXPosition, newYPosition);
}

//player doesn't shoot if user holds down one spot and taps another? ask shady about his hold/tap thing

- (void) updateEnemyArray {
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.enemyArray.count; i++) {
        CGPoint enemyPos = ((CCSprite*) self.enemyArray[i]).position;
        CGPoint playerPos = ccp(screenWidth/2, screenHeight/2);
        CGPoint distance = ccpSub(enemyPos, playerPos);
        
        if (ccpLength(distance) >= screenWidth * 0.75) {
            [self.enemyArray[i] removeFromParent];
            [self.enemyArray removeObjectAtIndex:i];
        }
        
        if (ccpLength(ccpSub(enemyPos, playerPos)) <= screenWidth * 0.55 && ccpLength(ccpSub(enemyPos, playerPos)) > 200 && arc4random_uniform(1000) % 80 == 0) {
            [self enemyShootFromLocationX:enemyPos.x fromLocationY:enemyPos.y];
        }
    }
}

- (void) updatePlayerProjectileArray {
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.playerProjectileArray.count; i++) {
        CGPoint playerProjectilePos = ((CCSprite*) self.playerProjectileArray[i]).position;
        CGPoint playerPos = ccp(screenWidth/2, screenHeight/2);
        CGPoint distance = ccpSub(playerProjectilePos, playerPos);
        
        if (ccpLength(distance) >= screenWidth * 0.75) {
            [self.playerProjectileArray[i] removeFromParent];
            [self.playerProjectileArray removeObjectAtIndex:i];
        }
    }
}

- (void) updateEnemyProjectileArray {
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.enemyProjectileArray.count; i++) {
        CGPoint enemyProjectilePos = ((CCSprite*) self.enemyProjectileArray[i]).position;
        CGPoint playerPos = ccp(screenWidth/2, screenHeight/2);
        CGPoint distance = ccpSub(enemyProjectilePos, playerPos);
        
        if (ccpLength(distance) >= screenWidth * 0.55) {
            //        if (ccpLength(distance) <= 100) {
            [self.enemyProjectileArray[i] removeFromParent];
            [self.enemyProjectileArray removeObjectAtIndex:i];
        }
    }
}

//- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy wildcard:(CCNode *)object {
//    [enemy removeFromParent];
//    [self.enemyArray removeObject:enemy];
//    [object removeFromParent];
//}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(CCNode *)player playerProjectileCollision:(CCNode *)playerProjectile {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile enemyCollision:(CCNode *)enemy {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerProjectileCollision:(CCNode *)playerProjectile {
    return NO;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile1 enemyProjectileCollision:(CCNode *)enemyProjectile2 {
    return NO;
}

//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision1:(CCNode *)enemyProjectile1 enemyProjectileCollision2:(CCNode *)enemyProjectile2 {
//    return NO;
//}

//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair physicsNodeCollision:(CCNode *)physicsNode playerProjectileCollision:(CCNode *)playerProjectile {
//    return NO;
//}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerProjectileCollision:(CCNode *)playerProjectile {
    [enemy removeFromParent];
    [self.enemyArray removeObject:enemy];
    [playerProjectile removeFromParent];
    [self.playerProjectileArray removeObject:playerProjectile];
    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
    return YES;
}

//- (BOOL) ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(CCNode *)player wildcard:(CCNode *)object {
//    return YES;
//}

// modified player-enemy interaction for invincibility
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerCollision:(CCNode *)player {
    return NO;
}

// modified player-enemy interaction for dying
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerCollision:(CCNode *)player {
//    [enemy removeFromParent];
//    [self.enemyArray removeObject:enemy];
//    [player removeFromParent];
//    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
//    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
//    [[CCDirector sharedDirector] presentScene:recapScene];
////    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
//    //    [self lose];
//    return YES;
//}

//player-enemyProjectile interaction for dying
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
//    [enemyProjectile removeFromParent];
//    [self.enemyProjectileArray removeObject:enemyProjectile];
//    [player removeFromParent];
//    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
//    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
//    [[CCDirector sharedDirector] presentScene:recapScene];
//    //    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
//    //    [self lose];
//    return YES;
//}

//modified player-enemyProjectile interaction for invincibility
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
    return NO;
}

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
