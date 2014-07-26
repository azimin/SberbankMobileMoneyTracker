//
//  LabelOnCircle.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "LabelOnCircle.h"

@interface LabelOnCircle ()

@property (nonatomic) Circle *circle;

@end

@implementation LabelOnCircle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCategoryName: (NSString*)categoryName
                         valueString: (NSString*)value
                            onCircle: (Circle*)circle
{
    self = [super initWithFrame:circle.bounds];
    
    if (self) {
        self.categoryName = categoryName;
        self.value = value;
        self.circle = circle;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.numberOfLines = 0;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    
    CGFloat fontSize = self.circle.radius / 2.5;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",
                                                                                        self.categoryName, self.value]
                                                                            attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
    [str addAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]}
                 range: NSMakeRange(0, self.categoryName.length)];
    
    [self setAttributedText:str];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
