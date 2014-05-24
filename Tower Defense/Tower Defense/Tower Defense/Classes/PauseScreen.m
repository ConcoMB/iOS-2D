//
//  PauseScreen.m
//  Tower Defense
//
//  Created by Conrado MB on 5/21/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "PauseScreen.h"

@implementation PauseScreen

-(id) init {
    self = [self.class nodeWithColor:[CCColor blackColor]];
    if (!self) return(nil);
    [self setOpacity:0.7];
    [self setPosition:ccp(0,0)];
    self.userInteractionEnabled = true;
    
    CCButton * resumeButton = [CCButton buttonWithTitle:@"RESUME"];
    [resumeButton setColor: [CCColor whiteColor]];
    [resumeButton setScaleX:1.5f];
    [resumeButton setScaleY:1.5f];
    resumeButton.positionType = CCPositionTypeNormalized;
    resumeButton.position = ccp(0.5f, 0.55f);
    [resumeButton setTarget:self selector:@selector(onResumeButtonClicked:)];
    [self addChild:resumeButton];
    
	CCButton * quitButton = [CCButton buttonWithTitle:@"QUIT"];
    [quitButton setColor: [CCColor whiteColor]];
    [quitButton setScaleX:1.5f];
    [quitButton setScaleY:1.5f];
    quitButton.positionType = CCPositionTypeNormalized;
    quitButton.position = ccp(0.5f, 0.45f);
    [quitButton setTarget:self selector:@selector(onQuitButtonClicked:)];
    [self addChild:quitButton];
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
}

- (void)onQuitButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.2f]];
}

- (void)onResumeButtonClicked:(id)sender
{
    [_parent removeChild:self];
    [[CCDirector sharedDirector] resume];
}

@end
