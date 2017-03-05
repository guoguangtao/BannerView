//
//  GPCollectionView.m
//  Test
//
//  Created by ggt on 2017/2/28.
//  Copyright © 2017年 GGT. All rights reserved.
//

#import "GPCollectionView.h"

#define DRAG_DISPLACEMENT_THRESHOLD 20

@interface GPCollectionView () <UICollectionViewDelegate>

@end

@implementation GPCollectionView {
    
    BOOL _delegateRespondsToWillBeginDragging;
    BOOL _delegateRespondsToWillEndDragging;
    BOOL _delegateRespondsToDidEndDragging;
    BOOL _delegateRespondsToDidEndDecelerating;
    BOOL _delegateRespondsToDidEndScrollingAnimation;
    BOOL _delegateRespondsToDidEndZooming;
    
    BOOL _snapping;
    
    CGPoint _dragVelocity;
    CGPoint _dragDisplacement;
}

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self performInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.pagingEnabled = YES;
        [self performInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self performInit];
    }
    
    return self;
}

- (void)performInit {
    [super setDelegate:self];
    
    
    if ([super isPagingEnabled]) {
        [super setPagingEnabled:NO];
        
        _pagingEnabled = YES;
    }
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

#pragma mark - Overriding the delegate

@synthesize delegate = _actualDelegate;

- (void)setDelegate:(id <UICollectionViewDelegate> )delegate {
    
    if (delegate == _actualDelegate)
        return;
    
    _actualDelegate = delegate;
    
    
    // Do our own caching
    _delegateRespondsToWillBeginDragging = [_actualDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)];
    _delegateRespondsToWillEndDragging = [_actualDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)];
    _delegateRespondsToDidEndDragging = [_actualDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    _delegateRespondsToDidEndDecelerating = [_actualDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    _delegateRespondsToDidEndScrollingAnimation = [_actualDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)];
    _delegateRespondsToDidEndZooming = [_actualDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)];
}

#pragma mark - Configuration

@synthesize pagingEnabled = _pagingEnabled;

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    if (pagingEnabled == _pagingEnabled)
        return;
    
    
    _pagingEnabled = pagingEnabled;
    
    
    if (_pagingEnabled)
        [self snapToPage];
}

- (void)setPageWidth:(CGFloat)pageWidth {
    if (pageWidth == _pageWidth)
        return;
    
    
    _pageWidth = pageWidth;
    
    
    if (_pagingEnabled)
        [self snapToPage];
}

- (void)setPageHeight:(CGFloat)pageHeight {
    if (pageHeight == _pageHeight)
        return;
    
    
    _pageHeight = pageHeight;
    
    
    if (_pagingEnabled)
        [self snapToPage];
}

#pragma mark - Paging support

- (void)snapToPage {
    CGPoint pageOffset;
    pageOffset.x = [self pageOffsetForComponent:YES];
    pageOffset.y = [self pageOffsetForComponent:NO];
    
    
    CGPoint currentOffset = self.contentOffset;
    
    if (!CGPointEqualToPoint(pageOffset, currentOffset)) {
        _snapping = YES;
        
        [self setContentOffset:pageOffset animated:YES];
    }
    
    
    _dragVelocity = CGPointZero;
    _dragDisplacement = CGPointZero;
}

- (CGFloat)pageOffsetForComponent:(BOOL)isX {
    if (((isX ? CGRectGetWidth(self.bounds) : CGRectGetHeight(self.bounds)) == 0) || ((isX ? self.contentSize.width : self.contentSize.height) == 0))
        return 0;
    
    
    CGFloat pageLength = isX ? _pageWidth : _pageHeight;
    
    if (pageLength < FLT_EPSILON)
        pageLength = isX ? CGRectGetWidth(self.bounds) : CGRectGetHeight(self.bounds);
    
    pageLength *= self.zoomScale;
    
    
    CGFloat totalLength = isX ? self.contentSize.width : self.contentSize.height;
    
    CGFloat visibleLength = (isX ? CGRectGetWidth(self.bounds) : CGRectGetHeight(self.bounds)) * self.zoomScale;
    
    CGFloat currentOffset = isX ? self.contentOffset.x : self.contentOffset.y;
    
    CGFloat dragVelocity = isX ? _dragVelocity.x : _dragVelocity.y;
    
    CGFloat dragDisplacement = isX ? _dragDisplacement.x : _dragDisplacement.y;
    
    
    CGFloat newOffset;
    
    
    CGFloat index = currentOffset / pageLength;
    
    CGFloat lowerIndex = floorf(index);
    CGFloat upperIndex = ceilf(index);
    
    if (ABS(dragDisplacement) < DRAG_DISPLACEMENT_THRESHOLD || dragDisplacement * dragVelocity < 0) {
        if (index - lowerIndex > upperIndex - index) {
            index = upperIndex;
        } else {
            index = lowerIndex;
        }
    } else {
        if (dragVelocity > 0) {
            index = upperIndex;
        } else {
            index = lowerIndex;
        }
    }
    
    
    newOffset = pageLength * index;
    
    if (newOffset > totalLength - visibleLength)
        newOffset = totalLength - visibleLength;
    
    if (newOffset < 0)
        newOffset = 0;
    
    
    return newOffset;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __func__);
}


#pragma mark - ScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragDisplacement = scrollView.contentOffset;
    
    if (_delegateRespondsToWillBeginDragging)
        [_actualDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_pagingEnabled) {
        *targetContentOffset = scrollView.contentOffset;
        
        
        _dragVelocity = velocity;
        
        _dragDisplacement = CGPointMake(scrollView.contentOffset.x - _dragDisplacement.x, scrollView.contentOffset.y - _dragDisplacement.y);
    } else {
        if (_delegateRespondsToWillEndDragging)
            [_actualDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate && _pagingEnabled)
        [self snapToPage];
    
    
    if (_delegateRespondsToDidEndDragging)
        [_actualDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_pagingEnabled)
        [self snapToPage];
    
    
    if (_delegateRespondsToDidEndDecelerating)
        [_actualDelegate scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!_snapping && _pagingEnabled) {
        [self snapToPage];
    } else {
        _snapping = NO;
    }
    
    
    if (_delegateRespondsToDidEndScrollingAnimation)
        [_actualDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (_pagingEnabled)
        [self snapToPage];
    
    if (_delegateRespondsToDidEndZooming)
        [_actualDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
}


@end
