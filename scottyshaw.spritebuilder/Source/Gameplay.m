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
    CCNode *_ammoArmorBar;
    CCNode *_ammoArmorBarMark;
    Player *_player;
    //    CCSprite *_enemy;
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_lifeLabel;
    CCLabelTTF *_armorLabel;
    CCLabelTTF *_ammoLabel;
    CCLabelTTF *_dangerLabel;
    CCLabelTTF *_lowLabel;
    CCLabelTTF *_tipsLabel1;
    CCLabelTTF *_tipsLabel2;
    CCButton *_calibrateButton;
    CMMotionManager *_motionManager; //create only one instance of a motion manager
    BOOL tiltCalibrated;
}

static NSInteger life;
static NSInteger armor;
static NSInteger ammo;

#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = TRUE;
    _motionManager = [[CMMotionManager alloc] init];
}

//// -----------------------------------------------------------------------
//#pragma mark - Enter & Exit
//// -----------------------------------------------------------------------

- (void)onEnter {
    // always call super onEnter first
    [super onEnter];
    
    life = 100;
    armor = 50;
    ammo = 100 - armor;
    
    tiltCalibrated = false;
    
    _player.position = ccp(screenWidth/2, screenHeight/2);
    [_motionManager startAccelerometerUpdates];
    
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
    
    int minDuration = 1.0;
    int maxDuration = 2.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    self.enemyArray = [[NSMutableArray alloc] init];
    self.playerProjectileArray = [[NSMutableArray alloc] init];
    self.enemyProjectileArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(spawnEnemy:) interval:randomDuration];
}

- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
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
    
    ammo = 100 - armor;
    _ammoArmorBarMark.position = ccp(ammo / 100.f * .97 + _ammoArmorBarMark.contentSize.width/2, _ammoArmorBarMark.position.y);
    
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
    
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    //define movement variables
    
    // screen has been locked left (button to the left) for the following orientation
//    CGFloat newXPosition = _player.position.x + acceleration.y * 1000 * delta;
    CGFloat newXPosition = _player.position.x + (acceleration.y + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationY"] floatValue]) * 1000 * delta; //
    //    newXPosition = clampf(newXPosition, 25, screenWidth-25);
//    CGFloat newYPosition = _player.position.y - acceleration.x * 1000 * delta;
    CGFloat newYPosition = _player.position.y - (acceleration.x + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationX"] floatValue]) * 1000 * delta;
    //    newYPosition = clampf(newYPosition, 25, screenHeight-25);
    _player.position = CGPointMake(newXPosition, newYPosition);
    
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_player];
    [_levelNode runAction:follow];
    //    [self runAction:[CCFollow actionWithTarget:_player worldBoundary:CGRectMake(0,0,screenWidth,screenHeight)]];
    
    //    NSLog(@"%i", armor);
}

//// -----------------------------------------------------------------------
//#pragma mark - Touch Handler
//// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    _tipsLabel2.string = [NSString stringWithFormat: @" "];
    
    if (ammo > 0) {
        
        ammo = ammo - 5;
        armor = armor + 5;
        
        if (armor > 100) {
            armor = 100;
        }
        
        if (ammo < 0) {
            ammo = 0;
        }
        
        CCSprite* _playerProjectile = (CCSprite *)[CCBReader load: @"PlayerWeapon"];
        
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
    if (tiltCalibrated) {
        for (int i = 0; i < (arc4random_uniform(2) + 1); i++) { //spawn multiple enemies simultaneously
            
            CCSprite* _enemy = (CCSprite *)[CCBReader load: @"SimpleEnemy"];
            //    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"Enemy"]; //no force applied for some reason?
            
            //    CC_DEGREES_TO_RADIANS(<#__ANGLE__#>) is sin/cos in degrees or radians?
            // value between 0.f and 1.f
            //    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
            //    CGFloat range = maximumYPosition - minimumYPosition;
            
            int i = arc4random_uniform(360); //degrees or radians?
            
            //        _enemy.position = ccp(_player.position.x + cos(i) * screenWidth, _player.position.y + sin(i) * screenWidth);
            _enemy.position = ccp(_player.position.x + cos(i) * 300, _player.position.y + sin(i) * 300);
            
            [_physicsNode addChild: _enemy];
            [self.enemyArray addObject: _enemy];
            
            i = arc4random_uniform(360);
            //    CGPoint offset = ccp(cos(i), sin(i));
            //        CGPoint enemyDestination = ccp(cos(i) * (100 + arc4random_uniform(150)) + _player.position.x, sin(i) * (200 + arc4random_uniform(150)) + _player.position.y);
            CGPoint enemyDestination = ccp(cos(i) * (100 + arc4random_uniform(150)) + _player.position.x, sin(i) * (200 + arc4random_uniform(150)) + _player.position.y);
            
            // can tighten 200-radius for denser enemy ramming... maybe adjust other circle radiuses to happen closer off-screen
            
            CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyDestination, _enemy.position));
            CGPoint force = ccpMult(normalizedOffset, 12000 + arc4random_uniform(20000)); //set randomized speed
            
            _enemy.physicsBody.collisionType = @"enemyCollision";
            [_enemy.physicsBody applyForce:force];
        }
    }
}

//player doesn't shoot if user holds down one spot and taps another? ask shady about his hold/tap thing

- (void) updateEnemyArray {
    
    for (int i = 0; i < self.enemyArray.count; i++) {
        CGPoint enemyPos = ((CCSprite*) self.enemyArray[i]).position;
        CGPoint playerPos = ccp(_player.position.x, _player.position.y);
        CGPoint distance = ccpSub(enemyPos, playerPos);
        
        if (ccpLength(ccpSub(enemyPos, playerPos)) <= screenWidth * 0.55 && ccpLength(ccpSub(enemyPos, playerPos)) > 200 && arc4random_uniform(1000) % 80 == 0) {
            [self enemyShootFromLocationX:enemyPos.x fromLocationY:enemyPos.y];
        }
        
        if (ccpLength(distance) >= screenWidth * 0.75) {
            [self.enemyArray[i] removeFromParent];
            [self.enemyArray removeObjectAtIndex:i];
        }
    }
}

