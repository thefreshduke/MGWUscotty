//
//  Tutorial.m
//  scottyshaw
//
//  Created by Scotty Shaw on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"
#import "MainScene.h"
#import "Recap.h"
#import "Player.h"
#import "Enemy.h"
//#import <CoreMotion/CoreMotion.h>

@implementation Tutorial {
    CCNode *_levelNode;
    Player *_player;
    //    CCSprite *_enemy;
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_lifeLabel;
    CCLabelTTF *_armorLabel;
    CCLabelTTF *_ammoLabel;
    CCLabelTTF *_dangerLabel;
    CCLabelTTF *_lowLabel;
    CCLabelTTF *_tipsLabel;
    CCLabelTTF *_infoLabel1;
    CCLabelTTF *_infoLabel2;
    CCLabelTTF *_infoLabel3;
    CCLabelTTF *_infoLabel4;
    //    CMMotionManager *_motionManager; //create only one instance of a motion manager
}

static NSInteger life;
static NSInteger armor;
static NSInteger ammo;

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = TRUE;
    
    //    _motionManager = [[CMMotionManager alloc] init];
    
    //enemy too big?
}

//// -----------------------------------------------------------------------
//#pragma mark - Enter & Exit
//// -----------------------------------------------------------------------

- (void)onEnter
{
    life = 100;
    armor = 50;
    ammo = 100 - armor;
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    // always call super onEnter first
    [super onEnter];
    _player.position = ccp(screenWidth/2, screenHeight/2);
    //    [_motionManager startAccelerometerUpdates];
    _tipsLabel.string = [NSString stringWithFormat:@"Tap to shoot"];
    
    _lifeLabel.string = [NSString stringWithFormat:@"%ld", (long) life];
    if (life < 40) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _dangerLabel.string = [NSString stringWithFormat:@"!!!DANGER!!!"];
    }
    else if (life < 70) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    else if (life < 100) {
        _lifeLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    else if (life == 100) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:255.0f/255.0f
                                           alpha:1.0f];
    }
    _armorLabel.string = [NSString stringWithFormat:@"%ld", (long) armor];
    if (armor < 40) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:0.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW ARMOR: %ld LEFT", (long) armor];
    }
    else if (armor >= 40 && armor < 70) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        //        _lowLabel.string = [NSString stringWithFormat:@""];
    }
    else if (armor >= 70 && armor < 100) {
        _armorLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
    }
    else if (armor == 100) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:255.0f/255.0f
                                            alpha:1.0f];
    }
    _ammoLabel.string = [NSString stringWithFormat:@"%ld", (long) ammo];
    if (ammo < 40) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW AMMO: %ld LEFT", (long) ammo];
    }
    if (ammo >= 40 && ammo < 70) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        //        _lowLabel.string = [NSString stringWithFormat:@" "];
    }
    if (ammo >= 70 && ammo < 100) {
        _ammoLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    if (ammo == 100) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:255.0f/255.0f
                                           alpha:1.0f];
    }
    //    while (armor < 40 || ammo < 40) {
    //        _lowLabel.string = [NSString stringWithFormat:@"LOW ARMOR: %ld LEFT", (long) armor];
    //    }
    
    int minDuration = 1.0;
    int maxDuration = 2.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    self.enemyArray = [[NSMutableArray alloc] init];
    self.playerProjectileArray = [[NSMutableArray alloc] init];
    self.enemyProjectileArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(spawnEnemy:) interval:maxDuration];
}

