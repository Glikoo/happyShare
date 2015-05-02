//
//  DetailsCell.h
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsCell : UITableViewCell

@property (nonatomic,retain)UILabel *headName;
@property (nonatomic,retain)UILabel *contentLabel;
@property (nonatomic,retain)UIImageView *SocialImage;
@property (nonatomic,assign)int cellHeight;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath;
@end
