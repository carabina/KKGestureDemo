//
//  KKGestureBackView.m
//  KKSideViewController
//
//  Created by MR.KING on 16/7/15.
//  Copyright © 2016年 KING. All rights reserved.
//

#import "KKGestureBackView.h"

#import "KKGestureItem.h"

#import "KKGestureLineView.h"

#import "UIView+KKFrame.h"

NSString * const KKTrackActiveItemRadius = @"itemTrackItemRadius";

@interface KKGestureBackView()
{
    CGPoint * _points;
}
/// 代表点的个数
@property(nonatomic,assign)int count;

@property(nonatomic,assign)CGPoint * points;
@property(nonatomic,strong)NSMutableArray * arrForgViews;
@property(nonatomic,strong)NSMutableArray * arrBackViews;

@property(nonatomic,assign)CGFloat itemRadius;
@property(nonatomic,assign)CGFloat itemInRadius;
@property(nonatomic,assign)NSTimeInterval errorDuraiton;

@property(nonatomic,strong)KKGestureLineView * lineView;

@property(nonatomic,strong)NSMutableArray * arrItems;

@property(nonatomic,assign)KKGestureViewState state;

@property(nonatomic,copy)KKGestureViewState(^ResultBackBlock)(int count);

@property(nonatomic,copy)void(^StateChangeBlock)(KKGestureViewState newState, KKGestureViewState oldState);
@end

@implementation KKGestureBackView

- (instancetype)initWithPoints:(CGPoint*)points
                         count:(int)count
                        radius:(CGFloat)radius
                      inRadius:(CGFloat)inRadius
                 errorDuration:(double)errorDuration
                        result:(KKGestureViewState(^)(int count))result
                         state:(void(^)(KKGestureViewState newState, KKGestureViewState oldState))stateBlock
{
    self = [super init];
    if (self) {
        _arrForgViews = [[NSMutableArray alloc]init];
        _arrBackViews = [[NSMutableArray alloc]init];
        _arrItems = [[NSMutableArray alloc]init];
        _ResultBackBlock = result;
        _StateChangeBlock = stateBlock;
        _errorDuraiton = errorDuration;
        _count = count;
        _points = points;
        _itemRadius = radius;
        _itemInRadius = inRadius;
        _state = KKGestureViewStateNormal;
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                      points:(CGPoint*)points
                       count:(int)count
                      radius:(CGFloat)radius 
                    inRadius:(CGFloat)inRadius
               errorDuration:(double)errorDuration
                      result:(KKGestureViewState(^)(int count))result
                       state:(void(^)(KKGestureViewState newState, KKGestureViewState oldState))stateBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _arrForgViews = [[NSMutableArray alloc]init];
        _arrBackViews = [[NSMutableArray alloc]init];
        _arrItems = [[NSMutableArray alloc]init];
        _ResultBackBlock = result;
        _StateChangeBlock = stateBlock;
        _errorDuraiton = errorDuration;
        _count = count;
        _points = points;
        _itemRadius = radius;
        _itemInRadius = inRadius;
        [self initView];
    }
    return self;
}

-(void)setNewPoints:(CGPoint *)point count:(int)count{
    
    _points = point;
    
    if (self.arrBackViews.count && (self.arrForgViews.count)) {
        BOOL needCreat = NO;
        for (int i = 0; i < MAX(count, _count); i++) {
            KKGestureItem * itemIn = self.arrForgViews[i];
            KKGestureItem * itemBack = self.arrBackViews[i];
            if (i <= MIN(count, _count)) {
                itemIn.center = point[i];
                itemBack.center = point[i];
            }else{
                if (count > _count) {
                    needCreat = YES;
                }else{
                    [itemIn removeFromSuperview];
                    [itemBack removeFromSuperview];
                    [self.arrForgViews removeObject:itemIn];
                    [self.arrBackViews removeObject:itemBack];
                }
            }
        }
        if (needCreat) {
            for (int i = _count + 1; i < count; i++) {
                
                KKGestureBackItem * inItem = [[KKGestureBackItem alloc]init];
                inItem.bounds = CGRectMake(0, 0, self.itemRadius * 2, self.itemRadius * 2);
                inItem.center = self.points[i];
                inItem.backgroundColor = [UIColor clearColor];
                [self addSubview:inItem];
                [self.arrBackViews addObject:inItem];
            }
            for (int i = 0; i < self.count; i++) {
                KKGestureForgroundItem * item = [[KKGestureForgroundItem alloc]init];
                item.bounds = CGRectMake(0, 0, self.itemInRadius * 2, self.itemInRadius * 2);
                item.center = self.points[i];
                item.backgroundColor = [UIColor clearColor];
                [self addSubview:item];
                [self.arrForgViews addObject:item];
            }
        }
    }
    _count = count;
    [_lineView setPoints:point];
}

