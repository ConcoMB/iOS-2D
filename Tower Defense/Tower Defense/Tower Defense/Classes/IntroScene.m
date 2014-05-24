//
//  IntroScene.m
//  Tower Defense
//
//  Created by Conrado MB on 3/30/14.
//  Copyright Conrado MB 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "PlayScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    CCSprite *background = [CCSprite spriteWithImageNamed:@"welcome.png"];
    [background setScale:0.5];
    [background setAnchorPoint:CGPointMake(0, 0)];
    [background setPosition:CGPointMake(0, 0)];
    [self addChild:background z:0];
    
    // Hello world
    CCLabelTTF *pokemon = [CCLabelTTF labelWithString:@"Pokemon" fontName:@"Zapfino" fontSize:36.0f];
    pokemon.positionType = CCPositionTypeNormalized;
    pokemon.color = [CCColor yellowColor];
    pokemon.position = ccp(0.5f, 0.8f); // Middle of screen
    [self addChild:pokemon];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tower Defense" fontName:@"Zapfino" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor yellowColor];
    label.position = ccp(0.5f, 0.5f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *playButton = [CCButton buttonWithTitle:@"Play" fontName:@"Verdana-Bold" fontSize:18.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.25f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playButton];
    
    CCParticleFire * fire = [[CCParticleFire alloc] init];
    fire.positionType = CCPositionTypeNormalized;
    [fire setPosition: ccp(0.85f, 0.6f)];
    [fire setColor:[CCColor redColor]];
    [fire setScaleX:0.5f];
    [fire setScaleY:0.5f];
    [fire setGravity:CGPointMake(50, -150)];
    [self addChild:fire];
    
    [[OALSimpleAudio sharedInstance] playBg:@"intro.mp3" loop:YES];
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[PlayScene scene]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionUp duration:0.2f]];
}

// -----------------------------------------------------------------------
@end
