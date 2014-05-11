//
//  PlayScene.m
//  Tower Defense
//
//  Created by Conrado MB on 3/30/14.
//  Copyright (c) 2014 Conrado MB. All rights reserved.
//

#import "PlayScene.h"

@implementation PlayScene


+ (PlayScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    _tiledMap = [[CCTiledMap alloc]initWithFile:@"tileMap.tmx"];
    [self addChild:_tiledMap];
    
    _isEditMode = true;
    _level = 1;
    _gold = 50;
    _towers = [NSMutableArray array];
    _monsters = [NSMutableArray array];
    _occupiedTiles = [NSMutableSet set];
    _selectedTowerSprite = [CCSprite spriteWithImageNamed:@"selected_tower_sprite.png"];
    [_selectedTowerSprite setPosition:CGPointMake(-1, -1)];
    [self addChild:_selectedTowerSprite];
    
    CCLabelTTF * goldTxtLabel = [CCLabelTTF labelWithString:@"Gold: " fontName:@"Arial" fontSize:15];
    goldTxtLabel.positionType = CCPositionTypeNormalized;
    goldTxtLabel.color = [CCColor whiteColor];
    goldTxtLabel.position = ccp(0.12f, 0.05f);
    [self addChild:goldTxtLabel];
    
    _fireTiming = 0.0;
    
    CCLabelTTF * levelTxtLabel = [CCLabelTTF labelWithString:@"Level: " fontName:@"Arial" fontSize:15];
    levelTxtLabel.positionType = CCPositionTypeNormalized;
    levelTxtLabel.color = [CCColor whiteColor];
    levelTxtLabel.position = ccp(0.3f, 0.05f);
    [self addChild:levelTxtLabel];

    _goldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", self.gold] fontName:@"Arial" fontSize:15];
    _goldLabel.positionType = CCPositionTypeNormalized;
    _goldLabel.color = [CCColor whiteColor];
    _goldLabel.position = ccp(0.2f, 0.05f);
    [self addChild:_goldLabel];
    
    _levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", self.level] fontName:@"Arial" fontSize:15];
    _levelLabel.positionType = CCPositionTypeNormalized;
    _levelLabel.color = [CCColor whiteColor];
    _levelLabel.position = ccp(0.35f, 0.05f);
    [self addChild:_levelLabel];
    
    CCLabelTTF * priceTxtLabel = [CCLabelTTF labelWithString:@"Price: " fontName:@"Arial" fontSize:15];
    priceTxtLabel.positionType = CCPositionTypeNormalized;
    priceTxtLabel.color = [CCColor whiteColor];
    priceTxtLabel.position = ccp(0.45f, 0.05f);
    [self addChild:priceTxtLabel];
    
    _priceLabel = [CCLabelTTF labelWithString:@":" fontName:@"Arial" fontSize:15];
    _priceLabel.positionType = CCPositionTypeNormalized;
    _priceLabel.color = [CCColor whiteColor];
    _priceLabel.position = ccp(0.55f, 0.05f);
    [self addChild:_priceLabel];
    
    _background = [_tiledMap layerNamed:@"Background"];
    _objectGroup = [_tiledMap objectGroupNamed:@"Objects"];
    _roadGroup = [_tiledMap objectGroupNamed:@"Road"];
    _tileSize = [_tiledMap tileSize];
    
    _attackButton = [CCButton buttonWithTitle:@"ATTACK"];
    [_attackButton setColor: [CCColor redColor]];
//    [_attackButton setBackgroundColor:[CCColor redColor] forState:CCControlStateNormal];
//    [_attackButton setBackgroundColor:[CCColor grayColor] forState:CCControlStateDisabled];
    _attackButton.positionType = CCPositionTypeNormalized;
    _attackButton.position = ccp(0.9f, 0.05f);
    [_attackButton setTarget:self selector:@selector(onAttackButtonClicked:)];

    [self addChild:_attackButton];
    if(_objectGroup == NULL){
        return false;
    }
    
    
    [self setUpTowerButtons];
    [self calculateRoadTiles];
    
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:_physicsWorld];
    
	return self;
}

