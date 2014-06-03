//  Created by Richard Martin on 31/05/2014.
//  Copyright (c) 2014 Richard Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPCPageControl : UIView {
    
}

@property (nonatomic) NSInteger dotRadius;

@property (nonatomic) NSInteger dotGap;

@property (nonatomic) UIColor *dotColor;

@property (nonatomic) UIColor *selectedDotColor;

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic) NSInteger numberOfPages;

- (void)removePage:(NSInteger)index;

@end
