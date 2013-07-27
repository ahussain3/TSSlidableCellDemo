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

@implementation TSSlideToDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureHandler:)];
        [self addGestureRecognizer:pan];
        
        slideState = TSSlideStateDormant;
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dragGestureHandler:(UIPanGestureRecognizer *)sender {

    NSLog(@"Gesture recognizer state: %i", sender.state);
    
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
    } else {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture State Ended ...");
        // Animate cell to correct final position
        
        slideState = TSSlideStateDormant;
    }
    
    
}

@end
