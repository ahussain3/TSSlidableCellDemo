//    The MIT License (MIT)
//
//    Copyright (c) 2013 ahussain3
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TSSlidableCell.h"

typedef enum {
    TSSlideStateDormant,
    TSSlideStateToTheLeft,
    TSSlideStateToTheRight,
    TSSlideStateSliding
} TSSlideState;

@interface TSSlidableCell () {
    
}

@end

@implementation TSSlidableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideGestureHandler:)];
        pan.delegate = self;
        [self.contentView addGestureRecognizer:pan];
    
        slideState = TSSlideStateDormant;
        
        // Slide right is not working properly. There are a few kinks to work out in terms of layering and showing/hiding the cell's subviews. Feel free to play around with it!
        self.slideRightDisabled = TRUE;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.slideToLeftView != nil) {
        if (self.backgroundView) [self insertSubview:self.slideToLeftView aboveSubview:self.backgroundView];
        else [self insertSubview:self.slideToLeftView atIndex:0];
    }
    if (self.slideToLeftHighlightedView != nil) {
        if (self.backgroundView) [self insertSubview:self.slideToLeftHighlightedView aboveSubview:self.backgroundView];
        else [self insertSubview:self.slideToLeftHighlightedView atIndex:0];
    }
    if (self.slideToRightView != nil) {
        if (self.backgroundView) [self insertSubview:self.slideToRightView aboveSubview:self.backgroundView];
        else [self insertSubview:self.slideToRightView atIndex:0];
    }
    if (self.slideToRightHighlightedView != nil) {
        if (self.backgroundView) [self insertSubview:self.slideToRightHighlightedView aboveSubview:self.backgroundView];
        else [self insertSubview:self.slideToRightHighlightedView atIndex:0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)slideGestureHandler:(UIPanGestureRecognizer *)sender {
    UITableView *tableView = (UITableView *)self.superview;
    CGPoint translation = [sender translationInView:self];
    if (slideState == TSSlideStateDormant) {
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
        slideState = TSSlideStateToTheLeft;
        
        self.contentView.center = CGPointMake(self.contentView.center.x + translation.x, self.contentView.center.y);
        self.selectedBackgroundView.center = CGPointMake(self.selectedBackgroundView.center.x + translation.x, self.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self];
        
    } else if (translation.x > 0 && !(self.slideRightDisabled && slideState == TSSlideStateDormant)) {
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
            if ([self.delegate respondsToSelector:@selector(respondToCellSlidLeft:)]){
                [self.delegate respondToCellSlidLeft:self];
            }
        }
        if (slideState == TSSlideStateToTheRight && xOffset > xThreshold) {
            finalXPosition = (self.contentView.bounds.size.width  * 1.5) + xThreshold;
            if ([self.delegate respondsToSelector:@selector(respondToCellSlidRight:)]){
                [self.delegate respondToCellSlidRight:self];
            }
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

- (void)resetCell {
    for (UIView *subview in self.releasePool) {
        if ([subview respondsToSelector:@selector(removeFromSuperview)]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma  mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
