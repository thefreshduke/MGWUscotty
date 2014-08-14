//
//  Gameplay.m
//  Upwind
//
//  Created by Scotty Shaw on 8/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Player.h"
#import "Wall.h"
#import "Recap.h"
#import "Target.h"

@implementation Gameplay {
    Recap *_recap;
    Player *_player;
    Wall *_wall;
    Target *_target;
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_instructionLabel;
    CCLabelTTF *_idiotLabel;
    CCLabelTTF *_idiotInstructionLabel;
    CCLabelTTF *_obstacleLabel;
    CCLabelTTF *_infoLabel1;
    CCLabelTTF *_infoLabel2;
    CCLabelTTF *_infoLabel3;
    CCLabelTTF *_levelLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_marginLabel;
    CCLabelTTF *_deathLabel;
    CCLabelTTF *_performanceLabel;
    BOOL touching;
    BOOL collision;
    BOOL waiting;
    BOOL highScore;
    BOOL perfect;
    BOOL oscillatingWall;
    BOOL headWind; // blowing on and off
    BOOL tailWind; // blowing on and off // currently unused?
    BOOL closingWall;
    BOOL jumpingWall; // currently unused
    BOOL secondWall; // a second wall appears behind and chases the player // currently unused
    BOOL backwardsConveyerBelt; // constant movement
    BOOL forwardsConveyerBelt; // constant movement // currently unused?
    int perfectStreak;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = true;
    _physicsNode.collisionDelegate = self;
    
    [self addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"highScore"
                                               options:0
                                               context:NULL];
    // load high score
    [_recap updateHighScore];
    
    _level = 1;
    _score = 0;
    _errorMargin = 100;
    _playerSpeed = 4;
    _oscillatingWallSpeed = -2;
    collision = false;
    highScore = false;
    perfect = false;
    
    oscillatingWall = false;
    headWind = false;
    closingWall = false;
    backwardsConveyerBelt = false;
    forwardsConveyerBelt = false;
    waiting = false;
    perfectStreak = 0;
    
    _instructionLabel.string = [NSString stringWithFormat:@"Hold to move"];
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_score];
    _marginLabel.string = [NSString stringWithFormat:@"%ld", (long)_errorMargin];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_score];
    } else if ([keyPath isEqualToString:@"highScore"]) {
        [_recap updateHighScore];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"score"];
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    touching = true;
    waiting = false;
    _instructionLabel.string = [NSString stringWithFormat:@"Release to stop"];
    [self scheduleBlock:^(CCTimer *timer) {
        [_instructionLabel removeFromParent];
        _target.visible = false;
    } delay:1.f];
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (!collision) {
        
        touching = false;
        int distance = (_wall.position.x - _player.position.x) / 4;
        _errorMargin -= distance;
        
        if (_errorMargin > 0 && distance >= 0) {
            
            _score += _errorMargin * _level;
            _level++;
            
            if (distance == 0) {
                
                perfect = true;
                _performanceLabel.string = [NSString stringWithFormat:@"PERFECT"];
                
                if (perfect) {
                    perfectStreak++;
                }
                else {
                    perfectStreak = 0;
                }
                
                if (perfectStreak > 1) {
                    _performanceLabel.string = [NSString stringWithFormat:@"WOW"];
                }
                if (perfectStreak > 2) {
                    _performanceLabel.string = [NSString stringWithFormat:@"AMAZING"];
                }
                if (perfectStreak > 3) {
                    _performanceLabel.string = [NSString stringWithFormat:@"LEGEND..."];
                }
                if (perfectStreak > 4) {
                    _performanceLabel.string = [NSString stringWithFormat:@"ARY!!!"];
                }
                if (perfectStreak > 5) {
                    _performanceLabel.string = [NSString stringWithFormat:@"PHENOMENAL"];
                }
            }
            else if (distance > 0 && distance <= 2) {
                _performanceLabel.string = [NSString stringWithFormat:@"AWESOME"];
            }
            else if (distance > 2 && distance <= 5) {
                _performanceLabel.string = [NSString stringWithFormat:@"GREAT"];
            }
            else if (distance > 5 && distance <= 10) {
                _performanceLabel.string = [NSString stringWithFormat:@"GOOD"];
            }
            else if (distance > 10 && distance <= 20) {
                _performanceLabel.string = [NSString stringWithFormat:@"OKAY"];
            }
            else {
                [[OALSimpleAudio sharedInstance] playEffect:@"Buzzer.caf"];
                _performanceLabel.string = [NSString stringWithFormat:@"GO FURTHER"];
                if (distance > 30) {
                    if (_level < 3) {
                        [_instructionLabel removeFromParent];
                        _idiotLabel.string = [NSString stringWithFormat:@"GO TO THE WALL"];
                        if (distance > 75) {
                            _idiotInstructionLabel.string = [NSString stringWithFormat:@"Hold to move"];
                            _target.visible = true;
                            _level--;
                            _score -= _errorMargin * _level;
                            _errorMargin += distance;
                            [self scheduleBlock:^(CCTimer *timer) {
                                _idiotInstructionLabel.string = [NSString stringWithFormat:@"Release to stop"];
                                [self scheduleBlock:^(CCTimer *timer) {
                                    _idiotInstructionLabel.string = [NSString stringWithFormat:@" "];
                                    _target.visible = false; // why is timing dfferent for target and label???
                                } delay:1.f];
                            } delay:1.f];
                        }
                    }
                }
            }
            
            [[self animationManager] runAnimationsForSequenceNamed:@"Default Timeline"];
            waiting = true;
            [self scheduleBlock:^(CCTimer *timer) {
                waiting = false;
            } delay:1.f]; //maybe switch time?
            
            NSNumber* distanceTraveled = [NSNumber numberWithInt: distance];
            NSNumber* margin = [NSNumber numberWithInt: self.errorMargin];
            NSNumber* ifPerfect = [NSNumber numberWithBool: perfect];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: distanceTraveled, @"distance", margin, @"errorMargin", ifPerfect, @"perfect", nil];
            [MGWU logEvent:@"levelComplete" withParams:params];
            
            _player.position = ccp(0, 17);
            if (headWind) {
                _playerSpeed = 4;
            }
            if (closingWall) {
                _wall.position = ccp(400, 17);
            }
            perfect = false;
            
            _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_score];
            _marginLabel.string = [NSString stringWithFormat:@"%ld", (long)_errorMargin];
        }
        else {
            self.userInteractionEnabled = false;
            [_idiotLabel removeFromParent];
            [_idiotInstructionLabel removeFromParent];
            [_obstacleLabel removeFromParent];
            [_infoLabel1 removeFromParent];
            [_infoLabel2 removeFromParent];
            [_infoLabel3 removeFromParent];
            [_scoreLabel removeFromParent];
            [_marginLabel removeFromParent];
            [_performanceLabel removeFromParent];
            _deathLabel.string = [NSString stringWithFormat:@"Too far from the wall!"];
            [[OALSimpleAudio sharedInstance] playEffect:@"Explosion1.caf"];
            CCSprite *playerExplosion = (CCSprite *)[CCBReader load:@"Explosion"];
            playerExplosion.position = ccp(_player.position.x - 20, _player.position.y + 20);
            [_player.parent addChild:playerExplosion];
            [_player removeFromParent];
            [_wall removeFromParent];
            
            float pause = 0.5;
            [self scheduleOnce:@selector(goToRecap) delay:pause];
        }
    }
}

