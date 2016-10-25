//
//  TYJCarouselVC.m
//  投易家
//
//  Created by q on 16/8/15.
//  Copyright © 2016年 TYJ. All rights reserved.
//

#import "TYJCarouselVC.h"
#import "TYJCarouseCollectionViewCell.h"

@interface TYJCarouselVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) CGSize size;

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation TYJCarouselVC

static NSString *const identifier = @"carouselCell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self addTimer];
    //  一开始滚动到中间，实现左右滚动
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2000 * _count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeTimer];
}
#pragma mark--------------------------------------------------------
#pragma mark 构建对象的api实现
+ (instancetype)carouselWithFrame:(CGRect)frame images:(NSArray *)images toController:(UIViewController *)controller {
    return [TYJCarouselVC carouselWithFrame:frame images:(NSArray *)images toController:controller superView:controller.view];
}

+ (instancetype)carouselWithFrame:(CGRect)frame images:(NSArray *)images toController:(UIViewController *)controller superView:(UIView *)superView {
    TYJCarouselVC *carouselVC = [[TYJCarouselVC alloc] initWithFrame:(CGRect)frame images:(NSArray *)images];
    
    [controller addChildViewController:carouselVC];
    [superView addSubview:carouselVC.view];
    return carouselVC;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images {
    if (self != [super init]) return nil;
    _size = frame.size;
    _images = images;
    _count = images.count;
    self.view.frame = frame;

    //  3.添加collectionView和pageController
    [self.view addSubview:self.collectionView];
    return self;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    _count = images.count;
}

#pragma mark--------------------------------------------------------
#pragma mark 懒加载
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = _size;
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //  1.创建collectionView
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        //  2.注册cell以及collectionView属性的设置
        [_collectionView registerNib:[UINib nibWithNibName:@"TYJCarouseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl sizeToFit];
        CGSize pageControlZ = _pageControl.frame.size;
        _pageControl.frame = CGRectMake(_size.width - pageControlZ.width -40, _size.height - pageControlZ.height -30, pageControlZ.width, 30);
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = _count;
        _pageControl.hidesForSinglePage = YES;
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}
#pragma mark--------------------------------------------------------
#pragma mark collectionView - dateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _count * 4000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYJCarouseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.image = self.images[indexPath.item % _count];
    return cell;
}
#pragma mark--------------------------------------------------------
#pragma mark 点击选中cell处理事件 - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(clickCarouselWithIndex:)]) {
        [self.delegate clickCarouselWithIndex:indexPath.item % _count];
    }
}

#pragma mark--------------------------------------------------------
#pragma mark 轮播图的其他处理
- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addTimer {
    if (_count == 1) return;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextPage {
    CGPoint offset = self.collectionView.contentOffset;
    NSInteger currentPage = offset.x / _size.width;
    CGFloat nextX = (currentPage +1) * _size.width;
    [self.collectionView setContentOffset:CGPointMake(nextX, offset.y) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / _size.width + 0.5;
    self.pageControl.currentPage = currentPage % self.count;
}

#pragma mark--------------------------------------------------------
#pragma mark - 拖拽轮番图时处理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
#pragma mark--------------------------------------------------------
@end
