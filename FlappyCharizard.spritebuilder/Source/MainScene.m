//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//
#import "MainScene.h"

@implementation MainScene {
    CCButton *_level1;
    CCButton *_level2;
    CCButton *_level3;
    CCButton *_level4;
}

- (void)didLoadFromCCB {
    [[OALSimpleAudio sharedInstance] playBg:@"dark_cave.mp3" loop:YES];
}

-(void) onLevel1Pressed {
    [self handleWithDifficulty: 1];
}
-(void) onLevel2Pressed {
    [self handleWithDifficulty: 2];
}
-(void) onLevel3Pressed {
    [self handleWithDifficulty: 3];
}
-(void) onLevel4Pressed {
    [self handleWithDifficulty: 4];
}

- (void) handleWithDifficulty: (int) i {
    Level *level = (Level*)[CCBReader load:@"Level"];
    [level initialize: i];
    CCScene * s = [[CCScene alloc]init];
    [s addChild:level];
    [[CCDirector sharedDirector] replaceScene:s];
}

@end