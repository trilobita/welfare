//
//  QXCViewController.m
//  welfare
//
//  Created by PC-wzj on 2018/11/26.
//  Copyright © 2018 PC-wzj. All rights reserved.
//

#import "QXCViewController.h"
#import <Masonry.h>
#define BALL_NUMBER 7
#define BALL_SIZE 30
#define VIEW_SIZE [UIScreen mainScreen].bounds.size

#define ANGLE_TO_RADIAN(angle) ((angle)/180.0 * M_PI)
#define BALL_COLOR [UIColor colorWithRed:250/255.0 green:90/255.0 blue:64/255.0 alpha:1]

@interface QXCViewController () <CAAnimationDelegate>

@property (nonatomic, copy) NSMutableArray *balls;
@property (nonatomic, copy) NSMutableArray *ballNums;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIView *ballBox;
@property (nonatomic, strong) UILabel *chongLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger showNum;
@property (nonatomic, strong) UILabel *tempLabel;
@end

@implementation QXCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initLayout];
}

- (NSMutableArray *)balls {
    if (!_balls) {
        _balls = [NSMutableArray array];
    }
    return _balls;
}

- (NSMutableArray *)ballNums {
    if(!_ballNums) {
        _ballNums = [NSMutableArray array];
    }
    return _ballNums;
}

- (void) initLayout {
    [self initStartBtn];
    [self.view addSubview:self.startBtn];
    
    [self initTempLabel];
    [self.view addSubview:self.tempLabel];
    
    [self initBallBox];
    [self.view addSubview:self.ballBox];
    
    [self initChongLabel];
    [self.ballBox addSubview:self.chongLabel];
    
    [self startBtnLayout];
    [self ballBoxLayout];
    [self chongLabelLayout];
    [self tempLabelLayout];
    
}

//测试组件
- (void) initTempLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = BALL_COLOR;
    label.layer.cornerRadius = BALL_SIZE*0.5;
    label.clipsToBounds = YES;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.tempLabel = label;
}
- (void) tempLabelLayout {
    __weak typeof(self) weakSelf = self;
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(weakSelf.ballBox);
        make.width.height.mas_equalTo(BALL_SIZE);
        make.center.mas_equalTo(weakSelf.ballBox);
    }];
}

//开始按钮
- (void) initStartBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:196/255.0 blue:189/255.0 alpha:1]];
    btn.layer.cornerRadius = 10;
    btn.clipsToBounds = YES;
    [btn addTarget:self action:@selector(touchStartBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.startBtn = btn;
}

- (void) startBtnLayout {
    __weak typeof(self) weakSelf = self;
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-60);
    }];
}

//球盒
- (void) initBallBox {
    UIView *box = [[UIView alloc] init];
    box.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    box.layer.cornerRadius = 15;
    box.clipsToBounds = YES;
    self.ballBox = box;
}

- (void) ballBoxLayout {
    __weak typeof(self) weakSelf = self;
    [self.ballBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(VIEW_SIZE.width*0.2, VIEW_SIZE.width*0.2));
        make.top.mas_equalTo(VIEW_SIZE.height*0.25);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
}

//求和标签
- (void) initChongLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"虫";
    label.textColor = [UIColor colorWithRed:30/255.0 green:196/255.0 blue:189/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    self.chongLabel = label;
}

- (void) chongLabelLayout {
    __weak typeof(self) weakSelf = self;
    [self.chongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.ballBox);
        make.center.mas_equalTo(weakSelf.ballBox);
    }];
}

//构建球组
- (void) initBalls {
    for (NSNumber *num in self.ballNums) {
        UILabel *ball = [self createBallWithNum:num];
        [self.view addSubview:ball];
        [self.balls addObject:ball];
    }
}

//生成单个球
- (UILabel *) createBallWithNum:(NSNumber *)num {
    UILabel *ball = [[UILabel alloc] init];
    ball.layer.cornerRadius = BALL_SIZE*0.5;
    ball.clipsToBounds = YES;
    ball.backgroundColor = BALL_COLOR;
    ball.hidden = YES;
    ball.textColor = [UIColor whiteColor];
    ball.text = [NSString stringWithFormat:@"%@", num];
    ball.textAlignment = NSTextAlignmentCenter;
    return ball;
}

//展示结果
- (void) showLotteryDraw {
    CGFloat width = VIEW_SIZE.width;
    __weak typeof(self) weakSelf = self;
    
    for (UILabel *ball in self.balls) {
        NSInteger index = [self.balls indexOfObject:ball];
        NSInteger column = index%4;
        NSInteger row = index/4 + 1;
        CGFloat offsetx = (width*0.25)*column + (((width*0.25) - BALL_SIZE) * 0.5);
        CGFloat offsety = width*0.2*row;
        
        [ball mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(BALL_SIZE, BALL_SIZE));
            make.left.mas_equalTo(offsetx);
            make.top.mas_equalTo(weakSelf.ballBox.mas_bottom).offset(offsety);
        }];
    }
}

