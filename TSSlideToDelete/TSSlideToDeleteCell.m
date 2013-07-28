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
    TSSlideStateToTheRight,
    TSSlideStateSliding
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
        pan.delegate = self;
        [self.contentView addGestureRecognizer:pan];
    
        slideState = TSSlideStateDormant;
        
        /*******************************/
        // Haven't had time to work the kinks out of two-way sliding //
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
    NSLog(@"Gesture Rec. State: %i", sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture State Ended");
    }
    
    UITableView *tableView = (UITableView *)self.superview;
    CGPoint translation = [sender translationInView:self];
    if (sender.state != UIGestureRecognizerStateChanged) {
        CGFloat theta =  (180 / M_PI) * atanf(translation.y / translation.x);
        NSLog(@"theta: %f", theta);
        if (fabsf(theta) > 20.0) {
            tableView.scrollEnabled = YES;
            return;
        } else {
            tableView.scrollEnabled = NO;
        }
    }
    
    CGFloat xThreshold = 100.0;
    CGFloat xOffset = self.contentView.center.x - self.center.x;
    CGFloat yCenter = self.contentView.center.y;
    CGFloat finalXPosition = self.center.x;
    
    if (translation.x < 0 && !(self.slideLeftDisabled && slideState == TSSlideStateDormant)) {
        [self showViewsForSlideState:TSSlideStateToTheLeft];
        slideState = TSSlideStateToTheLeft;
        
        self.contentView.center = CGPointMake(self.contentView.center.x + translation.x, self.contentView.center.y);
        self.selectedBackgroundView.center = CGPointMake(self.selectedBackgroundView.center.x + translation.x, self.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self];
        
    } else if (translation.x > 0 && !(self.slideRightDisabled && slideState == TSSlideStateDormant)) {
        [self showViewsForSlideState:TSSlideStateToTheRight];
        slideState = TSSlideStateToTheRight;
        self.contentView.center = CGPointMake(fminf(self.contentView.center.x + translation.x, self.center.x), self.contentView.center.y);
        self.selectedBackgroundView.center = CGPointMake(fminf(self.selectedBackgroundView.center.x + translation.x, self.center.x), self.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self];
    }
    
    if (xOffset < -xThreshold) {self.slideToLeftView.hidden = YES; self.slideToLeftHighlightedView.hidden = NO;}
    else {self.slideToLeftView.hidden = NO; self.slideToLeftHighlightedView.hidden = NO;}
    if (xOffset > xThreshold) {self.slideToRightView.hidden = YES; self.slideToRightHighlightedView.hidden = NO;}
    else {self.slideToRightView.hidden = NO; self.slideToRightHighlightedView.hidden = NO;}
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        // Animate cell to correct final position
        if (slideState == TSSlideStateToTheLeft && xOffset < -xThreshold) {
            finalXPosition = -(self.contentView.bounds.size.width  / 2.0 + xThreshold);
            [self.delegate respondToCellSlidLeft:self];

        }
        if (slideState == TSSlideStateToTheRight && xOffset > xThreshold) {
            finalXPosition = (self.contentView.bounds.size.width  * 1.5) + xThreshold;
            [self.delegate respondToCellSlidRight:self];
        }
        
        CGPoint finalCenterPosition = CGPointMake(finalXPosition, yCenter);
        CGPoint velocity = [sender velocityInView:self];
        NSTimeInterval duration = fmaxf(0.1f,fminf(0.3f, fabs((xOffset - finalXPosition) / velocity.x)));
 
        [UIView animateWithDuration:duration animations:^{
            self.contentView.center = finalCenterPosition;
            self.selectedBackgroundView.center = finalCenterPosition;
        } completion:^(BOOL completion){

        }];
        
        slideState = TSSlideStateDormant;
        tableView.scrollEnabled = YES;
    }
}

- (void)resetSlidableCell {
    // This is called to make the cell reusable
    
}

#pragma  mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
