//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "JSQMessagesBubbleImageFactory.h"


@interface JSQMessagesMediaViewBubbleImageMasker ()

- (void)jsq_maskView:(UIView *)view withImage:(UIImage *)image;

@end


@implementation JSQMessagesMediaViewBubbleImageMasker

#pragma mark - Initialization

- (instancetype)init
{
    return [self initWithBubbleImageFactory:[[JSQMessagesBubbleImageFactory alloc] init]];
}

- (instancetype)initWithBubbleImageFactory:(JSQMessagesBubbleImageFactory *)bubbleImageFactory
{
    NSParameterAssert(bubbleImageFactory != nil);
    
    self = [super init];
    if (self) {
        _bubbleImageFactory = bubbleImageFactory;
    }
    return self;
}

#pragma mark - View masking

- (void)applyOutgoingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self jsq_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

- (void)applyIncomingBubbleImageMaskToMediaView:(UIView *)mediaView
{
    JSQMessagesBubbleImage *bubbleImageData = [self.bubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    [self jsq_maskView:mediaView withImage:[bubbleImageData messageBubbleImage]];
}

+ (void)applyBubbleImageMaskToMediaView:(UIView *)mediaView isOutgoing:(BOOL)isOutgoing
{
    JSQMessagesMediaViewBubbleImageMasker *masker = [[JSQMessagesMediaViewBubbleImageMasker alloc] init];
    
    if (isOutgoing) {
        [masker applyOutgoingBubbleImageMaskToMediaView:mediaView];
    }
    else {
        [masker applyIncomingBubbleImageMaskToMediaView:mediaView];
    }
}

#pragma mark - Private

- (void)jsq_maskView:(UIView *)view withImage:(UIImage *)image
{
    NSParameterAssert(view != nil);
    NSParameterAssert(image != nil);
    
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    
    // There seems to be an issue when creating a mask on screens with an uneven amount of pt in the width
    CGFloat addition = (((NSInteger)[UIScreen mainScreen].bounds.size.width) % 2 > 0) ? 1 : 0;
    imageViewMask.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width+addition, view.frame.size.height+1);
    
    view.layer.mask = imageViewMask.layer;
}

@end
