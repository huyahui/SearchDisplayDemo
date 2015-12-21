//
//  TableViewController.m
//  UISearchDisplayDemo
//
//  Created by DukeDouglas on 14-2-28.
//  Copyright (c) 2014年 DukeDouglas. All rights reserved.
//

#import "TableViewController.h"
#import "DataUtils.h"

@interface TableViewController ()

@end



@implementation TableViewController

- (void)dealloc
{
    [_crayonsColorDic release];
    [_searchBar release];
    [_searchDisplayCon release];
    [_filterArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取解析好的数据字典
    self.crayonsColorDic = [DataUtils parseData];
    NSLog(@"%@", self.crayonsColorDic);
    
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    self.tableView.tableHeaderView = self.searchBar;
    //再实例化UISearch DisplayControl
    self.searchDisplayCon = [[[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self] autorelease];
    self.searchDisplayCon.searchResultsDataSource = self;
    self.searchDisplayCon.searchResultsDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView) {
        return self.crayonsColorDic.count;
    }
    /*
     苹果提供的NSPredicate类，主要用于指定过滤器的条件，该对象可以准确的描述所需的条件，对每个对象用谓词进行筛选，判断该对象是否与筛选条件一致。
     用predicateWithFormate来创建一个用于筛选搜索信息的谓词
     self关键字，类似于方法调用中的self指针，表示当前被检索是否匹配的对象。contains[cd]是一个字符串运算符，contains表示包含的意思。而后面的[cd]则表示不区分大小写，也不区分发音符号。还有另外两种形式[c]不区分大小写，[d]不区分发音符号。
     
     而对于数组的实例方法filterArrayUsingPredicate:。可以根据我们创建的谓词，来循环检索数组中的每一个对象是否符合条件，一旦符合条件，则该对象就被标记为YES。循环检索完成后，该方法会把所有被标记为YES的对象存储在一个新数组中做为返回值返回。
     */
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", self.searchBar.text];
    NSArray *orderedArray = [[self.crayonsColorDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.filterArray = [orderedArray filteredArrayUsingPredicate:predicate];
    
    
    return self.filterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    //为了方便观看，将字典的键数组做一次按照首字母升序排序的操作
    NSArray *orderedArray = [[self.crayonsColorDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //判断当前是哪个tableView
    NSArray *array = (tableView == self.tableView) ? orderedArray : self.filterArray;
    
    
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    //还要给cell上的文本赋值颜色信息。
    NSString *hexString = [self.crayonsColorDic objectForKey:cell.textLabel.text];
    if ([hexString isEqualToString:@"FFFFFF"]) {
        cell.textLabel.textColor = [UIColor blackColor];
    } else {
        cell.textLabel.textColor = [self generateColorObjectWithHex:hexString];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *hexString = [self.crayonsColorDic objectForKey:cell.textLabel.text];
    UIColor *color = [self generateColorObjectWithHex:hexString];
    self.searchBar.barTintColor = color;
    self.navigationController.navigationBar.barTintColor = color;
}


- (UIColor *)generateColorObjectWithHex:(NSString *)hexString
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    //获取红色色值
    NSString *redString = [hexString substringWithRange:range];
    //实例化指定字符串的扫描器
    NSScanner *redScanner = [NSScanner scannerWithString:redString];
    //转换，并存储整型值
    [redScanner scanHexInt:&red];
    
    range.location = 2;
    //获取绿色色值
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    //获取蓝色色值
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0) green:(float)(green/255.0) blue:(float)(blue/255.0) alpha:1];
    return color;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
