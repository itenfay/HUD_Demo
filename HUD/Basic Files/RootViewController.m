//
//  RootViewController.m
//
//  Created by dyf on 14/10/22.
//  Copyright © 2014 dyf. All rights reserved.
//

#import "RootViewController.h"
#import "MBProgressHUD.h"
#import "DYFDesignSpinner.h"
#import "DYFIndefiniteAnimatedView.h"
#import "DYFMaterialDesignSpinner.h"

@interface RootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"HUD", @"");
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    [self loadData];
    [self.view addSubview:self.tableView];
    
    [self setupRightNaviItem];
}

- (void)setupRightNaviItem {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:[NSString stringWithFormat:@"Hide"] forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [button setTitleColor:UIColor.grayColor forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    spaceItem.width = 20.f;
    
    self.navigationItem.rightBarButtonItems = @[item, spaceItem];
}

- (void)loadData {
    [self.dataArray addObject:@"MBProgressHUD"];
    [self.dataArray addObject:@"DYFIndefiniteAnimatedView"];
    [self.dataArray addObject:@"DYFDesignSpinner"];
    [self.dataArray addObject:@"DYFMaterialDesignSpinner"];
    [self.dataArray addObject:@"MBProgressHUD-OnlyText"];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor  = UIColor.clearColor;
        _tableView.delegate         = self;
        _tableView.dataSource       = self;
        _tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;
        _tableView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                       UIViewAutoresizingFlexibleWidth      |
                                       UIViewAutoresizingFlexibleTopMargin  |
                                       UIViewAutoresizingFlexibleHeight);
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"NameCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.f];
    cell.textLabel.text = text;
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.3 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectRow:indexPath.row];
}

- (void)selectRow:(NSInteger)row {
    switch (row) {
        case 0: {
            [self configureHUDAddedTo:nil onlyText:nil];
        }
            break;
            
        case 1: {
            DYFIndefiniteAnimatedView *spinner = [[DYFIndefiniteAnimatedView alloc] init];
            spinner.frame     = CGRectMake(0, 0, 40, 40);
            spinner.radius    = CGRectGetWidth(spinner.bounds)/2;
            spinner.lineWidth = 2.f;
            spinner.lineColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
            spinner.maskImage = [UIImage imageNamed:@"angle-mask"];
            [self configureHUDAddedTo:spinner onlyText:nil];
        }
            break;
            
        case 2: {
            DYFDesignSpinner *spinner = [DYFDesignSpinner spinnerWithSize:DYFDesignSpinnerSizeLarge color:[UIColor whiteColor]];
            spinner.isAnimating = YES;
            spinner.hasGlow     = YES;
            [self configureHUDAddedTo:spinner onlyText:nil];
        }
            break;
            
        case 3: {
            DYFMaterialDesignSpinner *spinner = [[DYFMaterialDesignSpinner alloc] init];
            spinner.frame     = CGRectMake(0, 0, 40, 40);
            spinner.lineColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
            spinner.lineWidth = 2.f;
            [spinner startAnimating];
            [self configureHUDAddedTo:spinner onlyText:nil];
        }
            break;
            
        case 4: {
            [self configureHUDAddedTo:nil onlyText:@"支付已完成"];
        }
            break;
            
        default:
            break;
    }
}

- (void)configureHUDAddedTo:(UIView *)view onlyText:(NSString *)onlyText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (view) {
        hud.mode       = MBProgressHUDModeCustomView;
        hud.customView = view;
    } else if (onlyText.length > 0) {
        hud.mode       = MBProgressHUDModeText;
        hud.yOffset    = 0.f;
    }
    
    hud.removeFromSuperViewOnHide = YES;
    
    if (onlyText.length > 0) {
        
        //hud.opacity     = 0.6f;
        hud.labelFont     = [UIFont boldSystemFontOfSize:14.f];
        hud.labelText     = onlyText;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.labelColor    = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
        hud.labelColor    = [UIColor whiteColor];
        
    } else {
        
        hud.opacity       = 0.75f;
        hud.labelFont     = [UIFont boldSystemFontOfSize:14.f];
        //hud.color       = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        hud.labelText     = @"支付请求中...";
        hud.labelColor    = [UIColor whiteColor];
        //hud.labelColor  = [UIColor blackColor];
        //hud.labelColor  = [UIColor colorWithRed:0.9 green:0.4 blue:0.2 alpha:1];
        hud.animationType = MBProgressHUDAnimationZoom;
    }
}

- (void)hide {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
