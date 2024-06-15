//
//  TOCropOverlayView.m
//
//  Copyright 2015-2024 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOCropOverlayView.h"

static const CGFloat kTOCropOverLayerCornerWidth = 20.0f;
static const CGFloat kTOCropOverLayerCustomCornerWidth = 75.0f;

@interface TOCropOverlayView ()

@property (nonatomic, strong) NSArray *horizontalGridLines;
@property (nonatomic, strong) NSArray *verticalGridLines;
@property (nonatomic, strong) NSArray *outerLineViews;   // top, right, bottom, left
@property (nonatomic, strong) NSArray *topLeftLineViews; // vertical, horizontal
@property (nonatomic, strong) NSArray *bottomLeftLineViews;
@property (nonatomic, strong) NSArray *bottomRightLineViews;
@property (nonatomic, strong) NSArray *topRightLineViews;
@property (nonatomic, assign, readwrite) ToCropViewInterfaceStyle interfaceStyle;

@end

@implementation TOCropOverlayView

- (instancetype)initWithFrame:(CGRect)frame interfaceStyle:(ToCropViewInterfaceStyle)interfaceStyle {
   if (self = [super initWithFrame:frame]) {
       self.clipsToBounds = NO;
       _interfaceStyle = interfaceStyle;
       [self setup];
   }
   return self;
}

- (void)setup {
   UIView *(^newLineView)(void) = ^UIView *(void){
       return [self createNewLineView];
   };

   _outerLineViews = @[newLineView(), newLineView(), newLineView(), newLineView()];
   _topLeftLineViews = @[newLineView(), newLineView()];
   _bottomLeftLineViews = @[newLineView(), newLineView()];
   _topRightLineViews = @[newLineView(), newLineView()];
   _bottomRightLineViews = @[newLineView(), newLineView()];
   
   self.displayHorizontalGridLines = YES;
   self.displayVerticalGridLines = YES;
}

- (void)setFrame:(CGRect)frame {
   [super setFrame:frame];
   if (_outerLineViews) {
       [self layoutLines];
   }
}

- (void)didMoveToSuperview {
   [super didMoveToSuperview];
   if (_outerLineViews) {
       [self layoutLines];
   }
}

