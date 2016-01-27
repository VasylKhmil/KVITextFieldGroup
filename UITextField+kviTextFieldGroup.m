//
//  KVITextFieldGroup.m
//  KVITextField
//
//  Created by Vasyl Khmil on 1/25/16.
//  Copyright © 2016 Vasyl Khmil. All rights reserved.
//

#import "UITextField+kviTextFieldGroup.h"
#import <objc/runtime.h>

@implementation UITextField(KVITextFieldGroup)

@dynamic kvi_nextResponder;

#pragma mark - Properties(Set)

- (void)setKvi_nextResponder:(UIResponder *)kvi_nextResponder {
    objc_setAssociatedObject(self, @selector(kvi_nextResponder), kvi_nextResponder, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Properties(Get)

- (UIResponder *)kvi_nextResponder {
    return  objc_getAssociatedObject(self, @selector(kvi_nextResponder));
}

#pragma mark - Public

- (BOOL)kvi_isLastInGroup {
    
    return self.kvi_nextResponder == nil;
}

- (void)kvi_moveNext {
    
    [self.kvi_nextResponder becomeFirstResponder];
}

@end
