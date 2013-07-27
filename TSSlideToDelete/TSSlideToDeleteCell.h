//
//  TSSlideToDeleteCell.h
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSSlideToDeleteCell : UITableViewCell {
    NSUInteger slideState;
}

@property (nonatomic) BOOL slideLeftDisabled;
@property (nonatomic) BOOL slideRightDisabled;

@end
