//  Created by Richard Martin on 31/05/2014.
//  Copyright (c) 2014 Richard Martin. All rights reserved.
//

#import "BPCPageControl.h"

@implementation BPCPageControl {
    NSMutableArray *_entries;
    
    NSInteger _numberOfPages;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _entries = [NSMutableArray array];
        
        _dotGap = 6;
        _dotRadius = 2;
        _dotColor = [UIColor grayColor];
        _selectedDotColor = [UIColor blackColor];
        
        _currentPage = 5;
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    //remove any extra pages to bring the count down to new number of pages
    while (_entries.count > numberOfPages) {
        CALayer *circle = [_entries objectAtIndex:0];
        [_entries removeObjectAtIndex:0];
        [circle removeFromSuperlayer];
    }
    //add any dots to bring the control back up to the new number
    while (_entries.count < numberOfPages) {
        CALayer *circle = [CALayer layer];
        circle.backgroundColor = _dotColor.CGColor;
        circle.cornerRadius = _dotRadius;
        circle.frame = CGRectMake(0, 0, _dotRadius*2, _dotRadius*2);
        
        [_entries addObject:circle];
        
        [self.layer addSublayer:circle];
    }
    
    CGPoint startPoint = [self startPoint];
    [_entries enumerateObjectsUsingBlock:^(CAShapeLayer *shape, NSUInteger index, BOOL *stop) {
        shape.frame = CGRectMake(startPoint.x + (index*((_dotRadius*2)+_dotGap)), startPoint.y, _dotRadius*2, _dotRadius*2);
    }];
    
    CALayer *dot = [_entries objectAtIndex:_currentPage];
    dot.backgroundColor = _selectedDotColor.CGColor;
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
    
    CALayer *dot = [_entries objectAtIndex:currentPage];
    dot.backgroundColor = _selectedDotColor.CGColor;
}

- (CGPoint)startPoint {
    NSInteger x = (self.bounds.size.width - (_entries.count * ((_dotRadius*2)+_dotGap))) / 2;
    NSInteger y = (CGRectGetHeight(self.bounds) - _dotRadius) / 2;
    
    return CGPointMake(x, y);
}

- (void)addAnimationToLayer:(CALayer *)layer translateTo:(CGPoint)point {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    baseAnimation.fromValue = [layer valueForKey:@"position"];
    baseAnimation.toValue = [NSValue valueWithCGPoint:point];
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.cumulative = YES;
    baseAnimation.duration = 0.3;
    [baseAnimation setBeginTime:CACurrentMediaTime()+0.3];
    
    [layer addAnimation:baseAnimation forKey:@"position"];
}

- (void)removePage:(NSInteger)index {
    CALayer *dot = [_entries objectAtIndex:index];
    [_entries removeObject:dot];
    
    [CATransaction begin]; {
        
        [CATransaction setCompletionBlock:^{
            
            CGPoint startPoint = [self startPoint];
            [CATransaction begin];{
                [CATransaction setCompletionBlock:^{
                    //reset all positions after the animations are complete
                    [_entries enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger index, BOOL *stop) {
                        obj.position = CGPointMake(startPoint.x + (index*(_dotRadius*2+_dotGap))+_dotGap, obj.position.y);
                    }];
                    
                    if (_currentPage == index) {
                        if (_entries.count == index) {
                            [self setCurrentPage:_currentPage - 1];
                        } else {
                            [self setCurrentPage:_currentPage];
                        }
                    }
                }];
            
            
                [_entries enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger index, BOOL *stop) {
                    CGPoint point = CGPointMake(startPoint.x + (index*(_dotRadius*2+_dotGap))+_dotGap, obj.position.y);
                    [self addAnimationToLayer:obj translateTo:point];
                }];
            }[CATransaction commit];
        }];
        
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        drawAnimation.fillMode = kCAFillModeForwards;
        drawAnimation.removedOnCompletion = NO;
        drawAnimation.duration            = 0.3;
        drawAnimation.repeatCount         = 1.0;
        
        drawAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
        drawAnimation.toValue   = [NSNumber numberWithFloat:0.0f];
        
        drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [dot addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
        
    }[CATransaction commit];
}

@end