-(void)setState:(KKGestureViewState)state{
    if (self.StateChangeBlock) {
        self.StateChangeBlock(state,_state);
    }
    _state = state;
}

-(void)changeToState:(KKGestureItemState)state{
    for (KKGestureItem * item in self.arrForgViews) {
        item.state = state;
    }
    for (KKGestureItem * item in self.arrBackViews) {
        item.state = state;
    }
}

-(void)changeToState:(KKGestureItemState)state atIndex:(int)index{
    ((KKGestureItem*)self.arrForgViews[index]).state = state;
    ((KKGestureItem*)self.arrBackViews[index]).state = state;
}

-(void)initView{
    for (int i = 0; i < self.count; i++) {
        
        KKGestureBackItem * inItem = [[KKGestureBackItem alloc]init];
        inItem.bounds = CGRectMake(0, 0, self.itemRadius * 2, self.itemRadius * 2);
        inItem.center = self.points[i];
        inItem.backgroundColor = [UIColor clearColor];
        [self addSubview:inItem];
        [self.arrBackViews addObject:inItem];
    }
    for (int i = 0; i < self.count; i++) {
        KKGestureForgroundItem * item = [[KKGestureForgroundItem alloc]init];
        item.bounds = CGRectMake(0, 0, self.itemInRadius * 2, self.itemInRadius * 2);
        item.center = self.points[i];
        item.backgroundColor = [UIColor clearColor];
        [self addSubview:item];
        [self.arrForgViews addObject:item];
    }
    
    _lineView = [[KKGestureLineView alloc]initWithPoints:self.points];
    _lineView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self insertSubview:_lineView belowSubview:self.arrForgViews.firstObject];
}

-(void)needUpConfigureValue:(id)value keyPath:(NSString *)keyPath{
    
    if ([keyPath rangeOfString:@"line"].location != NSNotFound) {
        [_lineView setValue:value forKey:keyPath];
        return;
    }
    
    
    // 只是更新半径，则不重新布局
    if ([keyPath isEqualToString:KKTrackActiveItemRadius]) {
        _itemRadius = [value doubleValue];
        return;
    }
    
    NSString * realPath = ([keyPath rangeOfString:@"In"].location == NSNotFound)?keyPath:[keyPath stringByReplacingOccurrencesOfString:@"In" withString:@""];
    
    // 大圆
    if ([keyPath rangeOfString:@"In"].location == NSNotFound) {
        for (KKGestureItem *item in self.arrBackViews) {
            [item setValue:value forKey:realPath];
        }
    }else{
        for (KKGestureItem *item in self.arrForgViews) {
            [item setValue:value forKey:realPath];
        }
    }
    
    
    
}

-(void)beginErrorState{
    self.state = KKGestureViewStateError;
    for (NSNumber * num in _arrItems) {
        [self changeToState:KKGestureItemStateError atIndex:num.intValue];
    }
    _lineView.error = YES;
    [self performSelector:@selector(reset) withObject:nil afterDelay:self.errorDuraiton];
}

-(void)reset{
    [_lineView reset];
    [_arrItems removeAllObjects];
    [self changeToState:KKGestureItemStateNoraml];
    self.state = KKGestureViewStateNormal;
}

-(void)endMove{
    KKGestureViewState state;
    if (self.ResultBackBlock && _arrItems.count) {
        state = self.ResultBackBlock((int)_arrItems.count);
    }
    
    if (state == KKGestureViewStateError) {
        [self beginErrorState];
    }else if (state == KKGestureViewStateNormal){
        [self reset];
    }
}

-(void)saveForNewItem:(int)index{
    if ([_arrItems containsObject:@(index)]) {
        return;
    }
    if (_arrItems.count == 0) {
        self.state = KKGestureViewStateNormal;
    }
    [_arrItems addObject:@(index)];
}


-(void)gestureTrackView:(KKGestureTrackView *)gestureTrackView moveToNewPoint:(CGPoint)point{
    if (self.state == KKGestureViewStateError) {
        return;
    }
    [self.lineView moveToPoint:point];
}

-(void)gestureTrackView:(KKGestureTrackView *)gestureTrackView moveToNewItem:(int)index point:(CGPoint)newPoint{
    if (self.state == KKGestureViewStateError) {
        return;
    }
    [self saveForNewItem:index];
    [self changeToState:KKGestureItemStateSeleted atIndex:index];
    [_lineView moveToItem:index point:newPoint];
}

-(void)gestureTrackViewEndTrack:(KKGestureTrackView *)gestureTrackView{
    if (self.state == KKGestureViewStateError) {
        return;
    }
    [_lineView endMove];
    [self endMove];
}

-(void)layoutSubviews{
    _lineView.bounds = CGRectMake(0, 0, self.kk_width, self.kk_height);
    _lineView.center = CGPointMake(self.kk_width / 2.0, self.kk_height / 2.0);
}



@end
