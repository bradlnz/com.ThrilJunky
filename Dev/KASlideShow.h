//
//  KASlideShow.h
//  ThrilJunky
//
//  Created by Brad Lietz on 11/5/17.
//  Copyright © 2017 ThrilJunky LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KASlideShowTransitionType) {
    KASlideShowTransitionFade,
    KASlideShowTransitionSlide
};

typedef NS_ENUM(NSInteger, KASlideShowGestureType) {
    KASlideShowGestureTap,
    KASlideShowGestureSwipe,
    KASlideShowGestureAll
};

typedef NS_ENUM(NSUInteger, KASlideShowPosition) {
    KASlideShowPositionTop,
    KASlideShowPositionBottom
};

typedef NS_ENUM(NSUInteger, KASlideShowState) {
    KASlideShowStateStopped,
    KASlideShowStateStarted
};

@class KASlideShow;
@protocol KASlideShowDelegate <NSObject>
@optional
- (void) kaSlideShowDidShowNext:(KASlideShow *) slideShow;
- (void) kaSlideShowDidShowPrevious:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowNext:(KASlideShow *) slideShow;
- (void) kaSlideShowWillShowPrevious:(KASlideShow *) slideShow;
@end

@protocol KASlideShowDataSource <NSObject>
- (UIImage *)slideShow:(KASlideShow *)slideShow imageForPosition:(KASlideShowPosition)position;
@end

@interface KASlideShow : UIView

@property (nonatomic, unsafe_unretained) IBOutlet id <KASlideShowDelegate> delegate;
@property (nonatomic, unsafe_unretained) id<KASlideShowDataSource> dataSource;

@property  float delay;
@property  float transitionDuration;
@property  (readonly, nonatomic) NSUInteger currentIndex;
@property  (atomic) KASlideShowTransitionType transitionType;
@property  (atomic) UIViewContentMode imagesContentMode;
@property  (strong,nonatomic) NSMutableArray * images;
@property  (readonly, nonatomic) KASlideShowState state;

- (void) addImagesFromResources:(NSArray *) names;
- (void) emptyAndAddImagesFromResources:(NSArray *)names;
- (void) emptyAndAddImages:(NSArray *)images;
- (void) setImagesDataSource:(NSMutableArray *)array;
- (void) addGesture:(KASlideShowGestureType)gestureType;
- (void) removeGestures;
- (void) addImage:(UIImage *) image;

- (void) start;
- (void) stop;
- (void) previous;
- (void) next;

@end
