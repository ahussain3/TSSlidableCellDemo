//
//  TSSlideToDeleteCell.m
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import "TSSlideToDeleteCell.h"

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
    
    
    
}

@end
