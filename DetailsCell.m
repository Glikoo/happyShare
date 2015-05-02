//
//  DetailsCell.m
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "DetailsCell.h"

@implementation DetailsCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (indexPath.row==2) {
            self.headName=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, self.frame.size.height-10)];
            [self.contentView addSubview:self.headName];
            
            self.SocialImage=[[UIImageView alloc]initWithFrame:CGRectMake(self.headName.frame.size.width+20, 10, self.frame.size.height-20, self.frame.size.height-20)];
            [self.contentView addSubview:self.SocialImage];
            
            self.contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.SocialImage.frame.origin.x+self.SocialImage.bounds.size.width+20, 5, self.frame.size.width-self.SocialImage.frame.origin.x-self.SocialImage.frame.size.width-30, self.frame.size.height-10)];
            self.contentLabel.font=[UIFont systemFontOfSize:15];
            [self.contentView addSubview:self.contentLabel];
        }
        else{
            self.headName=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, self.frame.size.height-10)];
            [self.contentView addSubview:self.headName];
            self.contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.headName.bounds.size.width+20, 5, self.frame.size.width-self.headName.frame.size.width-40, self.frame.size.height-10)];
            self.contentLabel.font=[UIFont systemFontOfSize:15];
            [self.contentView addSubview:self.contentLabel];
        }
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