- (void)layoutLines {
   CGSize boundsSize = self.bounds.size;
    self.backgroundColor = _interfaceStyle ? [UIColor colorWithWhite:1.0 alpha:0.25] : nil;

   //Border lines

    if (_interfaceStyle == ToCropViewInterfaceStyleCustom) {
        
    }
   for (NSInteger i = 0; i < 4; i++) {
       UIView *lineView = self.outerLineViews[i];
       
       CGRect frame = CGRectZero;
       switch (i) {
           case 0: frame = (CGRect){-1.0f,-1.0f,boundsSize.width+2.0f, 2.0f}; break; // top
           case 1: frame = (CGRect){boundsSize.width,0.0f,2.0f,boundsSize.height}; break; // right
           case 2: frame = (CGRect){-1.0f,boundsSize.height,boundsSize.width+2.0f,2.0f}; break; // bottom
           case 3: frame = (CGRect){-1.0f,0,2.0f,boundsSize.height+1.0f}; break; // left
       }
       
       lineView.frame = frame;
       lineView.backgroundColor = _interfaceStyle ? [UIColor grayColor] : nil;
   }
   
   //Corner lines
   NSArray *cornerLines = @[self.topLeftLineViews, self.topRightLineViews, self.bottomRightLineViews, self.bottomLeftLineViews];
   for (NSInteger i = 0; i < 4; i++) {
       NSArray *cornerLine = cornerLines[i];
       
       CGRect verticalFrame = CGRectZero, horizontalFrame = CGRectZero;
       switch (i) {
           case 0: //top left
               verticalFrame = _interfaceStyle ? (CGRect){-3.0f,-3.0f,6.0f,kTOCropOverLayerCustomCornerWidth+3.0f} : (CGRect){-3.0f,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
               horizontalFrame = _interfaceStyle ? (CGRect){0,-3.0f,kTOCropOverLayerCustomCornerWidth,6.0f} : (CGRect){0,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
               break;
           case 1: //top right
               verticalFrame = _interfaceStyle ? (CGRect){boundsSize.width,-3.0f,6.0f,kTOCropOverLayerCustomCornerWidth+3.0f} : (CGRect){boundsSize.width,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
               horizontalFrame = _interfaceStyle ? (CGRect){boundsSize.width-kTOCropOverLayerCustomCornerWidth,-3.0f,kTOCropOverLayerCustomCornerWidth,6.0f} : (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
               break;
           case 2: //bottom right
               verticalFrame = _interfaceStyle ? (CGRect){boundsSize.width,boundsSize.height-kTOCropOverLayerCustomCornerWidth,6.0f,kTOCropOverLayerCustomCornerWidth+3.0f} : (CGRect){boundsSize.width,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth+3.0f};
               horizontalFrame = _interfaceStyle ? (CGRect){boundsSize.width-kTOCropOverLayerCustomCornerWidth + 5.0f,boundsSize.height,kTOCropOverLayerCustomCornerWidth,6.0f} : (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,boundsSize.height,kTOCropOverLayerCornerWidth,3.0f};
               break;
           case 3: //bottom left
               verticalFrame = _interfaceStyle ? (CGRect){-3.0f,boundsSize.height-kTOCropOverLayerCustomCornerWidth,6.0f,kTOCropOverLayerCustomCornerWidth} : (CGRect){-3.0f,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth};
               horizontalFrame =  _interfaceStyle ? (CGRect){-3.0f,boundsSize.height,kTOCropOverLayerCustomCornerWidth+3.0f,6.0f} : (CGRect){-3.0f,boundsSize.height,kTOCropOverLayerCornerWidth+3.0f,3.0f};
               break;
       }
       
       [cornerLine[0] setFrame:verticalFrame];
       [cornerLine[1] setFrame:horizontalFrame];
   }
   
   //Grid lines - horizontal
    CGFloat thickness = _interfaceStyle ? 6.0f / self.traitCollection.displayScale : 1.0f / self.traitCollection.displayScale;
   NSInteger numberOfLines = self.horizontalGridLines.count;
   CGFloat padding = (CGRectGetHeight(self.bounds) - (thickness * numberOfLines)) / (numberOfLines + 1);
   for (NSInteger i = 0; i < numberOfLines; i++) {
       UIView *lineView = self.horizontalGridLines[i];
       CGRect frame = CGRectZero;
       frame.size.height = thickness;
       frame.size.width = CGRectGetWidth(self.bounds);
       frame.origin.y = (padding * (i+1)) + (thickness * i);
       lineView.backgroundColor = _interfaceStyle ? [UIColor grayColor] : [UIColor whiteColor];
       lineView.frame = frame;
   }
   
   //Grid lines - vertical
   numberOfLines = self.verticalGridLines.count;
   padding = (CGRectGetWidth(self.bounds) - (thickness * numberOfLines)) / (numberOfLines + 1);
   for (NSInteger i = 0; i < numberOfLines; i++) {
       UIView *lineView = self.verticalGridLines[i];
       CGRect frame = CGRectZero;
       frame.size.width = thickness;
       frame.size.height = CGRectGetHeight(self.bounds);
       frame.origin.x = (padding * (i+1)) + (thickness * i);
       lineView.frame = frame;
       lineView.backgroundColor = _interfaceStyle ? [UIColor grayColor] : [UIColor whiteColor];
   }
}

- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated {
   _gridHidden = NO;
   
   if (animated == NO) {
       for (UIView *lineView in self.horizontalGridLines) {
           lineView.alpha = hidden ? 0.0f : 1.0f;
       }
       
       for (UIView *lineView in self.verticalGridLines) {
           lineView.alpha = hidden ? 0.0f : 1.0f;
       }
   
       return;
   }
   
   [UIView animateWithDuration:hidden ? 0.35f : 0.2f animations:^{
       for (UIView *lineView in self.horizontalGridLines)
           lineView.alpha = hidden ? 0.0f : 1.0f;
       
       for (UIView *lineView in self.verticalGridLines)
           lineView.alpha = hidden ? 0.0f : 1.0f;
   }];
}

#pragma mark - Property methods

- (void)setDisplayHorizontalGridLines:(BOOL)displayHorizontalGridLines {
   _displayHorizontalGridLines = displayHorizontalGridLines;
   
   [self.horizontalGridLines enumerateObjectsUsingBlock:^(UIView *__nonnull lineView, NSUInteger idx, BOOL * __nonnull stop) {
       [lineView removeFromSuperview];
   }];
   
   if (_displayHorizontalGridLines) {
       self.horizontalGridLines = _interfaceStyle ? @[[self createNewLineView], [self createNewLineView], [self createNewLineView]] : @[[self createNewLineView], [self createNewLineView]];
   } else {
       self.horizontalGridLines = @[];
   }
   [self setNeedsDisplay];
}

- (void)setDisplayVerticalGridLines:(BOOL)displayVerticalGridLines {
   _displayVerticalGridLines = displayVerticalGridLines;
   
   [self.verticalGridLines enumerateObjectsUsingBlock:^(UIView *__nonnull lineView, NSUInteger idx, BOOL * __nonnull stop) {
       [lineView removeFromSuperview];
   }];
   
   if (_displayVerticalGridLines) {
       self.verticalGridLines = _interfaceStyle ? @[[self createNewLineView], [self createNewLineView], [self createNewLineView]] : @[[self createNewLineView], [self createNewLineView]];
   } else {
       self.verticalGridLines = @[];
   }
   [self setNeedsDisplay];
}
- (void)setGridHidden:(BOOL)gridHidden
{
   [self setGridHidden:NO animated:NO];
}

#pragma mark - Private methods

- (nonnull UIView *)createNewLineView {
   UIView *newLine = [[UIView alloc] initWithFrame:CGRectZero];
    newLine.backgroundColor = _interfaceStyle ? [[UIColor blackColor] colorWithAlphaComponent:1] : [UIColor whiteColor];
   [self addSubview:newLine];
   return newLine;
}

@end
