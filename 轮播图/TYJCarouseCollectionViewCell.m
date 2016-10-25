//
//  TYJCarouseCollectionViewCell.m
//  WtmbuyPlatform
//
//  Created by q on 16/9/26.
//  Copyright © 2016年 Wtmbuy Network Technology Co., Ltd. All rights reserved.
//

#import "TYJCarouseCollectionViewCell.h"
#import "WtmImport.h"
@interface TYJCarouseCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation TYJCarouseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setImage:(NSString *)image {
    [WtmUtil wtmImageView:self.imageView  AndSD_setImageWithUrlString:image];
}
@end
