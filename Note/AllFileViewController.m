//
//  AllFileViewController.m
//  Note
//
//  Created by syj on 16/4/28.
//  Copyright © 2016年 syj. All rights reserved.
//

#import "AllFileViewController.h"

@interface AllFileViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong) UITableView *fileTable;

@end

@implementation AllFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blueColor];
    CGRect rect = self.view.frame;
    rect.size.height -= 120;
    
    self.fileTable = [[UITableView alloc]initWithFrame:rect];
    self.fileTable.dataSource = self;
    self.fileTable.delegate = self;
    [self.view addSubview:self.fileTable];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.fileTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fileCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.select(indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