- (void)onExit
{
    [super onExit];
    //    [_motionManager stopAccelerometerUpdates];
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

- (void) update:(CCTime)delta {
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    ammo = 100 - armor;
    
    
    
    _lifeLabel.string = [NSString stringWithFormat:@"%ld", (long) life];
    if (life < 40) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _dangerLabel.string = [NSString stringWithFormat:@"!!!DANGER!!!"];
    }
    else if (life < 70) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    else if (life < 100) {
        _lifeLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    else if (life == 100) {
        _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:255.0f/255.0f
                                           alpha:1.0f];
    }
    _armorLabel.string = [NSString stringWithFormat:@"%ld", (long) armor];
    if (armor < 40) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:0.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW ARMOR: %ld LEFT", (long) armor];
    }
    if (armor >= 40 && armor < 70) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@" "];
    }
    if (armor >= 70 && armor < 100) {
        _armorLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
    }
    if (armor == 100) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:255.0f/255.0f
                                            alpha:1.0f];
    }
    //    else {
    //        float d = ;
    //        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
    //                                           green:255.0f/255.0f
    //                                            blue:255.0f/255.0f
    //                                           alpha:1.0f];
    //    }
    _ammoLabel.string = [NSString stringWithFormat:@"%ld", (long) ammo];
    if (ammo < 40) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW AMMO: %ld LEFT", (long) ammo];
    }
    if (ammo >= 40 && ammo < 70) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@" "];
    }
    if (ammo >= 70 && ammo < 100) {
        _ammoLabel.color = [CCColor colorWithRed:0.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
    }
    if (ammo == 100) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:255.0f/255.0f
                                           alpha:1.0f];
    }
    
    [self updateEnemyArray];
    [self updatePlayerProjectileArray];
    [self updateEnemyProjectileArray];
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    //    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    //    CMAcceleration acceleration = accelerometerData.acceleration;
    
    //define movement variables
    
    // screen has been locked left (button to the left) for the following orientation
    //    CGFloat newXPosition = _player.position.x + acceleration.y * 1000 * delta;
    //    CGFloat newXPosition = _player.position.x + (acceleration.x + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationX"] floatValue]) * 1000 * delta;
    //    newXPosition = clampf(newXPosition, 25, screenWidth-25);
    //    CGFloat newYPosition = _player.position.y - acceleration.x * 1000 * delta;
    //    CGFloat newYPosition = _player.position.y + (acceleration.y + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationY"] floatValue]) * 1000 * delta;
    //    newYPosition = clampf(newYPosition, 25, screenHeight-25);
    //    _player.position = CGPointMake(newXPosition, newYPosition);
    
    //    CCActionFollow *follow = [CCActionFollow actionWithTarget:_player];
    //    [_levelNode runAction:follow];
    //    [self runAction:[CCFollow actionWithTarget:_player worldBoundary:CGRectMake(0,0,screenWidth,screenHeight)]];
    
    //    NSLog(@"%i", armor);
}

//// -----------------------------------------------------------------------
//#pragma mark - Touch Handler
//// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (ammo > 0) {
        
        ammo = ammo - 5;
        armor = armor + 5;
        _shotCount++;
        
        if (armor > 100) {
            armor = 100;
        }
        
        if (ammo < 0) {
            ammo = 0;
        }
        
        if (_shotCount > 0 && _shotCount < 3) {
            _tipsLabel.string = [NSString stringWithFormat:@" "];
            _infoLabel1.string = [NSString stringWithFormat:@"1 shot"];
            _infoLabel2.string = [NSString stringWithFormat:@"="];
            _infoLabel3.string = [NSString stringWithFormat:@"+ 5 armor"];
            _infoLabel4.string = [NSString stringWithFormat:@"– 5 ammo"];
        }
        
//        if (_shotCount == 3) {
//            _tipsLabel.string = [NSString stringWithFormat:@"Enemy shots refill ammo"];
//            _infoLabel1.string = [NSString stringWithFormat:@" "];
//            _infoLabel2.string = [NSString stringWithFormat:@" "];
//            _infoLabel3.string = [NSString stringWithFormat:@" "];
//            _infoLabel4.string = [NSString stringWithFormat:@" "];
//        }
        
        CCSprite* _playerProjectile = (CCSprite *)[CCBReader load: @"PlayerWeapon"];
        
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
        
        CGPoint touchLocation = [touch locationInNode:_levelNode];
        
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
        
        //    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:0.5f position:targetPosition];
        //    CCActionRemove *actionRemove = [CCActionRemove action];
        //    [_projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        //    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:0.25f angle:360];
        //    [_projectile runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
        
        [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/M1-Garand.caf"];
        //    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Mauser-K98.caf"];
    }
    
    NSLog(@"SHOTS FIRED");
    NSLog(@"life: %ld", (long)life);
    NSLog(@"armor: %ld", (long)armor);
    NSLog(@"ammo: %ld", (long)ammo);
    NSLog(@"");
}

