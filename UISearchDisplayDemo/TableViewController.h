//
//  TableViewController.h
//  UISearchDisplayDemo
//
//  Created by DukeDouglas on 14-2-28.
//  Copyright (c) 2014年 DukeDouglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
//数据源字典
@property (nonatomic, retain) NSDictionary *crayonsColorDic;

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayCon;
@property (nonatomic, retain) NSArray *filterArray;//搜索结果数据源

@end
