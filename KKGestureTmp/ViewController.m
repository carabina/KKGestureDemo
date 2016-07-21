
//
//  ViewController.m
//  KKGestureTmp
//
//  Created by MR.KING on 16/7/16.
//  Copyright © 2016年 KING. All rights reserved.
//

#import "ViewController.h"

#import "KKGesture.h"

#import "SecViewController.h"

@interface ViewController ()<KKGestureViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    KKGestureView * view = [[KKGestureView alloc]initWithFrame:CGRectMake(0, 20, 320, 320)];
    [self.view addSubview:view];
    view.delegate = self;

    
}



/// 此次结束的时候连接的点的个数
-(KKGestureViewState)gestureView:(KKGestureView*)gestureView currentConnectPoints:(int)num{
    if (num <4) {
        return KKGestureViewStateError;
    }
    return KKGestureViewStateNormal;
}

/// 此次结束的时候状态的变化
-(void)gestureView:(KKGestureView*)gestureView
     changeToState:(KKGestureViewState)currentState
         fromState:(KKGestureViewState)fromState{
    
}

@end