- (void) calculateRoadTiles
{
    NSMutableDictionary *point = [_roadGroup objectNamed:@"spawn"];
    _spawnPoint_x = (int)[[point valueForKey:@"x"] integerValue];
    _spawnPoint_y = (int)[[point valueForKey:@"y"] integerValue];
    [_occupiedTiles addObject:[NSValue valueWithCGPoint:[self getTilePointOnX: _spawnPoint_x andY: _spawnPoint_y]]];
    
    for (int i = 1; i < 42; i++) {
        NSMutableDictionary *point = [_roadGroup objectNamed:[NSString stringWithFormat:@"%i", i]];
        NSInteger x = [[point valueForKey:@"x"] integerValue];
        NSInteger y = [[point valueForKey:@"y"] integerValue];
        [_occupiedTiles addObject:[NSValue valueWithCGPoint:[self getTilePointOnX: (int)x andY: (int)y]]];
    }
    for (int i = 0; i < 10; i++) {
        [_occupiedTiles addObject:[NSValue valueWithCGPoint:CGPointMake(0, i)]];
    }
    
    for (int j = 0; j < 15; j++) {
        [_occupiedTiles addObject:[NSValue valueWithCGPoint:CGPointMake(j, 9)]];
    }
}

- (CGPoint) getTilePointOnX: (int)x andY: (int)y
{
    int tx = x / _tileSize.width;
    int ty = 10 - y / _tileSize.height;
    return CGPointMake(tx, ty);
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // 1
    if (_isEditMode && _selectedTower != NULL && _gold >= _selectedTowerPrice)
    {
        CGPoint touchLocation = [touch locationInNode:self];

        CGPoint tilePoint = [self getTilePointOnX:touchLocation.x andY: touchLocation.y];
        if ([_occupiedTiles containsObject:[NSValue valueWithCGPoint:tilePoint]]) {
            return;
        }
        _gold -= _selectedTowerPrice;
        [_goldLabel setString: [@(_gold) stringValue]];
        CCSprite * touchedTile = [_background tileAt:tilePoint];
        Tower * newTower = [Tower initTower:_selectedTower.name];
//        CCSprite * newTower = [CCSprite spriteWithImageNamed:_selectedTower.name];
        [newTower setPosition:CGPointMake(touchedTile.position.x, touchedTile.position.y)];
        [_towers addObject: newTower];
        [_occupiedTiles addObject: [NSValue valueWithCGPoint:tilePoint]];
        [self addChild:newTower];
    }
}

- (void) monsterArrivedToEnd
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You lost!" message:@"The pokemons ate your soul" delegate: self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.2f]];
}

- (void) update:(CCTime)delta {
    if (_isEditMode == NO) {
        _fireTiming += delta;
        
        if ( _fireTiming >= 1.0f ) {
            _fireTiming -= 1.0f;
            
            for (Tower * t in _towers) {
                int minDistance = INFINITY;
                Monster * minDistanceMonster;
                for (Monster * m in _monsters) {
                    if ([t canHitMonster: m]) {
                        int d = ccpDistance(t.position, m.position);
                        if (d < 100 && d < minDistance){
                            minDistance = d;
                            minDistanceMonster = m;
                        }
                    }
                }
                if (minDistanceMonster != nil) {
                    Fire * fire = [Fire initFireWithDamage: t.level];
                    [fire setPosition: CGPointMake(t.position.x + _tileSize.height /2, t.position.y + _tileSize.width / 2)];
                    [_physicsWorld addChild:fire];
                    
                    CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:0.2f position:minDistanceMonster.position];
                    CCActionRemove *actionRemove = [CCActionRemove action];
                    [fire runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
                }
            }
        }
    }
}

