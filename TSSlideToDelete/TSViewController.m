//
//  TSViewController.m
//  TSSlideToDelete
//
//  Created by Awais Hussain on 7/27/13.
//  Copyright (c) 2013 TimeStamp. All rights reserved.
//

#import "TSViewController.h"
#import "TSTableViewCell.h"

#define CELL_HEIGHT 60.0

@interface TSViewController ()

@end

@implementation TSViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (arrayOfCells == nil) {
        NSInteger numberOfItems = 20;
        
        arrayOfCells = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        for (NSInteger ii = 0; ii < numberOfItems; ii++) {
            [arrayOfCells addObject:[NSString stringWithFormat:@"Cell #%i - Sample Text", ii + 1]];
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOfCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // It's a little hack-ish that we're not using dequeue cell. Keep number of table element small, or find a way to reuse cells without making everything look ugly.
    static NSString *CellIdentifier = @"Cell";
    TSSlidableCell *cell = [[TSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    CGRect cellFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, CELL_HEIGHT);
    cell.delegate = self;
    
    // Configure the cell...
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [arrayOfCells objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor purpleColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    cell.backgroundView = backgroundView;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Create slide views
    UIView *slideLeftView = [[UIView alloc] initWithFrame:cellFrame];
    slideLeftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UILabel *label = [[UILabel alloc] initWithFrame:slideLeftView.frame];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"Delete   ";
    label.textColor = [UIColor whiteColor];
    [slideLeftView addSubview:label];
    cell.slideToLeftView = slideLeftView;
    
    UIView *slideLeftHighlightedView = [[UIView alloc] initWithFrame:cellFrame];
    UILabel *redLabel = [[UILabel alloc] initWithFrame:slideLeftHighlightedView.frame];
    redLabel.font = [UIFont boldSystemFontOfSize:18.0];
    redLabel.backgroundColor = [UIColor lightGrayColor];
    redLabel.textAlignment = NSTextAlignmentRight;
    redLabel.text = @"Delete   ";
    redLabel.textColor = [UIColor purpleColor];
    [slideLeftHighlightedView addSubview:redLabel];
    cell.slideToLeftHighlightedView = slideLeftHighlightedView;

//    Uncomment to implement slide to the right
//    UIView *slideRightView = [[UIView alloc] initWithFrame:cellFrame];
//    slideRightView.backgroundColor = [UIColor greenColor];
//    cell.slideToRightView = slideRightView;

//    Uncomment to implement slide to the right
//    UIView *slideRightHighlightedView = [[UIView alloc] initWithFrame:cellFrame];
//    slideRightHighlightedView.backgroundColor = [UIColor blueColor];
//    cell.slideToRightHighlightedView = slideLeftHighlightedView;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark - TSSlideToDeleteCellDelegate

-(void)respondToCellSlidLeft:(TSSlidableCell *)cell {
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSLog(@"Deleted cell row: %i", indexPath.row);
        [arrayOfCells removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

@end