//抖动
- (void) shakeAnimation {
    //实例化
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.delegate = self;
    //拿到动画 key
//    animation.keyPath =@"transform.rotation";
    // 动画时间
    animation.duration =0.05;
    
    // 重复的次数
    animation.repeatCount = 20;
    //无限次重复
    //    anim.repeatCount =MAXFLOAT;
    
    //设置抖动数值
    animation.values =@[@(ANGLE_TO_RADIAN(1)), @(ANGLE_TO_RADIAN(-15)), @(ANGLE_TO_RADIAN(15)), @(ANGLE_TO_RADIAN(-15)), @(ANGLE_TO_RADIAN(1))];
    
    // 保持最后的状态
    animation.removedOnCompletion = NO;
    //动画的填充模式
    animation.fillMode =kCAFillModeForwards;
    //layer层实现动画
    [self.ballBox.layer addAnimation:animation forKey:@"shake"];
}

- (void) moveUpAnimation {
    // 位置移动
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    // 持续时间
    animation.duration = 0.25;
    // 是否回复初始位置
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // 起始位置
    animation.fromValue = [NSValue valueWithCGPoint:self.tempLabel.layer.position];
    // 终止位置
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.tempLabel.layer.position.x, self.tempLabel.layer.position.y-60)];
    
    // 添加动画
    [self.tempLabel.layer addAnimation:animation forKey:@"moveUp"];
}

- (void) moveDownAnimation {
    UILabel *ball = (UILabel *)[self.balls objectAtIndex:self.showNum];
    
    CGPoint fromCenter = CGPointMake(self.tempLabel.layer.position.x, self.tempLabel.layer.position.y-60);
    CGPoint endCenter = ball.center;
    
    CGFloat controlPointEY = 100;
    CGFloat controlPointEX = (endCenter.x - fromCenter.x) * 0.25f;
    
    CGFloat controlPointCX = fromCenter.x + (endCenter.x-fromCenter.x)*0.5;
    CGFloat controlPointCY = fromCenter.y;
    
    CGPoint controlPoint1 = CGPointMake(controlPointCX - controlPointEX, controlPointCY - controlPointEY);
    CGPoint controlPoint2 = CGPointMake(controlPointCX + controlPointEX, controlPointCY - controlPointEY);

    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:fromCenter];
    [path addCurveToPoint:endCenter controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.path = path.CGPath;
//    animation.beginTime = CACurrentMediaTime() + 1.25;
    animation.duration = 1.25;
    // 是否回复初始位置
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.tempLabel.layer addAnimation:animation forKey:@"moveDown"];
}

- (void) showAnimation {
    [self shakeAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%@  %d", anim, flag);
    if([self.ballBox.layer animationForKey:@"shake"] == anim) {
//        NSLog(@"抖动结束");
        [self moveUpAnimation];
        [self.ballBox.layer removeAnimationForKey:@"shake"];
    } else if([self.tempLabel.layer animationForKey:@"moveUp"] == anim) {
//        NSLog(@"上移结束");
        [self moveDownAnimation];
        [self.tempLabel.layer removeAnimationForKey:@"moveUp"];
    } else if([self.tempLabel.layer animationForKey:@"moveDown"] == anim) {
//        NSLog(@"下移结束");
        UILabel *ball = (UILabel *)[self.balls objectAtIndex:self.showNum];
        ball.hidden = NO;
        if (self.showNum < [self.balls count]-1) {
            [self shakeAnimation];
            self.showNum ++;
        }
        [self.tempLabel.layer removeAnimationForKey:@"moveDown"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    if([self.ballBox.layer animationForKey:@"shake"] == anim) {
//        NSLog(@"抖动开始");
    }  else if([self.tempLabel.layer animationForKey:@"moveUp"] == anim) {
//        NSLog(@"上移开始");
        self.tempLabel.text = [NSString stringWithFormat:@"%@", [self.ballNums objectAtIndex:self.showNum]];
    } else if([self.tempLabel.layer animationForKey:@"moveDown"] == anim) {
//        NSLog(@"下移开始");
    }
}

//生成结果
- (void) lotteryDraw {
//    移除上一组球组视图
    for (id ball in self.balls) {
        [ball removeFromSuperview];
    }
    
//    删除球组及球号记录
    [self.ballNums removeAllObjects];
    [self.balls removeAllObjects];
    
//    生成球号
    for (int i = 0; i < 7; i ++) {
        NSUInteger ballNum = arc4random_uniform(10);
        [self.ballNums addObject:[NSNumber numberWithInteger:ballNum]];
    }
    
//    构建球组
    [self initBalls];
//    展示球组
    [self showLotteryDraw];
}

- (void) touchStartBtn:(id) sender {
    NSLog(@"点击开始按钮");
    [self.ballBox.layer removeAllAnimations];
    [self.tempLabel.layer removeAllAnimations];
    
    [self lotteryDraw];
    self.showNum = 0;
    [self showAnimation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
