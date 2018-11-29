//
//  ViewController.m
//  welfare
//
//  Created by PC-wzj on 2018/11/19.
//  Copyright © 2018 PC-wzj. All rights reserved.
//

#import "ViewController.h"
#import "QXCViewController.h"

#define VIEW_SIZE [UIScreen mainScreen].bounds.size

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *optionView;
@property (nonatomic, copy) NSMutableArray *optionArr;
@property (nonatomic, copy) NSMutableArray *optionViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initObject];
    [self initLayout];
}

- (void) initObject {
    NSArray *optionArr = @[@"qxc",
                           ];
    NSArray *optionViews = @[@"QXCViewController",
                            ];
    [self.optionArr addObjectsFromArray:optionArr];
    [self.optionViews addObjectsFromArray:optionViews];
}

- (NSMutableArray *)optionArr {
    if (!_optionArr) {
        _optionArr = [NSMutableArray array];
    }
    return _optionArr;
}

- (NSMutableArray *)optionViews {
    if (!_optionViews) {
        _optionViews = [NSMutableArray array];
    }
    return _optionViews;
}

- (void) initLayout {
    [self optionViewLayout];
    [self.view addSubview:self.optionView];
}

- (UITableView *)optionView {
    if (!_optionView) {
        _optionView = [[UITableView alloc] init];
        _optionView.delegate = self;
        _optionView.dataSource = self;
    }
    return _optionView;
}
- (void) optionViewLayout {
    self.optionView.frame = CGRectMake(0, 64, VIEW_SIZE.width, VIEW_SIZE.height);
}

#pragma mark - <!--------tableview delegate--------!>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OPTION_CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OPTION_CELL"];
    }
    cell.textLabel.text = [self.optionArr objectAtIndex:indexPath.row];
    return cell;
}
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Class vcclass = NSClassFromString([self.optionViews objectAtIndex:indexPath.row]);
//    UIViewController *vc = [[vcclass alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    QXCViewController *qxc = [[QXCViewController alloc] init];
    [self.navigationController pushViewController:qxc animated:YES];
}


@end
