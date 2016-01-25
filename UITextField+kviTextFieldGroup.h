//
//  KVITextFieldGroup.h
//  KVITextField
//
//  Created by Vasyl Khmil on 1/25/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (KVITextFieldGroup)

@property (nonatomic, copy) IBInspectable NSString *kvi_groupIdentifier;

@property (nonatomic) IBInspectable NSInteger kvi_groupPriority;

- (BOOL)kvi_isLastInGroup;

- (void)kvi_moveNext;

@end
