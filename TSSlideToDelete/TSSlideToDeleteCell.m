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
    TSSLideStateToTheRight
} TSSLideState;

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
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!(self.slideToLeftView == nil)) {
        self.slideToLeftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.slideToLeftView aboveSubview:self.backgroundView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)slideGestureHandler:(UIPanGestureRecognizer *)sender {
    UITableViewCell * cell = (UITableViewCell *)sender.view;
    CGPoint translation = [sender translationInView:cell];
    
    CGFloat xThreshold = 50.0;
    
    if (translation.x < 0 && !(self.slideLeftDisabled && slideState == TSSlideStateDormant)) {
        slideState = TSSlideStateToTheLeft;
        cell.contentView.center = CGPointMake(cell.contentView.center.x + translation.x, cell.contentView.center.y);
        cell.selectedBackgroundView.center = CGPointMake(cell.selectedBackgroundView.center.x + translation.x, cell.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:cell];
        
    } else if (translation.x > 0 && !(self.slideRightDisabled && slideState == TSSlideStateDormant)) {
        slideState = TSSLideStateToTheRight;
        cell.contentView.center = CGPointMake(cell.contentView.center.x + translation.x, cell.contentView.center.y);
        cell.selectedBackgroundView.center = CGPointMake(cell.selectedBackgroundView.center.x + translation.x, cell.selectedBackgroundView.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:cell];
    }
    
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat xOffset = cell.contentView.center.x - cell.center.x;
        CGFloat yCenter = cell.contentView.center.y;
        CGFloat finalXPosition = cell.center.x;

        NSLog(@"x-offset of content view end of gesture: %f", cell.contentView.frame.origin.x);
        // Animate cell to correct final position
        if (slideState == TSSlideStateToTheLeft && xOffset < -xThreshold) {
            finalXPosition = -(cell.contentView.bounds.size.width  / 2.0);
        }
        if (slideState == TSSLideStateToTheRight && xOffset > xThreshold) {
            finalXPosition = (cell.contentView.bounds.size.width  * 1.5);
        }
                
        CGPoint finalCenterPosition = CGPointMake(finalXPosition, yCenter);
        [UIView animateWithDuration:0.3f animations:^{
            cell.contentView.center = finalCenterPosition;
            cell.selectedBackgroundView.center = finalCenterPosition;
            NSLog(@"x-position of content view after assignment: %f", cell.contentView.frame.origin.x);
        } completion:^(BOOL completion){
            NSLog(@"x-position of content view after animation: %f", cell.contentView.frame.origin.x);
        }];
        
        slideState = TSSlideStateDormant;
    }
    
    [self nextResponder];
}

@end
