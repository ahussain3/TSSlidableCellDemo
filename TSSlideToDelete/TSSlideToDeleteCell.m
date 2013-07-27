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
        NSLog(@"Gesture State Ended ...");
        // Animate cell to correct final position
        
        slideState = TSSlideStateDormant;
    }
    
    [self nextResponder];
}

@end
