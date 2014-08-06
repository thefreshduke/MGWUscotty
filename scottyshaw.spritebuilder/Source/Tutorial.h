//
//  Tutorial.h
//  scottyshaw
//
//  Created by Scotty Shaw on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Tutorial : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, strong) NSMutableArray* enemyArray;
@property (nonatomic, strong) NSMutableArray* playerProjectileArray;
@property (nonatomic, strong) NSMutableArray* enemyProjectileArray;

@end