//// -----------------------------------------------------------------------
//#pragma mark - _enemy Spawn
//// -----------------------------------------------------------------------

- (void)spawnEnemy:(CCTime)delta {
    //    for (int i = 0; i < (arc4random_uniform(2) + 1); i++) { //spawn multiple enemies simultaneously
    
    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"SimpleEnemy"];
    //    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"Enemy"]; //no force applied for some reason?
    
    //    CC_DEGREES_TO_RADIANS(<#__ANGLE__#>) is sin/cos in degrees or radians?
    // value between 0.f and 1.f
    //    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    //    CGFloat range = maximumYPosition - minimumYPosition;
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    //        int i = arc4random_uniform(360); //degrees or radians?
    
    //        _enemy.position = ccp(_player.position.x + cos(i) * screenWidth, _player.position.y + sin(i) * screenWidth);
    //        _enemy.position = ccp(_player.position.x + cos(i) * 300, _player.position.y + sin(i) * 300);
    _enemy.position = ccp(-10, 0.15 * screenHeight);
    
    [_physicsNode addChild: _enemy];
    [self.enemyArray addObject: _enemy];
    
    CGPoint enemyDestination = ccp(screenWidth * 1.1, 0.15 * screenHeight);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyDestination, _enemy.position));
    CGPoint force = ccpMult(normalizedOffset, 12000);
    
    _enemy.physicsBody.collisionType = @"enemyCollision";
    [_enemy.physicsBody applyForce:force];
    //    }
}

//player doesn't shoot if user holds down one spot and taps another? ask shady about his hold/tap thing

- (void) updateEnemyArray {
    
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.enemyArray.count; i++) {
        CGPoint enemyPos = ((CCSprite*) self.enemyArray[i]).position;
        CGPoint playerPos = ccp(_player.position.x, _player.position.y);
        CGPoint distance = ccpSub(enemyPos, playerPos);
        
        if (armor == 0) {
            _tipsLabel.string = [NSString stringWithFormat:@"Shoot to refill armor"];
            _infoLabel1.string = [NSString stringWithFormat:@" "];
            _infoLabel2.string = [NSString stringWithFormat:@" "];
            _infoLabel3.string = [NSString stringWithFormat:@" "];
            _infoLabel4.string = [NSString stringWithFormat:@" "];
        }
        
        if (ammo == 0) {
            _tipsLabel.string = [NSString stringWithFormat:@"Enemy shots refill ammo"];
            _infoLabel1.string = [NSString stringWithFormat:@" "];
            _infoLabel2.string = [NSString stringWithFormat:@" "];
            _infoLabel3.string = [NSString stringWithFormat:@" "];
            _infoLabel4.string = [NSString stringWithFormat:@" "];
        }
        
        if (_enemyShots == 1) {
            _tipsLabel.string = [NSString stringWithFormat:@" "];
            _infoLabel1.string = [NSString stringWithFormat:@"1 hit"];
            _infoLabel2.string = [NSString stringWithFormat:@"="];
            _infoLabel3.string = [NSString stringWithFormat:@"+ 10 ammo"];
            _infoLabel4.string = [NSString stringWithFormat:@"– 10 armor"];
        }
        
        if (ccpLength(ccpSub(enemyPos, playerPos)) <= 150 && _shotCount >= 3 && [self.enemyProjectileArray count] < 1 && armor >= 10) {
//            int pause = 2.0;
//            [self schedule:@selector(enemyShoot:) interval:pause];
            [self enemyShootFromLocationX:enemyPos.x fromLocationY:enemyPos.y toLocationX:playerPos.x toLocationY:playerPos.y];
        }
        
        if (ccpLength(distance) >= screenWidth * 0.6) {
            [self.enemyArray[i] removeFromParent];
            [self.enemyArray removeObjectAtIndex:i];
        }
    }
}