- (void)enemyShootFromLocationX:(float)enemyPosX fromLocationY:(float)enemyPosY{
    CCSprite* _enemyProjectile = (CCSprite *)[CCBReader load: @"EnemyWeapon"];
    _enemyProjectile.position = ccp(enemyPosX, enemyPosY);
    int i = arc4random_uniform(360);
    [_physicsNode addChild: _enemyProjectile];
    [self.enemyProjectileArray addObject: _enemyProjectile];
    CGPoint enemyAim = ccp(cos(i) * arc4random_uniform(150) + _player.position.x, sin(i) * arc4random_uniform(150) + _player.position.y);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyAim, _enemyProjectile.position));
    CGPoint force = ccpMult(normalizedOffset, 25000);
    _enemyProjectile.physicsBody.collisionType = @"enemyProjectileCollision";
    [_enemyProjectile.physicsBody applyForce:force];
}


- (void) updatePlayerProjectileArray {
    
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

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile1 enemyProjectileCollision:(CCNode *)enemyProjectile2 {
    return NO;
}

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

// modified player-enemy interaction for invincibility
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerCollision:(CCNode *)player {
//    return NO;
//}

// modified player-enemy interaction for dying
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyCollision:(CCNode *)enemy playerCollision:(CCNode *)player {
    life = life - 30;
    armor -= 10;
    ammo += 10;
    CCParticleSystem *enemyExplosion = (CCParticleSystem *)[CCBReader load:@"EnemyExplosion"];
    enemyExplosion.autoRemoveOnFinish = TRUE;
    enemyExplosion.position = enemy.position;
    [enemy.parent addChild:enemyExplosion];
    [enemy removeFromParent];
    [self.enemyArray removeObject:enemy];
    if (life <= 0) {
        armor = 0;
        life = 0;
        NSLog(@"DEATH BY COLLISION");
        NSLog(@"life: %ld", (long)life);
        NSLog(@"armor: %ld", (long)armor);
        NSLog(@"ammo: %ld", (long)ammo);
        NSLog(@"");
        CCParticleSystem *playerExplosion = (CCParticleSystem *)[CCBReader load:@"PlayerExplosion"];
        playerExplosion.autoRemoveOnFinish = TRUE;
        playerExplosion.position = player.position;
        [player.parent addChild:playerExplosion];
        [player removeFromParent];
        [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
        //        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        //        [[CCDirector sharedDirector] presentScene:recapScene];
        //    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
        //    [self lose];
        //        CCTransition *transition = [CCTransition transitionFadeWithDuration:3.0f];
        //        [[CCDirector sharedDirector] presentScene:recapScene withTransition:transition];
        int pause = 2.0;
        [self schedule:@selector(goToRecap:) interval:pause];
    }
    
    NSLog(@"COLLIDED");
    NSLog(@"life: %ld", (long)life);
    NSLog(@"armor: %ld", (long)armor);
    NSLog(@"ammo: %ld", (long)ammo);
    NSLog(@"");
    return YES;
}

//player-enemyProjectile interaction for dying
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
    armor = armor - 10;
    ammo = ammo + 10;
    [enemyProjectile removeFromParent];
    [self.enemyProjectileArray removeObject:enemyProjectile];
    if (armor < 0) {
        armor = 0;
        life = 0;
        NSLog(@"SHOT TO DEATH");
        NSLog(@"life: %ld", (long)life);
        NSLog(@"armor: %ld", (long)armor);
        NSLog(@"ammo: %ld", (long)ammo);
        NSLog(@"");
        CCParticleSystem *playerExplosion = (CCParticleSystem *)[CCBReader load:@"PlayerExplosion"];
        playerExplosion.autoRemoveOnFinish = TRUE;
        playerExplosion.position = player.position;
        [player.parent addChild:playerExplosion];
        [player removeFromParent];
        [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/Explosion.caf"];
        //        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        
        //        [[CCDirector sharedDirector] presentScene:recapScene];
        //    [[CCDirector sharedDirector] replaceScene:[Recap scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
        //    [self lose];
        //        CCTransition *transition = [CCTransition transitionFadeWithDuration:3.0f];
        //        [[CCDirector sharedDirector] presentScene:recapScene withTransition:transition];
        int pause = 2.0;
        [self schedule:@selector(goToRecap:) interval:pause];
    }
    NSLog(@"SHOT");
    NSLog(@"life: %ld", (long)life);
    NSLog(@"armor: %ld", (long)armor);
    NSLog(@"ammo: %ld", (long)ammo);
    NSLog(@"");
    return YES;
}

//modified player-enemyProjectile interaction for invincibility
//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
//    return NO;
//}

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

- (void)goToRecap:(CCTime)delta {
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    //    [[CCDirector sharedDirector] presentScene:menuScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:recapScene withTransition:transition];
}

- (void)calibrate {
    float calibrationX = - _motionManager.accelerometerData.acceleration.x;
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationX] forKey:@"calibrationX"];
    float calibrationY = - _motionManager.accelerometerData.acceleration.y;
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithFloat:calibrationY] forKey:@"calibrationY"];
    tiltCalibrated = true;
    _tipsLabel1.string = [NSString stringWithFormat: @" "];
    _tipsLabel2.string = [NSString stringWithFormat: @"Tap to shoot"];
    // remove button?
    [_calibrateButton removeFromParent];
}

@end