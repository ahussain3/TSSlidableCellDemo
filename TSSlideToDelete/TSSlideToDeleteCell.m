//
//  TSSlideToDeleteCell.m
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import "TSSlideToDeleteCell.h"

typedef enum {
    TSSlideStateDormant,
    TSSlideStateToTheLeft,
    TSSlideStateToTheRight
} TSSlideState;

@interface TSSlideToDeleteCell () {
    
}

@end

@implementation TSSlideToDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideGestureHandler:)];
        [self addGestureRecognizer:pan];
        
        slideState = TSSlideStateDormant;
        
        /*******************************/
        // Haven't had time to work the kinks out of two way sliding //
        self.slideRightDisabled = TRUE;
        /*******************************/
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.slideToLeftView != nil) {
        [self insertSubview:self.slideToLeftView aboveSubview:self.backgroundView];
    }
    if (self.slideToLeftHighlightedView != nil) {
        [self insertSubview:self.slideToLeftHighlightedView aboveSubview:self.backgroundView];
    }
    if (self.slideToRightView != nil) {
        [self insertSubview:self.slideToRightView aboveSubview:self.backgroundView];
    }
    if (self.slideToRightHighlightedView != nil) {
        [self insertSubview:self.slideToRightHighlightedView aboveSubview:self.backgroundView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showViewsForSlideState:(NSInteger)state {
    if (state == slideState) return;
    
//    Unfinished slide to the right feature. Feel free to play with it.
//    if (state == TSSlideStateToTheLeft) {
//        self.slideToLeftView.hidden = NO;
//        self.slideToLeftHighlightedView.hidden = NO;
//        self.slideToRightView.hidden = YES;
//        self.slideToRightHighlightedView.hidden = YES;
//        
//    } else if (state == TSSlideStateToTheRight) {
//        self.slideToLeftView.hidden = YES;
//        self.slideToLeftHighlightedView.hidden = YES;
//        self.slideToRightView.hidden = NO;
//        self.slideToRightHighlightedView.hidden = NO;
//        
//    } else {
//        self.slideToLeftView.hidden = NO;
//        self.slideToLeftHighlightedView.hidden = NO;
//        self.slideToRightView.hidden = NO;
//        self.slideToRightHighlightedView.hidden = NO;
//    }
}

- (void)slideGestureHandler:(UIPanGestureRecognizer *)sender {
    UITableViewCell * cell = (UITableViewCell *)sender.view;
    CGPoint translation = [sender translationInView:cell];
    
    CGFloat xThreshold = 100.0;
    CGFloat xOffset = cell.contentView.center.x - cell.center.x;
    CGFloat yCenter = cell.contentView.center.y;
    CGFloat finalXPosition = cell.center.x;
    
    if (translation.x < 0 && !(self.slideLeftDisabled && slideState == TSSlideStateDormant)) {
        [self showViewsForSlideState:TSSlideStateToTheLeft];
        slideState = TSSlideStateToTheLeft;
        
        cell.contentView.center = CGPointMake(cell.contentView.center.x + translation.x, cell.contentView.center.y);
        cell.selectedBackgroundView.center = CGPointMake(cell.selectedBackgroundView.center.x + translation.x, cell.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:cell];
        
    } else if (translation.x > 0 && !(self.slideRightDisabled && slideState == TSSlideStateDormant)) {
        [self showViewsForSlideState:TSSlideStateToTheRight];
        slideState = TSSlideStateToTheRight;
        cell.contentView.center = CGPointMake(cell.contentView.center.x + translation.x, cell.contentView.center.y);
        cell.selectedBackgroundView.center = CGPointMake(cell.selectedBackgroundView.center.x + translation.x, cell.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:cell];
    }
    
    if (xOffset < -xThreshold) {self.slideToLeftView.hidden = YES;}
    else {self.slideToLeftView.hidden = NO;}
    if (xOffset > xThreshold) {self.slideToRightView.hidden = YES;}
    else {self.slideToRightView.hidden = NO;}
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // Animate cell to correct final position
        if (xOffset < -xThreshold) {
            finalXPosition = -(cell.contentView.bounds.size.width  / 2.0 + xThreshold);
        }
        if (xOffset > xThreshold) {
            finalXPosition = (cell.contentView.bounds.size.width  * 1.5) + xThreshold;
        }
                
        CGPoint finalCenterPosition = CGPointMake(finalXPosition, yCenter);
        CGPoint velocity = [sender velocityInView:cell];
        NSTimeInterval duration = fmaxf(0.1f,fminf(0.3f, fabs((xOffset - finalXPosition) / velocity.x)));
 
        [UIView animateWithDuration:duration animations:^{
            cell.contentView.center = finalCenterPosition;
            cell.selectedBackgroundView.center = finalCenterPosition;
        } completion:^(BOOL completion){
            if (slideState == TSSlideStateToTheLeft) [self.delegate respondToCellSlidLeft:self];
            if (slideState == TSSlideStateToTheRight) [self.delegate respondToCellSlidRight:self];
        }];
        
        slideState = TSSlideStateDormant;
//        [self showViewsForSlideState:TSSlideStateDormant];
    }
    
    [self nextResponder];
}

@end
