//
//  ViewController.m
//  ClockAnimation
//
//  Created by bfme on 2017/3/21.
//  Copyright © 2017年 BFMe. All rights reserved.
//

#import "ViewController.h"

#define  kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define  kScreenHeight [UIScreen mainScreen].bounds.size.height

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

@interface ViewController ()
{
    UIView *hourHand;
    UIView *minuteHand;
    UIView *secondHand;
    
    NSMutableArray *digitViews;
    
    NSTimer *timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-198)/2, (kScreenHeight-198)/2, 198, 198)];
    [self.view addSubview:backView];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 198, 198)];
    imageView.image = [UIImage imageNamed:@"time"];
    [backView addSubview:imageView];
    
    hourHand = [[UIView alloc] initWithFrame:CGRectMake((198-5)/2, (198-50)/2, 5, 50)];
    hourHand.backgroundColor = [UIColor blackColor];
    [backView addSubview:hourHand];
    ViewRadius(hourHand, 2.5);
    hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    minuteHand = [[UIView alloc] initWithFrame:CGRectMake((198-3)/2, (198-70)/2, 3, 70)];
    minuteHand.backgroundColor = [UIColor darkGrayColor];
    [backView addSubview:minuteHand];
    ViewRadius(minuteHand, 1.5);
    minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    secondHand = [[UIView alloc] initWithFrame:CGRectMake((198-1)/2, (198-90)/2, 1, 90)];
    secondHand.backgroundColor = [UIColor redColor];
    [backView addSubview:secondHand];
    ViewRadius(secondHand, 0.5);
    secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    
    UIImage *image = [UIImage imageNamed:@"again"];

    digitViews = [NSMutableArray array];
    CGFloat wide = 50;
    CGFloat space = 10;
    CGFloat x = (kScreenWidth - 50*6 - 10*5 - 20)/2;
    for (int i = 0; i < 6; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x+(wide+space)*i, MaxY(backView)+20, wide, 80)];
        [self.view addSubview:view];
        
        view.layer.contents = (__bridge id)image.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
        view.layer.magnificationFilter = kCAFilterNearest;

        [digitViews addObject:view];
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(tick)
                                           userInfo:nil
                                            repeats:YES];
    [self tick];
}

- (void)tick
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    // rotate hands
    CGFloat hoursAngle = (CGFloat)(components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (CGFloat)(components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (CGFloat)(components.second / 60.0) * M_PI * 2.0;
    
    hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
    
    // set hours
    [self setDigit:components.hour / 10 forView:digitViews[0]];
    [self setDigit:components.hour % 10 forView:digitViews[1]];
    
    // set minutes
    [self setDigit:components.minute / 10 forView:digitViews[2]];
    [self setDigit:components.minute % 10 forView:digitViews[3]];
    
    // set seconds
    [self setDigit:components.second / 10 forView:digitViews[4]];
    [self setDigit:components.second % 10 forView:digitViews[5]];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view
{
    // adjust contentsRect to select correct digit
//    view.layer.contentsRect = CGRectMake(digit * 0.1, 0, 0.1, 1.0);
    
    NSInteger row = digit / 5;
    NSInteger line = digit % 5;
    view.layer.contentsRect = CGRectMake(line * 0.2, row * 0.53, 0.2, 0.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
