//
//  PhotoTableViewCell.m
//  Meet
//
//  Created by Zhang on 6/2/16.
//  Copyright © 2016 Meet. All rights reserved.
//

#import "PhotoTableViewCell.h"
//#import "HYBLoopScrollView.h"
#import "SDCycleScrollView.h"
#import "Masonry.h"

@interface PhotoTableViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation PhotoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.whitView.hidden = YES;
        self.showdowView.hidden = YES;
        
    }
    return self;
}

- (void)configCell:(NSArray *)imageArray
{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 0, ScreenWidth - 20, (ScreenWidth - 20)*236/355) delegate:self placeholderImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e7e7e7"] size:CGSizeMake(ScreenWidth - 20, (ScreenWidth - 20)*236/355)]];
        _cycleScrollView.layer.cornerRadius = 5.0;
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        [self.contentView addSubview:_cycleScrollView];
        //         --- 轮播时间间隔，默认1.0秒，可自定义
        _cycleScrollView.autoScroll = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _cycleScrollView.imageURLStringsGroup = imageArray;
        });

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