//- (void)enemyShoot:(CCTime)delta {
//    
//}

- (void)enemyShootFromLocationX:(float)enemyPosX fromLocationY:(float)enemyPosY toLocationX:(float)playerPosX toLocationY:(float)playerPosY{
    _enemyShots++;
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    CCSprite* _enemyProjectile = (CCSprite *)[CCBReader load: @"EnemyWeapon"];
    _enemyProjectile.position = ccp(enemyPosX, enemyPosY);
    //        int i = arc4random_uniform(360);
    [_physicsNode addChild: _enemyProjectile];
    [self.enemyProjectileArray addObject: _enemyProjectile];
    //        CGPoint enemyAim = ccp(cos(i) * arc4random_uniform(150) + _player.position.x, sin(i) * arc4random_uniform(150) + _player.position.y);
    CGPoint enemyAim = ccp(playerPosX, playerPosY);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyAim, _enemyProjectile.position));
    CGPoint force = ccpMult(normalizedOffset, 5000);
    _enemyProjectile.physicsBody.collisionType = @"enemyProjectileCollision";
    [_enemyProjectile.physicsBody applyForce:force];
}


- (void) updatePlayerProjectileArray {
#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height
    
    for (int i = 0; i < self.playerProjectileArray.count; i++) {
        CGPoint playerProjectilePos = ((CCSprite*) self.playerProjectileArray[i]).position;
        CGPoint playerPos = ccp(_player.position.x, _player.position.y);
        CGPoint distance = ccpSub(playerProjectilePos, playerPos);
        
        if (ccpLength(distance) >= screenWidth * 0.55) {
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
        CGPoint playerPos = ccp(_player.position.x, _player.position.y);
        CGPoint distance = ccpSub(enemyProjectilePos, playerPos);
        
        if (ccpLength(distance) >= screenWidth * 0.55) {
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

//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile1 enemyProjectileCollision:(CCNode *)enemyProjectile2 {
//    return NO;
//}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerProjectileCollision:(CCNode *)playerProjectile {
    CCParticleSystem *enemyExplosion = (CCParticleSystem *)[CCBReader load:@"EnemyExplosion"];
    enemyExplosion.autoRemoveOnFinish = TRUE;
    enemyExplosion.position = enemy.position;
    [enemy.parent addChild:enemyExplosion];
    [enemy removeFromParent];
    [self.enemyArray removeObject:enemy];
    [playerProjectile removeFromParent];
    [self.playerProjectileArray removeObject:playerProjectile];
    [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
    return YES;
}

//player-enemyProjectile interaction for dying
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
    armor = armor - 10;
    ammo = ammo + 10;
    _hitCount++;
    [enemyProjectile removeFromParent];
    [self.enemyProjectileArray removeObject:enemyProjectile];
//    if (armor < 0) {
//        CCParticleSystem *playerExplosion = (CCParticleSystem *)[CCBReader load:@"PlayerExplosion"];
//        playerExplosion.autoRemoveOnFinish = TRUE;
//        playerExplosion.position = player.position;
//        [player.parent addChild:playerExplosion];
//        [player removeFromParent];
//        [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
//        int pause = 2.0;
//        [self schedule:@selector(returnTOMenu:) interval:pause];
//    }
    return YES;
}

- (void)returnToMenu {
    CCScene *menuScene = [CCBReader loadAsScene:@"MainScene"];
    //    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

- (void)startGame {
    //    float calibrationX = -_motionManager.accelerometerData.acceleration.x;
    //    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationX] forKey:@"calibrationX"];
    //    float calibrationY = -_motionManager.accelerometerData.acceleration.y;
    //    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationY] forKey:@"calibrationY"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] presentScene:gameplayScene];
    //CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    //[[CCDirector sharedDirector] presentScene:firstLevel withTransition:transition];
}

@end
