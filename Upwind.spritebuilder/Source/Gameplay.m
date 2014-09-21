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

@implementation Gameplay {
    Recap *_recap;
    Player *_player;
    Wall *_wall;
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_instructionLabel;
    CCLabelTTF *_extraLabel;
    CCLabelTTF *_extraInstructionLabel;
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
    BOOL rollOut;
    BOOL oscillatingWall;
    BOOL headWind; // blowing on and off
    //    BOOL tailWind; // blowing on and off
    BOOL closingWall;
    BOOL jumpingWall; // currently unused
    BOOL backwardsConveyerBelt; // constant movement
    //    BOOL forwardsConveyerBelt; // constant movement
    BOOL warningComplete;
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
    _oscillatingWallSpeed = -2; //might not need this line
    
    _instructionLabel.string = [NSString stringWithFormat:@"Touch screen and hold"];
    
    collision = false;
    highScore = false;
    perfect = false;
    rollOut = false;
    
    oscillatingWall = false;
    headWind = false;
    closingWall = false;
    backwardsConveyerBelt = false;
    waiting = false;
    //    warningComplete = false;
    perfectStreak = 0;
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
    
    [[OALSimpleAudio sharedInstance] playBg:@"Drumroll.caf" loop:NO];
    //    [[OALSimpleAudio sharedInstance] playBg:@"Roll-In.caf" loop:YES];
    
    _instructionLabel.string = [NSString stringWithFormat:@"Release to stop"];
    [self scheduleBlock:^(CCTimer *timer) {
        _instructionLabel.string = [NSString stringWithFormat:@"Don't hit the wall!"];
        [self scheduleBlock:^(CCTimer *timer) {
            [_instructionLabel removeFromParent];
        } delay:1.f];
    } delay:1.f];
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [[OALSimpleAudio sharedInstance] stopBg];
    rollOut = false;
    
    if (!collision) {
        
        touching = false;
        int distance = (_wall.position.x - _player.position.x) / 4;
        if (distance < 0) {
            distance = 0;
        }
        _errorMargin -= distance;
        
        // in case distance = -1 (aka player released just in time to explode, but register a distance not covered by the standard 0-100 situation
        //        if (distance < 0) {
        //            collision = true;
        //            self.userInteractionEnabled = false;
        //            [_extraLabel removeFromParent];
        //            [_extraInstructionLabel removeFromParent];
        //            [_obstacleLabel removeFromParent];
        //            [_infoLabel1 removeFromParent];
        //            [_infoLabel2 removeFromParent];
        //            [_infoLabel3 removeFromParent];
        //            [_scoreLabel removeFromParent];
        //            [_marginLabel removeFromParent];
        //            [_performanceLabel removeFromParent];
        //            _deathLabel.string = [NSString stringWithFormat:@"You ran into the wall!"];
        //            [[OALSimpleAudio sharedInstance] playEffect:@"Explosion.caf"];
        //            CCSprite *playerExplosion = (CCSprite *)[CCBReader load:@"Explosion"];
        //            playerExplosion.position = ccp(_player.position.x - 20, _player.position.y + 20);
        //            [_player.parent addChild:playerExplosion];
        //            [_player removeFromParent];
        //            [_wall removeFromParent];
        //            float pause = 0.5;
        //            //    [playerExplosion removeFromParent];
        //            [self scheduleOnce:@selector(goToRecap) delay:pause];
        //        }
        
        if (_errorMargin > 0) {
            
            _score += _errorMargin * _level;
            _level++;
            
            if (distance == 0) {
                
                perfect = true;
                perfectStreak++;
                _errorMargin += 5 * perfectStreak;
                
                [[OALSimpleAudio sharedInstance] playEffect:@"Cymbal.caf"];
                [[OALSimpleAudio sharedInstance] playEffect:@"Firework.caf"];
                [[OALSimpleAudio sharedInstance] playEffect:@"Winner.caf"];
                [self scheduleBlock:^(CCTimer *timer) {
                    [[OALSimpleAudio sharedInstance] playEffect:@"Firecracker.caf"];
                } delay:1.f];
                
                if (perfectStreak == 1) {
                    _performanceLabel.string = [NSString stringWithFormat:@"PERFECT!!!!!\n+5 MARGIN"];
                }
                else if (perfectStreak == 2) {
                    _performanceLabel.string = [NSString stringWithFormat:@"WOW\n+10 MARGIN"];
                }
                else if (perfectStreak == 3) {
                    _performanceLabel.string = [NSString stringWithFormat:@"AMAZING\n+15 MARGIN"];
                }
                else if (perfectStreak == 4) {
                    _performanceLabel.string = [NSString stringWithFormat:@"LEGEND...\n+20 MARGIN"];
                }
                else if (perfectStreak == 5) {
                    _performanceLabel.string = [NSString stringWithFormat:@"ARY!!!\n+25 MARGIN"];
                }
                else {
                    _performanceLabel.string = [NSString stringWithFormat:@"PHENOMENAL\n+30 MARGIN"];
                }
                
                //                for (int i = 0; i < [_performanceLabel.string length]; i++) {
                //                    NSString *s = _performanceLabel.string[i];
                //                    _performanceLabel.string[0].color = [CCColor colorWithRed:255.0f/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                //                    s.color = [CCColor colorWithRed:255.0f/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                //                }
                //rainbow, larger, italics? cclabel gradient overlay or shade effect?
            }
            
            else {
                
                perfect = false;
                perfectStreak = 0;
                
                if (distance > 0 && distance <= 3) {
                    _performanceLabel.string = [NSString stringWithFormat:@"AWESOME!!!!"];
                    _performanceLabel.color = [CCColor colorWithRed:255.0f/255.0f green:130.0/255.0f blue:0.0/255.0f alpha:1.0f];
                    [[OALSimpleAudio sharedInstance] playEffect:@"Cymbal.caf"];
                    [[OALSimpleAudio sharedInstance] playEffect:@"Win.caf"];
                }
                else if (distance > 2 && distance <= 7) {
                    _performanceLabel.string = [NSString stringWithFormat:@"GREAT!!!"];
                    _performanceLabel.color = [CCColor colorWithRed:175.0f/255.0f green:255.0/255.0f blue:0.0/255.0f alpha:1.0f];
                    [[OALSimpleAudio sharedInstance] playEffect:@"Cymbal.caf"];
                }
                else if (distance > 5 && distance <= 15) {
                    _performanceLabel.string = [NSString stringWithFormat:@"GOOD!!"];
                    _performanceLabel.color = [CCColor colorWithRed:126.0f/255.0f green:168.0/255.0f blue:53.0/255.0f alpha:1.0f];
                    [[OALSimpleAudio sharedInstance] playEffect:@"Cymbal.caf"];
                }
                else if (distance > 10 && distance <= 25) {
                    _performanceLabel.string = [NSString stringWithFormat:@"OKAY!"];
                    _performanceLabel.color = [CCColor colorWithRed:0.0f/255.0f green:189.0/255.0f blue:255.0/255.0f alpha:1.0f];
                    [[OALSimpleAudio sharedInstance] playEffect:@"Cymbal.caf"];
                }
                else {
                    _performanceLabel.string = [NSString stringWithFormat:@"GO FURTHER"];
                    _performanceLabel.color = [CCColor colorWithRed:255.0f/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
                    [_instructionLabel removeFromParent];
                    if (distance > 75) {
                        [[OALSimpleAudio sharedInstance] playEffect:@"Buzzer.caf"];
                        if (_level < 3) {
                            _extraLabel.string = [NSString stringWithFormat:@"GO TO THE TARGET"];
                            _level--;
                            _score -= _errorMargin * _level;
                            _errorMargin += distance;
                            if (!warningComplete) {
                                warningComplete = true;
                                _extraInstructionLabel.string = [NSString stringWithFormat:@"Touch screen and hold"];
                                [self scheduleBlock:^(CCTimer *timer) {
                                    _extraInstructionLabel.string = [NSString stringWithFormat:@"Release to stop"];
                                    [self scheduleBlock:^(CCTimer *timer) {
                                        _extraInstructionLabel.string = [NSString stringWithFormat:@"Don't hit the wall!"];
                                        [self scheduleBlock:^(CCTimer *timer) {
                                            _extraInstructionLabel.string = [NSString stringWithFormat:@" "];
                                            warningComplete = false;
                                        } delay:1.f];
                                    } delay:1.f];
                                } delay:1.f];
                            }
                        }
                    }
                    else {
                        [[OALSimpleAudio sharedInstance] playEffect:@"Fizzle.caf"];
                    }
                }
            }
            
            [[self animationManager] runAnimationsForSequenceNamed:@"Default Timeline"];
            waiting = true;
            [self scheduleBlock:^(CCTimer *timer) {
                waiting = false;
            } delay:1.f];
            
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
            
            _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_score];
            _marginLabel.string = [NSString stringWithFormat:@"%ld", (long)_errorMargin];
        }
        else {
            if (_instructionLabel) {
                [_instructionLabel removeFromParent];
            }
            if (_level < 2) {
                _extraLabel.string = [NSString stringWithFormat:@"GO TO THE TARGET"];
                _score -= _errorMargin * _level;
                _errorMargin += distance;
                if (!warningComplete) {
                    warningComplete = true;
                    _extraInstructionLabel.string = [NSString stringWithFormat:@"Touch screen and hold"];
                    [self scheduleBlock:^(CCTimer *timer) {
                        _extraInstructionLabel.string = [NSString stringWithFormat:@"Release to stop"];
                        [self scheduleBlock:^(CCTimer *timer) {
                            _extraInstructionLabel.string = [NSString stringWithFormat:@"Don't hit the wall!"];
                            [self scheduleBlock:^(CCTimer *timer) {
                                _extraInstructionLabel.string = [NSString stringWithFormat:@" "];
                                warningComplete = false;
                            } delay:1.f];
                        } delay:1.f];
                    } delay:1.f];
                }
            }
            else {
                self.userInteractionEnabled = false;
                [_extraLabel removeFromParent];
                [_extraInstructionLabel removeFromParent];
                [_obstacleLabel removeFromParent];
                [_infoLabel1 removeFromParent];
                [_infoLabel2 removeFromParent];
                [_infoLabel3 removeFromParent];
                [_scoreLabel removeFromParent];
                [_marginLabel removeFromParent];
                [_performanceLabel removeFromParent];
                _deathLabel.string = [NSString stringWithFormat:@"Too far from the wall!"];
                [[OALSimpleAudio sharedInstance] playEffect:@"Explosion.caf"];
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
}

-(void)update:(CCTime)delta {
    
    if ((_wall.position.x - _player.position.x) / 4 <= 16) {
        if (!rollOut) {
            rollOut = true;
            [[OALSimpleAudio sharedInstance] stopBg];
            [[OALSimpleAudio sharedInstance] playEffect:@"Roll-Out.caf"];
        }
    }
    
    if (_level == 2) {
        [_extraLabel removeFromParent];
    }
    if (_level < 5) {
        oscillatingWall = false;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
    }
    else if (_level < 9) {
        [_extraLabel removeFromParent];
        oscillatingWall = false;
        headWind = false;
        closingWall = true;
        backwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle\nClosing Wall"];
    }
    else if (_level < 13) {
        oscillatingWall = false;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = true;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle\nBackwards Conveyer Belt"];
    }
    else if (_level < 17) {
        oscillatingWall = true;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle\nOscillating Wall"];
    }
    else if (_level < 21) {
        oscillatingWall = false;
        headWind = true;
        closingWall = false;
        backwardsConveyerBelt = false;
        _obstacleLabel.string = [NSString stringWithFormat:@"New Obstacle\nHead Wind"];
    }
    else if (_level < 25) {
        oscillatingWall = false;
        headWind = false;
        closingWall = true;
        backwardsConveyerBelt = true;
        [_obstacleLabel removeFromParent];
    }
    else if (_level < 29) {
        oscillatingWall = true;
        headWind = false;
        closingWall = false;
        backwardsConveyerBelt = true;
    }
    else if (_level < 33) {
        oscillatingWall = false;
        headWind = true;
        closingWall = true;
        backwardsConveyerBelt = false;
    }
    else if (_level < 37) {
        oscillatingWall = true;
        headWind = true;
        closingWall = false;
        backwardsConveyerBelt = false;
    }
    else {
        if (arc4random_uniform(2) == 0) {
            oscillatingWall = true;
            closingWall = false;
        }
        else {
            oscillatingWall = false;
            closingWall = true;
        }
        if (arc4random_uniform(2) == 0) {
            oscillatingWall = true;
            closingWall = false;
        }
        else {
            oscillatingWall = false;
            closingWall = true;
        }
    }
    
    if (!waiting) {
        if (backwardsConveyerBelt) { // needs visuals...
            _playerSpeed = 4;
            _player.position = ccp(_player.position.x - 2, _player.position.y);
        }
    }
    if (touching) {
        //        if (forwardsConveyerBelt) { // needs visuals...
        //            _playerSpeed = 4;
        //            _player.position = ccp(_player.position.x + 2, _player.position.y);
        //        }
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
        _player.position = ccp(_player.position.x + _playerSpeed, _player.position.y);
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair playerCollision:(CCNode *)player wallCollision:(CCNode *)wall {
    collision = true;
    self.userInteractionEnabled = false;
    if (_instructionLabel) {
        [_instructionLabel removeFromParent];
    }
    [_extraLabel removeFromParent];
    [_extraInstructionLabel removeFromParent];
    [_obstacleLabel removeFromParent];
    [_infoLabel1 removeFromParent];
    [_infoLabel2 removeFromParent];
    [_infoLabel3 removeFromParent];
    [_scoreLabel removeFromParent];
    [_marginLabel removeFromParent];
    [_performanceLabel removeFromParent];
    _deathLabel.string = [NSString stringWithFormat:@"You ran into the wall!"];
    [[OALSimpleAudio sharedInstance] playEffect:@"Roll-Out.caf"];
    [[OALSimpleAudio sharedInstance] playEffect:@"Explosion.caf"];
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
    NSNumber* finalLevel = [NSNumber numberWithInt:(int)self.level];
    NSNumber* finalScore = [NSNumber numberWithInt:(int)self.score];
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
