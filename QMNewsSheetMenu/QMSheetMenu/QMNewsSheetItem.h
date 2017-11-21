//
//  QMNewsSheetItem.h
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/16.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMNewsSheetItem;

typedef enum : NSUInteger{
    QMCornerFlagTypeNone,
    QMCornerFlagTypeDelet,
    QMCornerFlagTypeAddition,
    QMCornerFlagTypeCustom,
    
} QMCornerFlagType;

typedef void(^QMItmeLongPressBlock)(UILongPressGestureRecognizer *longPressGesture);
typedef void(^QMItemCloseBlock)(QMNewsSheetItem *item);

@interface QMNewsSheetItem : UIView

@property (nonatomic,assign) QMCornerFlagType      flagType;
@property (nonatomic,copy) QMItmeLongPressBlock          longPresBlock;
@property (nonatomic,copy) QMItemCloseBlock            itemCloseBlock;
@property (nonatomic,copy) NSString                   *itemTitle;
//@property (nonatomic,assign,getter=isGestureEnable) BOOL       longGestureEnable;
@property (nonatomic ,assign) BOOL             cornerFlagHidden;
@property (nonatomic ,assign) BOOL             longGestureEnable;


@end








