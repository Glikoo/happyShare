//
//  addressBookCell.m
//  HappyShare
//
//  Created by scsys on 15/4/26.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "addressBookCell.h"

@implementation addressBookCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            self.headImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 40, 40)];
            [self.contentView addSubview:self.headImage];
            self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.headImage.bounds.size.width+30, 5, 200, 40)];
            [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
