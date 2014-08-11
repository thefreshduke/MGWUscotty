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

@implementation Tutorial {
    CCNode *_levelNode;
    Player *_player;
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_lifeLabel;
    CCLabelTTF *_armorLabel;
    CCLabelTTF *_ammoLabel;
    CCLabelTTF *_lowLabel;
    CCLabelTTF *_tipsLabel;
    CCLabelTTF *_infoLabel1;
    CCLabelTTF *_infoLabel2;
    CCLabelTTF *_infoLabel3;
    CCLabelTTF *_infoLabel4;
    BOOL ammoExplained;
    BOOL armorExplained;
    BOOL allExplained;
    BOOL enemyShoot;
    BOOL lowAmmo;
    BOOL lowArmor;
}

static NSInteger life;
static NSInteger armor;
static NSInteger ammo;
static NSInteger shotCount;
static NSInteger hitCount;

#define screenWidth [[CCDirector sharedDirector] viewSize].width
#define screenHeight [[CCDirector sharedDirector] viewSize].height

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = TRUE;
    shotCount = 0;
    hitCount = 0;
    ammoExplained = false;
    armorExplained = false;
    enemyShoot = false;
    lowAmmo = false;
    lowArmor = false;
    allExplained = false;
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
    
    _player.position = ccp(screenWidth/2, screenHeight/2);
    
    _tipsLabel.string = [NSString stringWithFormat:@"Tap to shoot"];
    
    _lifeLabel.string = [NSString stringWithFormat:@"%ld", (long) life];
    _lifeLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                       green:255.0f/255.0f
                                        blue:255.0f/255.0f
                                       alpha:1.0f];
    
    _armorLabel.string = [NSString stringWithFormat:@"%ld", (long) armor];
    _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                        green:255.0f/255.0f
                                         blue:0.0f/255.0f
                                        alpha:1.0f];
    
    _ammoLabel.string = [NSString stringWithFormat:@"%ld", (long) ammo];
    _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                       green:255.0f/255.0f
                                        blue:0.0f/255.0f
                                       alpha:1.0f];
    
    self.enemyArray = [[NSMutableArray alloc] init];
    self.playerProjectileArray = [[NSMutableArray alloc] init];
    self.enemyProjectileArray = [[NSMutableArray alloc] init];
    [self schedule:@selector(spawnEnemy:) interval:2.0];
}

- (void)onExit
{
    [super onExit];
}

- (void) update:(CCTime)delta {
    
    if (shotCount > 0) {
        ammoExplained = true;
    }
    
    if (shotCount > 2) {
        enemyShoot = true;
    }
    
    if (hitCount > 2) {
        armorExplained = true;
    }
    
    if (hitCount > 5) {
        allExplained = true;
    }
    
    ammo = 100 - armor;
    
    _armorLabel.string = [NSString stringWithFormat:@"%ld", (long) armor];
    if (armor < 40) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:0.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW ARMOR: %ld LEFT", (long) armor];
        lowArmor = true;
    }
    if (armor >= 40 && armor < 70) {
        _armorLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                            green:255.0f/255.0f
                                             blue:0.0f/255.0f
                                            alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@" "];
        lowArmor = false;
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
    
    _ammoLabel.string = [NSString stringWithFormat:@"%ld", (long) ammo];
    if (ammo < 40) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@"LOW AMMO: %ld LEFT", (long) ammo];
        lowAmmo = true;
    }
    if (ammo >= 40 && ammo < 70) {
        _ammoLabel.color = [CCColor colorWithRed:255.0f/255.0f
                                           green:255.0f/255.0f
                                            blue:0.0f/255.0f
                                           alpha:1.0f];
        _lowLabel.string = [NSString stringWithFormat:@" "];
        lowAmmo = false;
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
    
    if (!allExplained) {
        if (ammoExplained) {
            _tipsLabel.string = [NSString stringWithFormat:@" "];
            _infoLabel1.string = [NSString stringWithFormat:@"1 shot"];
            _infoLabel2.string = [NSString stringWithFormat:@"="];
            _infoLabel3.string = [NSString stringWithFormat:@"+ 5 armor"];
            _infoLabel4.string = [NSString stringWithFormat:@"– 5 ammo"];
            if (enemyShoot) {
                _tipsLabel.string = [NSString stringWithFormat:@"Enemy shots refill ammo"];
                _infoLabel1.string = [NSString stringWithFormat:@" "];
                _infoLabel2.string = [NSString stringWithFormat:@" "];
                _infoLabel3.string = [NSString stringWithFormat:@" "];
                _infoLabel4.string = [NSString stringWithFormat:@" "];
                if (armorExplained) {
                    _tipsLabel.string = [NSString stringWithFormat:@" "];
                    _infoLabel1.string = [NSString stringWithFormat:@"1 hit"];
                    _infoLabel2.string = [NSString stringWithFormat:@"="];
                    _infoLabel3.string = [NSString stringWithFormat:@"+ 10 ammo"];
                    _infoLabel4.string = [NSString stringWithFormat:@"– 10 armor"];
                }
            }
        }
    }
    else {
        _tipsLabel.string = [NSString stringWithFormat:@"Tap \"Game\" on left to play"];
        _infoLabel1.string = [NSString stringWithFormat:@" "];
        _infoLabel2.string = [NSString stringWithFormat:@" "];
        _infoLabel3.string = [NSString stringWithFormat:@" "];
        _infoLabel4.string = [NSString stringWithFormat:@" "];
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"tutorialCompleted"];
        
        if (lowArmor) {
            _tipsLabel.string = [NSString stringWithFormat:@"Shoot to refill armor"];
        }
        if (lowAmmo) {
            _tipsLabel.string = [NSString stringWithFormat:@"Enemy shots refill ammo"];
        }
    }
    
    [self updateEnemyArray];
    [self updatePlayerProjectileArray];
    [self updateEnemyProjectileArray];
}

