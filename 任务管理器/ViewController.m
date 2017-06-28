//
//  ViewController.m
//  任务管理器
//
//  Created by andy on 16/10/18.
//  Copyright © 2016年 andy. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"


@interface ViewController ()<iCarouselDataSource,iCarouselDelegate>


@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize taskSize;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat taskWidth = [UIScreen mainScreen].bounds.size.width * 5.0f / 7.0f;
    self.taskSize = CGSizeMake(taskWidth, taskWidth * 16.0f / 9.0f);
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.carousel = [[iCarousel alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    [self.carousel setType:iCarouselTypeCustom];
    [self.carousel setBounceDistance:0.1];
    
    
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 7;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UIView *taskView = view;
    if (!taskView) {
        taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.taskSize.width, self.taskSize.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:taskView.bounds];
        [taskView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.backgroundColor = [UIColor whiteColor];
        UIImage *taskImage = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)index]];
        [imageView setImage:taskImage];
        [taskView.layer setShadowPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0].CGPath];
        [taskView.layer setShadowRadius:3.0f];
        [taskView.layer setShadowColor:[UIColor blackColor].CGColor];
        [taskView.layer setShadowOffset:CGSizeZero];
        
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        [layer setFrame:imageView.bounds];
        [layer setPath:[UIBezierPath bezierPathWithRoundedRect:imageView.frame cornerRadius:5.0].CGPath];
        [imageView.layer setMask:layer];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:taskView.frame];
        //        [label setText:[@(index) stringValue]];
        label.font = [UIFont systemFontOfSize:50];
        label.textAlignment = NSTextAlignmentCenter;
        [taskView addSubview:label];
        
        
    }
    return taskView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"index = %ld",index);
}

//  计算缩放
- (CGFloat)calcScaleWithOffset:(CGFloat)offset{
    return offset * 0.02f + 1.0f;
}

//  计算位移
- (CGFloat)calcTranslationWithOffset:(CGFloat)offset{
    CGFloat z = 5.0f / 4.0f;
    CGFloat a = 5.0f / 8.0f;
    
    if (offset >= z / a) {
        return 2.0f;
    }
    return 1/(z - a * offset) - 1 / z;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calcTranslationWithOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.taskSize.width, 0, offset), scale, scale, 1.0f);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