- (void) setUpTowerButtons
{
    [self setUpTowerWithSprite: @"land_1.png" andObject: @"land_1"];
    [self setUpTowerWithSprite: @"land_2.png" andObject: @"land_2"];
    [self setUpTowerWithSprite: @"land_3.png" andObject: @"land_3"];
    [self setUpTowerWithSprite: @"land_4.png" andObject: @"land_4"];
    [self setUpTowerWithSprite: @"air_1.png" andObject: @"air_1"];
    [self setUpTowerWithSprite: @"air_2.png" andObject: @"air_2"];
    [self setUpTowerWithSprite: @"air_3.png" andObject: @"air_3"];
    [self setUpTowerWithSprite: @"land_and_air_1.png" andObject: @"land_and_air_1"];
    [self setUpTowerWithSprite: @"land_and_air_2.png" andObject: @"land_and_air_2"];
    [self setUpTowerWithSprite: @"land_and_air_3.png" andObject: @"land_and_air_3"];
}

- (void) setUpTowerWithSprite: sprite andObject: object {
    CCSpriteFrame *image = [CCSpriteFrame frameWithImageNamed:sprite];
    CCButton * towerButton =  [CCButton buttonWithTitle: @"" spriteFrame:image];
    NSMutableDictionary * tower = [_objectGroup objectNamed: object];
    towerButton.name = sprite;
    int x = (int)[[tower valueForKey:@"x"] integerValue];
    int y = (int)[[tower valueForKey:@"y"] integerValue];
    [towerButton setPosition:CGPointMake(x + _tileSize.width / 2, y + _tileSize.height / 2)];
    [towerButton setTarget:self selector:@selector(onTowerButtonClicked:)];
    [self addChild:towerButton];
}

- (void)onTowerButtonClicked:(id)sender
{
    _selectedTower = sender;
    int y = [(CCButton*)sender position].y / _tileSize.height;
    [_selectedTowerSprite setPosition:CGPointMake(_tileSize.width / 2, y * _tileSize.height + _tileSize.height / 2)];
    
    Tower * tower = [Tower initTower:_selectedTower.name];
    _selectedTowerPrice = tower.price;
    [_priceLabel setString:[@(tower.price) stringValue]];

}

- (void)onAttackButtonClicked:(id)sender
{
    if (_isEditMode)
    {
        _isEditMode = false;
        [self setMonstersForLevel:_level];
        int i = 0;
        for (Monster * monster in _monsters) {
            [monster scheduleOnce: @selector(spawn) delay:i];
            i++;
        }
    }
}

- (void) levelUp {
    _isEditMode = YES;
    _level++;
    if (_level == 11) {
        _levelLabel.string = [NSString stringWithFormat:@"%i", _level];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You won the game!" message:@"You caught them all" delegate: self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    } else {
        _levelLabel.string = [NSString stringWithFormat:@"%i", _level];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Vicotry!" message:@"Gotta catch'em all" delegate: self cancelButtonTitle:nil otherButtonTitles: @"Great", nil];
        [alert show];

    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"You won the game!"]) {
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.2f]];
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair fireCollision:(Fire *)fire monsterCollision:(Monster *)monster {
    if ([monster harm: fire.damage]) {
        [_monsters removeObject:monster];
        [monster removeFromParent];
        _gold = _gold += monster.gold;
        _goldLabel.string = [NSString stringWithFormat:@"%i", _gold];
        if ([_monsters firstObject] == NULL) {
            [self levelUp];
        }
    }
    [fire removeFromParent];
    return YES;
}

- (void) setMonstersForLevel: (int) level {
    if (level == 1) {
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 1 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 2){
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 1 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 1 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 3){
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 2 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 4){
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 2 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 2 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 5){
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 6){
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 7){
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 3; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 3 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 8){
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 4 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        
    } else if (level == 9){
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 4 andFlies: NO inGame:self];
            [_monsters addObject:monster];
        }
        for (int i = 0; i < 5; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 4 andFlies: YES inGame:self];
            [_monsters addObject:monster];
        }
    } else if (level == 10){
        for (int i = 0; i < 10; i++) {
            Monster * monster = [Monster initMonsterWithLevel: 4 andFlies: i % 2 == 0 inGame:self];
            [_monsters addObject:monster];
        }
    }
}

@end
