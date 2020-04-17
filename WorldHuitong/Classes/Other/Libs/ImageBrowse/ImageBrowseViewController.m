//
//  ImageBrowseViewController.m
//  ImageBrowse
//
//  Created by CheMiMacPro on 15/7/8.
//  Copyright (c) 2015年 CheMiMacPro. All rights reserved.
//

#define SCREEN_HEIGTH [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "ImageBrowseViewController.h"
#import "ImageBrowseCollectionViewCell.h"
#import "ImageBrowseModel.h"

@interface ImageBrowseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray *imageDataSource;
@property (nonatomic,strong)NSMutableArray *imagesArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)UIView *navContentView;
@property (nonatomic,strong)NSString *titles;
@end

@implementation ImageBrowseViewController

- (instancetype)initWithBrowseImages:(NSArray *)images withIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        
        [self setDataSourceWithImages:images withIndex:index withTitle:nil];
        
    }
    
    return self;
}

- (instancetype)initWithBrowseImages:(NSArray *)images withIndex:(NSInteger)index withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        [self setDataSourceWithImages:images withIndex:index withTitle:title];
        
    }
    
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = YES;
    }
    [self.view addSubview:self.navContentView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.contentOffset = CGPointMake(SCREEN_WIDTH * self.index, 0);


}

#pragma mark -- priviteMethods

- (void)setDataSourceWithImages:(NSArray *)array withIndex:(NSInteger)index withTitle:(NSString *)title
{
    self.index = index;
    self.title = title;
    for (int i = 0; i < array.count; i++) {
        ImageBrowseModel *model = [[ImageBrowseModel alloc] init];
        if ([array[i] isKindOfClass:[UIImage class]]) {
            model.image = array[i];
        }
        if ([array[i] isKindOfClass:[NSString class]]) {
            model.imageUrl = array[i];
        }
        
        [self.imageDataSource addObject:model];
    }

    
}

- (UIView *)navContentView
{
    if (nil == _navContentView) {
        _navContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        _navContentView.backgroundColor = HT_COLOR;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 20, 50, 44);

        [button setImage:[UIImage imageNamed:@"btn_back_n.png"] forState:UIControlStateNormal];

        [button setTintColor:[UIColor whiteColor]];
        [button setImage:[UIImage imageNamed:@"ht_back"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backHandle:) forControlEvents:UIControlEventTouchUpInside];
        [_navContentView addSubview:button];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"项目材料";
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(_navContentView.bounds.size.width/2, 42);
        [_navContentView addSubview:titleLabel];
    }
    return _navContentView;
}

- (NSMutableArray *)imageDataSource
{
    if (nil == _imageDataSource) {
        _imageDataSource = [NSMutableArray array];
    }
    return _imageDataSource;
}

- (UIView *)contentView
{
    if (nil == _contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

- (UICollectionView *)collectionView
{
    if (nil == _collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGTH);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[ImageBrowseCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    return _collectionView;
}

- (void)backHandle:(UIButton *)button
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBarHidden = NO;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell updateCellWithModel:self.imageDataSource[indexPath.row]];
    return cell;
}



@end
