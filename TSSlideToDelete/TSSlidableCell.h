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

//*********************************************************************/
/*
 
NOTE!!
 I haven't had time to work the kinks out of the 'slideToTheRight' feature, so at the moment, behaviour is only predictable if you are sliding to the left only. 
 Slide to the right is disabled by default.
 
IMPLEMENTATION NOTES:

1) Import TSSLidableCell.m/h into your project.
 
2) In your custom UITableViewCell, subclass TSSlidableCell instead of UITableViewCell.

3) This class supports slides to the left and to the right. You can disable either of these directions by setting the flags: BOOL slide[Left/Right]Disabled.
 
4) To ensure the class works as intended, in your UITableViewController, you must:
 
    4.a) Set this class's delegate, and implement the -(void)respondToCellSlid[Left/Right] method.
 
    4.b) Set the slideTo[Left/Right]View and slideTo[Left/Right]HighlightedView. The 'highlighted' view is shown when the cell has been dragged sufficiently far to one side, such that releasing it will cause it to animate off screen. If you do not wish to implement a 'highlighted' view, set it to be the same as the slideTo[Left/Right]View.

*/
/***********************************************************************/

#import <UIKit/UIKit.h>
@class TSSlidableCell;

@protocol TSSlideToDeleteCellDelegate <NSObject>
@optional
-(void)respondToCellSlidLeft:(TSSlidableCell *)cell;
-(void)respondToCellSlidRight:(TSSlidableCell *)cell;
@end

@interface TSSlidableCell : UITableViewCell <UIGestureRecognizerDelegate> {
    NSUInteger slideState;
}

// Configuration settings
@property (nonatomic) BOOL slideLeftDisabled;
@property (nonatomic) BOOL slideRightDisabled;

// Subclass should assign these views. The cell will slide out of the way to reveal these views.
@property (nonatomic, strong) UIView *slideToLeftView;
@property (nonatomic, strong) UIView *slideToRightView;
@property (nonatomic, strong) UIView *slideToLeftHighlightedView;
@property (nonatomic, strong) UIView *slideToRightHighlightedView;

@property (nonatomic, strong) id<TSSlideToDeleteCellDelegate> delegate;

@end
