//
//  TSSlideToDeleteCell.h
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSSlideToDeleteCell;

@protocol TSSlideToDeleteCellDelegate <NSObject>
@optional
-(void)respondToCellSlidLeft:(TSSlideToDeleteCell *)cell;
-(void)respondToCellSlidRight:(TSSlideToDeleteCell *)cell;
@end

@interface TSSlideToDeleteCell : UITableViewCell {
    NSUInteger slideState;
}

// Configuration settings
@property (nonatomic) BOOL slideLeftDisabled;
@property (nonatomic) BOOL slideRightDisabled;

// Subclass should assign these views. The cell will slide out of the way to reveal these views.
@property (nonatomic, strong) UIView *slideToLeftView;
@property (nonatomic, strong) UIView *slideToRightView;
@property (nonatomic, strong) UIView *slideToLeftHighlightedView;
@property (nonatomic, strong) UIView *slideToRightHighlightedView;

@property (nonatomic, strong) id<TSSlideToDeleteCellDelegate> delegate;

@end
