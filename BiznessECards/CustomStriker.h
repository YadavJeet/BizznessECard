//
//  CustomStriker.h
//  CustomStrikerEX
//
//  Created by IskPro on 26/01/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CHTStickerViewHandler) {
    CHTStickerViewHandlerClose,
    CHTStickerViewHandlerRotate,
    CHTStickerViewHandlerFlip
};

typedef NS_ENUM (NSInteger, CHTStickerViewPosition) {
    CHTStickerViewPositionTopLeft,
    CHTStickerViewPositionTopRight,
    CHTStickerViewPositionBottomLeft,
    CHTStickerViewPositionBottomRight
};

@class CustomStriker;

@protocol CHTStickerViewDelegate <NSObject>
@optional
- (void)stickerViewDidBeginMoving:(CustomStriker *)stickerView;
- (void)stickerViewDidChangeMoving:(CustomStriker *)stickerView;
- (void)stickerViewDidEndMoving:(CustomStriker *)stickerView;
- (void)stickerViewDidBeginRotating:(CustomStriker *)stickerView;
- (void)stickerViewDidChangeRotating:(CustomStriker *)stickerView;
- (void)stickerViewDidEndRotating:(CustomStriker *)stickerView;
- (void)stickerViewDidClose:(CustomStriker *)stickerView;
- (void)stickerViewDidTap:(CustomStriker *)stickerView;
-(void)stikerViewZoom:(CustomStriker *)stickerView;
-(void)showAlertStriker:(CustomStriker *)stickerView;

@end

@interface CustomStriker : UIView

@property (nonatomic, weak) id <CHTStickerViewDelegate> delegate;
/// Minimum value for the shorter side while resizing. Default value will be used if not set.
@property (nonatomic, assign) NSInteger minimumSize;

@property (nonatomic, assign) BOOL enableRotate;

@property(nonatomic ,assign) CGRect inititalSize;

@property(nonatomic ,assign) CGRect mainCanvasFrm;

@property(nonatomic,assign) NSInteger strikerCount;


@property (nonatomic, assign) BOOL enableZoomOut;


/// Enable the flip handler or not. Default value is YES.

/**
 *  Initialize a sticker view. This is the designated initializer.
 *
 *  @param contentView The contentView inside the sticker view.
 *                     You can access it via the `contentView` property.
 *
 *  @return The sticker view.
 */
- (id)initWithContentView:(UIView *)contentView;
- (id)initWithContentView:(UIView *)contentView isMove:(BOOL)checkMoveStauts;


- (void)setImage:(UIImage *)image forHandler:(CHTStickerViewHandler)handler;

@end
