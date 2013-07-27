//
//  TSSlideToDeleteCell.m
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import "TSSlideToDeleteCell.h"

typedef enum {
    TSSlideToTheLeft,
    TSSLideToTheRight
} TSSLideDirection;

@implementation TSSlideToDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureHandler:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dragGestureHandler:(UIPanGestureRecognizer *)sender {
    NSLog(@"Dragging...");
    
    UITableViewCell * cell = (UITableViewCell *)sender.view;
    CGPoint translation = [sender translationInView:cell];
    NSLog(@"translation.x = %f", translation.x);
    
    cell.contentView.center = CGPointMake(cell.contentView.center.x + translation.x, cell.contentView.center.y);
    cell.selectedBackgroundView.center = CGPointMake(cell.selectedBackgroundView.center.x + translation.x, cell.selectedBackgroundView.center.y);
    [sender setTranslation:CGPointMake(0, 0) inView:cell];
    
    
}

@end
