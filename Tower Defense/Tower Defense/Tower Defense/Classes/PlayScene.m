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
    _gold = 150;
    _towers = [NSMutableArray array];
    _occupiedTiles = [NSMutableSet set];
    _selectedTowerSprite = [CCSprite spriteWithImageNamed:@"selected_tower_sprite.png"];
    [self addChild:_selectedTowerSprite];
    
    CCLabelTTF * goldTxtLabel = [CCLabelTTF labelWithString:@"Gold: " fontName:@"Arial" fontSize:15];
    goldTxtLabel.positionType = CCPositionTypeNormalized;
    goldTxtLabel.color = [CCColor whiteColor];
    goldTxtLabel.position = ccp(0.12f, 0.05f);
    [self addChild:goldTxtLabel];
    
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
    
	return self;
}

- (void) calculateRoadTiles {
    NSMutableDictionary *point = [_objectGroup objectNamed:@"spawn"];
    int x = [[point valueForKey:@"x"] integerValue];
    int y = [[point valueForKey:@"y"] integerValue];
    [_occupiedTiles addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    while ([point objectForKey:@"next_y"]) {
        int x = [[point valueForKey:@"next_x"] integerValue];
        int y = [[point valueForKey:@"next_y"] integerValue];
        [_occupiedTiles addObject:[NSValue valueWithCGPoint:CGPointMake(y, x)]];
        point = [_objectGroup objectNamed: [NSString stringWithFormat:@"road_%i_%i", x, y]];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // 1
    if (_isEditMode && _selectedTower != NULL && _gold >= _selectedTowerPrice)
    {
        _gold -= _selectedTowerPrice;
        [_goldLabel setString: [@(_gold) stringValue]];
        CGPoint touchLocation = [touch locationInNode:self];
        int x = touchLocation.x / _tileSize.width;
        int y = 10 - touchLocation.y / _tileSize.height;

        CGPoint tilePoint = CGPointMake(x, y);
        if ([_occupiedTiles containsObject:[NSValue valueWithCGPoint:tilePoint]]) {
            return;
        }
        CCSprite * touchedTile = [_background tileAt:tilePoint];
        Tower * newTower = [Tower initTower:_selectedTower.name];
//        CCSprite * newTower = [CCSprite spriteWithImageNamed:_selectedTower.name];
        [newTower setPosition:CGPointMake(touchedTile.position.x + _tileSize.height / 2, touchedTile.position.y + _tileSize.width / 2)];
        [_towers addObject: newTower];
        [_occupiedTiles addObject: [NSValue valueWithCGPoint:tilePoint]];
        [self addChild:newTower];
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
    int x = [[tower valueForKey:@"x"] integerValue];
    int y = [[tower valueForKey:@"y"] integerValue];
    [towerButton setPosition:CGPointMake(x + _tileSize.width / 2, y + _tileSize.height / 2)];
    [towerButton setTarget:self selector:@selector(onTowerButtonClicked:)];
    [self addChild:towerButton];
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

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
    _isEditMode = false;
    Monster * monster = [Monster initMonsterWithLevel: 1 andFlies: NO];
    [monster setPosition: CGPointMake(_spawnPoint_x, _spawnPoint_y)];
}

- (void) updateGoldLabel
{
    [self.goldLabel setString: [NSString stringWithFormat:@"%i", self.gold]];
}


- (void) updateLevelLabel
{
    [self.levelLabel setString: [NSString stringWithFormat:@"%i", self.level]];
}

@end
