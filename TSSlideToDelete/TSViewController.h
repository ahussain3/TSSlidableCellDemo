//
//  TSViewController.h
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSTableViewCell.h"

@interface TSViewController : UITableViewController <TSSlideToDeleteCellDelegate> {
    NSMutableArray *arrayOfCells;
}

@end
