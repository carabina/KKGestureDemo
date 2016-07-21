//
//  KKGestureView.h
//  KKSideViewController
//
//  Created by MR.KING on 16/7/15.
//  Copyright © 2016年 KING. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKGestureView;


typedef enum : NSUInteger {
    KKGestureViewStateNormal, // 正常状态
    KKGestureViewStateConnecting, // 正在连接状态
    KKGestureViewStateError, // 错误状态
} KKGestureViewState;


/**
 *  delegate for KKGestureView
 */

@protocol KKGestureViewDelegate <NSObject>

/// 此次结束的时候连接的点的个数
-(KKGestureViewState)gestureView:(KKGestureView*)gestureView currentConnectPoints:(int)num;

/// 此次结束的时候状态的变化
-(void)gestureView:(KKGestureView*)gestureView
     changeToState:(KKGestureViewState)currentState
         fromState:(KKGestureViewState)fromState;

@end



/**
 *  手势视图
 */
@interface KKGestureView : UIView


/*!
 @property  手势的当前状态
 @abstract  标记手势的当前的状态 see KKGestureViewState
 */
@property(nonatomic,assign,readonly)KKGestureViewState state;

/*!
 @property  错误的状态下停留的时间 default is 2.0s
 @abstract  当 delegate 实现的方法 -gestureView:currentConnectPoints: 返回
            的状态为 `KKGestureViewStateError` ,进入错误状态
 */
@property(nonatomic,assign)NSTimeInterval errorDuration;

/**
 *  @property   delegate for KKGestureView
 *  @see        `KKGestureViewDelegate`
 */
@property(nonatomic,weak)id <KKGestureViewDelegate>delegate;

/// 标记当触摸点在是否触摸到内圆的时候，进行连线,default is YES
@property(nonatomic,assign)BOOL activeWhenInCycle;

/// 手势图层在本图层的边距
@property(nonatomic,assign)UIEdgeInsets edgeInsets;




/// ---- rows/\cols ----

/// 行数 default is 3
@property(nonatomic,assign)int rows;

/// 列数 default is 3
@property(nonatomic,assign)int cols;
/// 行间距
@property(nonatomic,assign,readonly)double rowsPad;

/// 列间距
@property(nonatomic,assign,readonly)double colsPad;



/// ---- line ----
/// 线条颜色 default is greenColor
@property(nonatomic,strong)UIColor * lineColor;

/// 错误状态下线条的颜色 default is redcolor
@property(nonatomic,strong)UIColor * lineErrorColor;

/// 线条的宽度
@property(nonatomic,assign)CGFloat lineWidth;



/// ---- backitem ----
/// 外边圆的半径
@property(nonatomic,assign)CGFloat itemRadius;

/// 大圆背景颜色
@property(nonatomic,strong)UIColor * itemBackGroundColor;

/// 大圆边框颜色
@property(nonatomic,strong)UIColor * itemBorderColor;

/// 大圆选中下的背景颜色
@property(nonatomic,strong)UIColor * itemSeletedBackGroundColor;

/// 大圆选中下的边框颜色
@property(nonatomic,strong)UIColor * itemSeletedBorderColor;

/// 大圆错误下的背景颜色
@property(nonatomic,strong)UIColor * itemErrorBackGroundColor;

/// 大圆错误下的边框颜色
@property(nonatomic,strong)UIColor * itemErrorBorderColor;

/// 大圆边框宽度
@property(nonatomic,assign)CGFloat itemBorderWidth;



/// ---- initem ----
/// 内圆的半径
@property(nonatomic,assign)CGFloat itemInRadius;

/// 小圆背景
@property(nonatomic,strong)UIColor * itemInBackGroundColor;

/// 小圆选中下的背景颜色
@property(nonatomic,strong)UIColor * itemInSeletedBackGroundColor;

/// 小圆选中下的边框颜色
@property(nonatomic,strong)UIColor * itemInSeletedBorderColor;

/// 小圆边框颜色
@property(nonatomic,strong)UIColor * itemInBorderColor;

/// 小圆错误下的背景颜色
@property(nonatomic,strong)UIColor * itemInErrorBackGroundColor;

/// 小圆错误下的边框颜色
@property(nonatomic,strong)UIColor * itemInErrorBorderColor;

/// 小圆边框宽度
@property(nonatomic,assign)CGFloat itemInBorderWidth;

/// 用于子类的重写，设置默认值
/// 使用子类重写是最快的一种集成的方式，需要设置默认值，格式如下
-(void)setDefaultData;
/*
_activeWhenInCycle = YES;

_state = KKGestureViewStateNormal;

_errorDuration = 2.0f;

_edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

_rows = 3;

_cols = 3;


_lineErrorColor = [UIColor redColor];

_lineWidth = 10.0f;

_lineColor = [UIColor greenColor];


_itemRadius = 30;

_itemBorderWidth = 5;

_itemBackGroundColor = [UIColor whiteColor];

_itemSeletedBackGroundColor = [UIColor cyanColor];

_itemBorderColor = [UIColor cyanColor];

_itemSeletedBorderColor = [UIColor redColor];

_itemErrorBackGroundColor = [UIColor redColor];

_itemErrorBorderColor = [UIColor blueColor];


_itemInRadius = 18;

_itemInBorderWidth = 2;

_itemInBackGroundColor = [UIColor blueColor];

_itemInBorderColor = [UIColor redColor];

_itemInSeletedBackGroundColor = [UIColor purpleColor];

_itemInSeletedBorderColor = [UIColor greenColor];

_itemInErrorBackGroundColor = [UIColor redColor];

_itemInErrorBorderColor = [UIColor blueColor];
*/

@end