-(void)update:(CCTime)delta {
    if (_level < 5) {
        oscillatingWall = false;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = false;
    }
    else if (_level < 9) {
        [_idiotLabel removeFromParent];
        oscillatingWall = true;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle: Oscillating Wall"];
    }
    else if (_level < 13) {
        oscillatingWall = false;
        headWind = false;
        closingWall = true;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle: Closing Wall"];
    }
    else if (_level < 17) {
        oscillatingWall = false;
        headWind = true;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle: Head Wind"];
    }
    else if (_level < 21) {
        oscillatingWall = false;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = true;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle: Forwards Conveyer Belt"];
    }
    else if (_level < 25) {
        oscillatingWall = false;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = true;
        forwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle: Backwards Conveyer Belt"];
    }
    else if (_level < 29) {
        oscillatingWall = true;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = true;
        _obstacleLabel.string = [NSString stringWithFormat:@" "];
    }
    else if (_level < 33) {
        oscillatingWall = false;
        headWind = false;
        closingWall = true;
        backwardsConveyerBelt = true;
        forwardsConveyerBelt = false;
    }
    else if (_level < 37) {
        oscillatingWall = true;
        headWind = true;
        closingWall = false;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = false;
    }
    else if (_level < 41) {
        oscillatingWall = false;
        headWind = false;
        closingWall = true;
        backwardsConveyerBelt = false;
        forwardsConveyerBelt = true;
    }
    
    if (!waiting) {
        if (oscillatingWall) {
            if (_wall.position.x >= 420) {
                _oscillatingWallSpeed = -2;
            }
            if (_wall.position.x <= 380) {
                _oscillatingWallSpeed = 2;
            }
            _wall.position = ccp(_wall.position.x + _oscillatingWallSpeed, _wall.position.y);
        }
        if (headWind) { // needs visuals...
            long i = arc4random_uniform(20);
            if (_playerSpeed == 4) {
                [self scheduleBlock:^(CCTimer *timer) {
                    if (i < 15) {
                        _playerSpeed = 1;
                    }
                } delay:0.5f];
            }
            else {
                if (i == 19) {
                    _playerSpeed = 4;
                }
            }
        }
        
        if (closingWall) {
            _wall.position = ccp(_wall.position.x - 2, _wall.position.y);
        }
        if (backwardsConveyerBelt) {
            _player.position = ccp(_player.position.x - 2, _player.position.y);
        }
        if (forwardsConveyerBelt) {
            _player.position = ccp(_player.position.x + 2, _player.position.y);
        }
        if (touching) {
            _player.position = ccp(_player.position.x + _playerSpeed, _player.position.y);
        }
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(CCNode *)player wallCollision:(CCNode *)wall {
    collision = true;
    self.userInteractionEnabled = false;
    [_idiotLabel removeFromParent];
    [_idiotInstructionLabel removeFromParent];
    [_obstacleLabel removeFromParent];
    [_infoLabel1 removeFromParent];
    [_infoLabel2 removeFromParent];
    [_infoLabel3 removeFromParent];
    [_scoreLabel removeFromParent];
    [_marginLabel removeFromParent];
    [_performanceLabel removeFromParent];
    _deathLabel.string = [NSString stringWithFormat:@"You ran into the wall!"];
    [[OALSimpleAudio sharedInstance] playEffect:@"Explosion1.caf"];
    CCSprite *playerExplosion = (CCSprite *)[CCBReader load:@"Explosion"];
    playerExplosion.position = ccp(player.position.x - 20, player.position.y + 20);
    [player.parent addChild:playerExplosion];
    [player removeFromParent];
    [wall removeFromParent];
    float pause = 0.5;
    //    [playerExplosion removeFromParent];
    [self scheduleOnce:@selector(goToRecap) delay:pause];
    return YES;
}

- (void)goToRecap {
    NSNumber* finalLevel = [NSNumber numberWithInt:self.level];
    NSNumber* finalScore = [NSNumber numberWithInt:self.score];
    NSNumber* ifHighScore = [NSNumber numberWithBool: highScore];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: finalLevel, @"self.level", finalScore, @"self.score", ifHighScore, @"highScore", nil];
    [MGWU logEvent:@"gameOver" withParams:params];
    
    [self setHighScore];
    Recap *recapScene = (Recap*)[CCBReader load:@"Recap"];
    [recapScene setScore: self.score];
    CCScene *newScene = [CCScene node];
    [newScene addChild:recapScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.0f];
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
}

- (void)setHighScore {
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"HighScore"];
    }
    else if (self.score > [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"]){
        highScore = true;
        [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:@"HighScore"];
    }
}

@end
