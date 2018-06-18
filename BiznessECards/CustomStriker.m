//
//  CustomStriker.m
//  CustomStrikerEX
//
//  Created by IskPro on 26/01/17.
//  Copyright © 2017 IOS. All rights reserved.
//

#import "CustomStriker.h"
#define MINIMUM_SCALE 0.4
#define MAXIMUM_SCALE 8.0

CG_INLINE CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t) {
    return atan2(t.b, t.a);
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2) {
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    return sqrt((fx * fx + fy * fy));
}

@interface CustomStriker () <UIGestureRecognizerDelegate> {
    /**
     *  Default value
     */
    NSInteger defaultInset;
    NSInteger defaultMinimumSize;
    
    /**
     *  Variables for moving view
     */
    CGPoint beginningPoint;
    CGPoint beginningCenter;
    CGPoint edges;
    /**
     Variables for rotating and resizing view
     */
    CGRect initialBounds;
    CGFloat initialDistance;
    CGFloat deltaAngle;
    CGRect frame;
}

@property (nonatomic, strong, readwrite) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *moveGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *zoomInOut;


@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;




@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIImageView *rotateImageView;
@property (nonatomic, strong) UIImageView *flipImageView;

@property CGPoint translation;

@end
@implementation CustomStriker


- (void)setImage:(UIImage *)image forHandler:(CHTStickerViewHandler)handler {
    switch (handler) {
        case CHTStickerViewHandlerClose:
            self.closeImageView.image = image;
            break;
            
        case CHTStickerViewHandlerRotate:
            self.rotateImageView.image = image;
            break;
            
        case CHTStickerViewHandlerFlip:
            self.flipImageView.image = image;
            break;
    }
}



#pragma mark - Properties


- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    }
    return _tapGesture;
}

- (UITapGestureRecognizer *)doubleTapGesture {
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        
         _doubleTapGesture.numberOfTapsRequired = 2;
    }
    return _doubleTapGesture;
}



- (UIPanGestureRecognizer *)moveGesture {
    if (!_moveGesture) {
        _moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMoveGesture:)];
    }
    return _moveGesture;
}


#pragma mark - Properties

- (UIPinchGestureRecognizer *)zoomInOut {
    if (!_zoomInOut) {
        _zoomInOut = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlerzoomInOut:)];
    }
    return _zoomInOut;
}


#pragma mark - Gesture Handlers

