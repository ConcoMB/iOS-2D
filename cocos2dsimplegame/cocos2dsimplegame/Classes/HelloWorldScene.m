//
//  HelloWorldScene.m
//  Cocos2DSimpleGame
//
//  Created by Martin Walsh on 18/01/2014.
//  Copyright Razeware LLC 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    // 1
    CCSprite *_player;
    CCPhysicsNode *_physicsWorld;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // 2
    self = [super init];
    if (!self) return(nil);
    
    // 3
    self.userInteractionEnabled = YES;
    
    [[OALSimpleAudio sharedInstance] playBg:@"background-music-aac.caf" loop:YES];
    
    // 4
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    [self addChild:background];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
    // 5
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.position  = ccp(self.contentSize.width/8,self.contentSize.height/2);
    _player.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _player.contentSize} cornerRadius:0]; // 1
    _player.physicsBody.collisionGroup = @"playerGroup"; // 2
    [_physicsWorld addChild:_player];
    
    // 6
    //CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
    //[_player runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // 7
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Score:" fontName:@"Arial" fontSize:20];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.1f, 0.9f); // Middle of screen
    [self addChild:label];
    
    self.scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", self.score] fontName:@"Arial" fontSize:20];
    self.scoreLabel.positionType = CCPositionTypeNormalized;
    self.scoreLabel.color = [CCColor whiteColor];
    self.scoreLabel.position = ccp(0.1f, 0.95f); // Middle of screen
    [self addChild:self.scoreLabel];

	return self;
}

- (void)addMonster:(CCTime)dt {
    
    Monster *monster = [Monster initMonster];

    // 1
    int minY = monster.contentSize.height / 2;
    int maxY = self.contentSize.height - monster.contentSize.height / 2;
    int rangeY = maxY - minY;
    int randomY = (arc4random() % rangeY) + minY;
    
    // 2
    monster.position = CGPointMake(self.contentSize.width + monster.contentSize.width/2, randomY);
    monster.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, monster.contentSize} cornerRadius:0];
    monster.physicsBody.collisionGroup = @"monsterGroup";
    monster.physicsBody.collisionType  = @"monsterCollision";
    [_physicsWorld addChild:monster];
    
    // 3
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int randomDuration = (arc4random() % rangeDuration) + minDuration;
    
    // 4
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:randomDuration position:CGPointMake(-monster.contentSize.width/2, randomY)];
    CCAction *actionRemove = [CCActionRemove action];
    CCAction *actionLoose = [CCActionCallFunc actionWithTarget:self selector:@selector(loose)];
    [monster runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove, actionLoose]]];
}

// -----------------------------------------------------------------------

- (void)loose {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You lost!" message:@"The phantoms ate your soul" delegate: self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [[CCDirector sharedDirector] pause];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[CCDirector sharedDirector] pushScene:[IntroScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
    [[CCDirector sharedDirector] resume];
}

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden
    
    [self schedule:@selector(addMonster:) interval:1.5];
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // 1
    CGPoint touchLocation = [touch locationInNode:self];
    
    // 2
    CGPoint offset    = ccpSub(touchLocation, _player.position);
    float   ratio     = offset.y/offset.x;
    int     targetX   = _player.contentSize.width/2 + self.contentSize.width;
    int     targetY   = (targetX*ratio) + _player.position.y;
    CGPoint targetPosition = ccp(targetX,targetY);
    
    // 3
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.position = _player.position;
    projectile.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:projectile.contentSize.width/2.0f andCenter:projectile.anchorPointInPoints];
    projectile.physicsBody.collisionGroup = @"playerGroup";
    projectile.physicsBody.collisionType  = @"projectileCollision";
    [_physicsWorld addChild:projectile];
    
    // 4
    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
    CCActionRemove *actionRemove = [CCActionRemove action];
    [projectile runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
    [[OALSimpleAudio sharedInstance] playEffect:@"pew-pew-lei.caf"];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair projectileCollision:(CCNode *)projectile monsterCollision:(Monster *)monster {
    switch ([monster harm]) {
        case 2:
            [monster setColor:[CCColor blueColor]];
            break;
        case 1:
            [monster setColor:[CCColor yellowColor]];
            break;
        case 0:
            [monster setColor:[CCColor redColor]];
            [monster removeFromParent];
            [self.scoreLabel setString:[NSString stringWithFormat:@"%d", ++self.score]];
            break;
        default:
            break;
    }
    [projectile removeFromParent];
    return YES;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end