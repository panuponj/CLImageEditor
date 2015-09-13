//
//  CollectionStickerViewCell.m
//  Pods
//
//  Created by Panupong Jitchopjai on 7/28/2558 BE.
//
//

#import "CollectionStickerViewCell.h"

@implementation CollectionStickerViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //initialization view
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"CollectionStickerViewCell" owner:self options:nil];
        
        if ([arrayOfView count] < 1) {
            return nil;
        }
        
        if (![[arrayOfView objectAtIndex:0]isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfView objectAtIndex:0];
        
        
    }
    
    return self;
}
@end