- (void)handleMoveGesture:(UIPanGestureRecognizer *)recognizer {
    
    
    
    CGPoint touchLocation = [recognizer locationInView:self.superview];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            beginningPoint = touchLocation;
            beginningCenter = self.center;
            
            if ([self.delegate respondsToSelector:@selector(stickerViewDidBeginMoving:)]) {
                [self.delegate stickerViewDidBeginMoving:self];
            }
            break;
            
        case UIGestureRecognizerStateChanged:
            
            
            self.center = CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x),
                                      beginningCenter.y + (touchLocation.y - beginningPoint.y));
            if ([self.delegate respondsToSelector:@selector(stickerViewDidChangeMoving:)]) {
                [self.delegate stickerViewDidChangeMoving:self];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            
            
            
            /* self.center = CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x),
             beginningCenter.y + (touchLocation.y - beginningPoint.y));
             if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
             [self.delegate stickerViewDidEndMoving:self];
             }*/
            
            if (self.frame.origin.y<0) {
                
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect frm;
                                     if (self.frame.origin.x<0) {
                                         frm=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                                     }else{
                                          frm=CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
                                     }
                                     
                                  
                                     
                                     self.frame=frm;
                                     
                                     if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
                                         [self.delegate stickerViewDidEndMoving:self];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
                
                
                
            }else if (self.frame.origin.x<0){
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect frm;
                                     if ((self.frame.origin.y+self.frame.size.height)>self.superview.frame.size.height) {
                                         
                                         frm=CGRectMake(0, self.superview.frame.size.height-(self.frame.size.height)/2, self.frame.size.width, self.frame.size.height);
                                         
                                     }else{
                                         
                                         frm=CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                                         
                                     }
                                     
                                     
                                     self.frame=frm;
                                     
                                     if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
                                         [self.delegate stickerViewDidEndMoving:self];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
                
                
                
            }else if ((self.frame.origin.x+(self.frame.size.width)/2)>self.superview.frame.size.width){
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect frm;
                                     if ((self.frame.origin.y+self.frame.size.height)>self.superview.frame.size.height) {
                                         
                                         frm=CGRectMake(self.superview.frame.size.width-(self.frame.size.width)/2, self.superview.frame.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                                         
                                     }else{
                                         
                                          frm=CGRectMake(self.superview.frame.size.width-(self.frame.size.width)/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                                     }
                                     
                                     
                                     
                                     self.frame=frm;
                                     
                                     if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
                                         [self.delegate stickerViewDidEndMoving:self];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
                
            }else if ((self.frame.origin.y+self.frame.size.height)>self.superview.frame.size.height){
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect frm=CGRectMake(self.frame.origin.x, self.superview.frame.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                                     
                                     self.frame=frm;
                                     
                                     if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
                                         [self.delegate stickerViewDidEndMoving:self];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
                
                
            }else if (self.frame.origin.x<=0 || (self.frame.origin.y+self.frame.size.height)>self.superview.frame.size.height){
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect frm=CGRectMake(30, self.superview.frame.size.height-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                                     
                                     self.frame=frm;
                                     
                                     if ([self.delegate respondsToSelector:@selector(stickerViewDidEndMoving:)]) {
                                         [self.delegate stickerViewDidEndMoving:self];
                                     }
                                     
                                     [self layoutIfNeeded];
                                 }];
                
                
                
            }
            
            break;
            
        default:
            break;
    }

    
}

-(void)move:(id)changeFrm{
    
    
}

- (void)handlerzoomInOut:(UIPinchGestureRecognizer *)gesture
{
    
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
        //        NSLog(@"gesture.scale = %f", gesture.scale);
        
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = currentScale * gesture.scale;
        
        if (_enableZoomOut) {
            
            if (newScale < MINIMUM_SCALE) {
                newScale = MINIMUM_SCALE;
            }
            if (newScale > MAXIMUM_SCALE) {
                newScale = MAXIMUM_SCALE;
            }
        }
        
        
        if (newScale < MINIMUM_SCALE) {
            newScale = MINIMUM_SCALE;
        }
        if (newScale > MAXIMUM_SCALE) {
            newScale = MAXIMUM_SCALE;
        }
        
        NSLog(@"minimum scale %f",MINIMUM_SCALE);
        
        NSLog(@"maximum scale %f",MAXIMUM_SCALE);
        
        
        CGAffineTransform transform1 = CGAffineTransformMakeTranslation(_translation.x, _translation.y);
        CGAffineTransform transform2 = CGAffineTransformMakeScale(newScale, newScale);
        CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
        self.transform = transform;
        gesture.scale = 1;
        
        if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
            [self.delegate stikerViewZoom:self];
        }
    }
    
    

    
    
   /*
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
        //        NSLog(@"gesture.scale = %f", gesture.scale);
        
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = currentScale * gesture.scale;
        
        if (_enableZoomOut) {
            
            if (newScale < MINIMUM_SCALE) {
                newScale = MINIMUM_SCALE;
            }
            if (newScale > MAXIMUM_SCALE) {
                newScale = MAXIMUM_SCALE;
            }  
        }
        
        if (newScale < MINIMUM_SCALE) {
            newScale = MINIMUM_SCALE;
        }
        if (newScale > MAXIMUM_SCALE) {
            newScale = MAXIMUM_SCALE;
        }
        NSLog(@"minimum scale %f",MINIMUM_SCALE);
        
        NSLog(@"maximum scale %f",MAXIMUM_SCALE);


        
        [UIView animateWithDuration: 0.2 animations:^{
            //[self.view layoutIfNeeded];
            
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(_translation.x, _translation.y);
            CGAffineTransform transform2 = CGAffineTransformMakeScale(newScale, newScale);
            CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
            self.transform = transform;
            gesture.scale = 1;
            
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }

            
        }];
        
        
}
   */
    /*
    
    NSLog(@"Pinch scale: %f", recognizer.scale);
    
    
    
    CGFloat lastScaleFactor=1;
    CGFloat factor=[(UIPinchGestureRecognizer *)recognizer scale];

    if (factor>1) {
        self.transform=CGAffineTransformMakeScale(lastScaleFactor+(factor-1), lastScaleFactor+(factor-1));
        
        if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
            [self.delegate stikerViewZoom:self];
        }
    }else
    {
        if (factor>0.5) {
          
            self.transform=CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor);
            
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
        }
       
    }
    
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        
        if (factor>1) {
            
            lastScaleFactor+=(factor -1);
        }else{
            
            lastScaleFactor*=factor;
        }
        
        if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
            [self.delegate stikerViewZoom:self];
        }
    }
    */
    
    /*
    
    //CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    // you can implement any int/float value in context of what scale you want to zoom in or out
    
   //self.transform=transform;
    
    if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
        [self.delegate stikerViewZoom:self];
    }
 
    

    CGPoint touchLocation = [recognizer locationInView:self.superview];
    CGPoint center = self.center;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            
            deltaAngle = atan2f(touchLocation.y - center.y, touchLocation.x - center.x) - CGAffineTransformGetAngle(self.transform);
            initialBounds = self.bounds;
            initialDistance = CGPointGetDistance(center, touchLocation);
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
            break;
            
        case UIGestureRecognizerStateChanged: {
            
//            float angle = atan2f(touchLocation.y - center.y, touchLocation.x - center.x);
//            float angleDiff = deltaAngle - angle;
//            self.transform = CGAffineTransformMakeRotation(-angleDiff);
            
            CGFloat scale = CGPointGetDistance(center, touchLocation) / initialDistance;
            CGFloat minimumScale = self.minimumSize / MIN(initialBounds.size.width, initialBounds.size.height);
            scale = MAX(scale, minimumScale);
            CGRect scaledBounds = CGRectScale(initialBounds, scale, scale);
            
            CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
            // you can implement any int/float value in context of what scale you want to zoom in or out
            
            self.transform=transform;
            
            self.bounds = scaledBounds;
            [self setNeedsDisplay];
            
            
            
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }

            break;
        }

            
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
            break;
            
        default:
            break;
    }
    
    

    CGPoint touchLocation = [recognizer locationInView:self.superview];
    CGPoint center = self.center;
    
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            deltaAngle = atan2f(touchLocation.y - center.y, touchLocation.x - center.x) - CGAffineTransformGetAngle(self.transform);
            initialBounds = self.bounds;
            initialDistance = CGPointGetDistance(center, touchLocation);
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            float angle = atan2f(touchLocation.y - center.y, touchLocation.x - center.x);
            float angleDiff = deltaAngle - angle;
            self.transform = CGAffineTransformMakeRotation(-angleDiff);
            
            CGFloat scale = CGPointGetDistance(center, touchLocation) / initialDistance;
            CGFloat minimumScale = self.minimumSize / MIN(initialBounds.size.width, initialBounds.size.height);
            scale = MAX(scale, minimumScale);
            CGRect scaledBounds = CGRectScale(initialBounds, scale, scale);
            self.bounds = scaledBounds;
            [self setNeedsDisplay];
            
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(stikerViewZoom:)]) {
                [self.delegate stikerViewZoom:self];
            }
            break;
            
        default:
            break;
    }
*/
    
}