//// -----------------------------------------------------------------------
//#pragma mark - Touch Handler
//// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (ammo > 0) {
        
        ammo = ammo - 5;
        armor = armor + 5;
        shotCount++;
        
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
        CGPoint normalizedOffset = ccpNormalize(offset);
        CGPoint force = ccpMult(normalizedOffset, 50000);
        
        _playerProjectile.physicsBody.collisionType  = @"playerProjectileCollision";
        [_playerProjectile.physicsBody applyForce:force];
        
        [[OALSimpleAudio sharedInstance] playEffect:@"ResourcePack/Sounds/M1-Garand.caf"];
    }
}

//// -----------------------------------------------------------------------
//#pragma mark - _enemy Spawn
//// -----------------------------------------------------------------------

- (void)spawnEnemy:(CCTime)delta {
    CCSprite* _enemy = (CCSprite *)[CCBReader load: @"SimpleEnemy"];
    
    _enemy.position = ccp(-10, 0.15 * screenHeight);
    
    [_physicsNode addChild: _enemy];
    [self.enemyArray addObject: _enemy];
    
    CGPoint enemyDestination = ccp(screenWidth * 1.1, 0.15 * screenHeight);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyDestination, _enemy.position));
    CGPoint force = ccpMult(normalizedOffset, 12000);
    
    _enemy.physicsBody.collisionType = @"enemyCollision";
    [_enemy.physicsBody applyForce:force];
}

//player doesn't shoot if user holds down one spot and taps another? ask shady about his hold/tap thing

- (void) updateEnemyArray {
    
    for (int i = 0; i < self.enemyArray.count; i++) {
        CGPoint enemyPos = ((CCSprite*) self.enemyArray[i]).position;
        CGPoint playerPos = ccp(_player.position.x, _player.position.y);
        CGPoint distance = ccpSub(enemyPos, playerPos);
        
        if (enemyShoot) {
            if (ccpLength(ccpSub(enemyPos, playerPos)) <= 150 && [self.enemyProjectileArray count] < 1 && armor >= 10) {
                [self enemyShootFromLocationX:enemyPos.x fromLocationY:enemyPos.y toLocationX:playerPos.x toLocationY:playerPos.y];
            }
        }
        
        if (ccpLength(distance) >= screenWidth * 0.6) {
            [self.enemyArray[i] removeFromParent];
            [self.enemyArray removeObjectAtIndex:i];
        }
    }
}

- (void)enemyShootFromLocationX:(float)enemyPosX fromLocationY:(float)enemyPosY toLocationX:(float)playerPosX toLocationY:(float)playerPosY{
    hitCount++;
    CCSprite* _enemyProjectile = (CCSprite *)[CCBReader load: @"EnemyWeapon"];
    _enemyProjectile.position = ccp(enemyPosX, enemyPosY);
    [_physicsNode addChild: _enemyProjectile];
    [self.enemyProjectileArray addObject: _enemyProjectile];
    CGPoint enemyAim = ccp(playerPosX, playerPosY);
    CGPoint normalizedOffset = ccpNormalize(ccpSub(enemyAim, _enemyProjectile.position));
    CGPoint force = ccpMult(normalizedOffset, 5000);
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

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair enemyProjectileCollision:(CCNode *)enemyProjectile playerCollision:(CCNode *)player {
    armor = armor - 10;
    ammo = ammo + 10;
    [enemyProjectile removeFromParent];
    [self.enemyProjectileArray removeObject:enemyProjectile];
    return YES;
}

- (void)returnToMenu {
    CCScene *menuScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:menuScene withTransition:transition];
}

- (void)startGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.5f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

@end