/*
- (void)handleRotateGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:self.superview];
    CGPoint center = self.center;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            initialBounds = self.bounds;
            initialDistance = CGPointGetDistance(center, touchLocation);
            if ([self.delegate respondsToSelector:@selector(stickerViewDidBeginRotating:)]) {
                [self.delegate stickerViewDidBeginRotating:self];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            CGFloat scale = CGPointGetDistance(center, touchLocation) / initialDistance;
            CGFloat minimumScale = self.minimumSize / MIN(initialBounds.size.width, initialBounds.size.height);
            scale = MAX(scale, minimumScale);
            CGRect scaledBounds = CGRectScale(initialBounds, scale, scale);
            self.bounds = scaledBounds;
            [self setNeedsDisplay];
            
            if ([self.delegate respondsToSelector:@selector(stickerViewDidChangeRotating:)]) {
                [self.delegate stickerViewDidChangeRotating:self];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(stickerViewDidEndRotating:)]) {
                [self.delegate stickerViewDidEndRotating:self];
            }
            break;
            
        default:
            break;
    }
}

*/

- (id)initWithContentView:(UIView *)contentView isMove:(BOOL)checkMoveStauts{
    if (!contentView) {
        return nil;
    }
    
    defaultInset = 11;
    defaultMinimumSize = 4 * defaultInset;
    
    frame = contentView.frame;
    frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, frame.size.width, frame.size.height );
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        if (checkMoveStauts) {
            [self addGestureRecognizer:self.moveGesture];
            [self addGestureRecognizer:self.tapGesture];
            [self addGestureRecognizer:self.doubleTapGesture];
            

        }
        
        [self addGestureRecognizer:self.zoomInOut];
        
        self.contentView = contentView;
        self.contentView.center = CGRectGetCenter(self.bounds);
        self.contentView.userInteractionEnabled = NO;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor=contentView.backgroundColor;
        
        
        
        self.minimumSize = defaultMinimumSize;
        [self addSubview:self.contentView];
        
        
        
    }
    return self;
}

- (id)initWithContentView:(UIView *)contentView {
    if (!contentView) {
        return nil;
    }
    
    defaultInset = 11;
    defaultMinimumSize = 4 * defaultInset;
    
     frame = contentView.frame;
    frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, frame.size.width, frame.size.height );
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
           [self addGestureRecognizer:self.moveGesture];

        
        [self addGestureRecognizer:self.zoomInOut];
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.doubleTapGesture];


        self.contentView = contentView;
        self.contentView.center = CGRectGetCenter(self.bounds);
        self.contentView.userInteractionEnabled = NO;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.backgroundColor=contentView.backgroundColor;
        
        
        
         self.minimumSize = defaultMinimumSize;
        [self addSubview:self.contentView];

        
        
    }
     return self;
}


- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(stickerViewDidTap:)]) {
        [self.delegate stickerViewDidTap:self];
    }
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer *)recognizer{
    
    
  //  self.frame=_inititalSize;
    if ([self.delegate respondsToSelector:@selector(showAlertStriker:)]) {
        [self.delegate showAlertStriker:self];
    }

    
   /*
    NSLog(@"show numbers");
    
    
   
    UIAlertController* alertAS = [UIAlertController alertControllerWithTitle:nil
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera=[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                           {
                              // [self cameraActon];
                           }];
    [alertAS addAction:camera];
    UIAlertAction *gallary=[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                            {
                                
                               // [self galleryAction];
                            }];
    [alertAS addAction:gallary];
    
    UIAlertAction *Cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Cancelaction");
    }];
    
    
    [alertAS addAction:Cancelaction];
    
   // [self presentViewController:alertAS animated:YES completion:nil];
    
    
    [self.window addSubview:alertAS];
    */
    
}



@end
