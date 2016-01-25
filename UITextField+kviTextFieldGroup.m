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

@dynamic kvi_groupIdentifier, kvi_groupPriority;

#pragma mark - Properties

#pragma mark - Properties(Set)

- (void)setKvi_groupIdentifier:(NSString *)kvi_groupIdentifier {
    objc_setAssociatedObject(self, @selector(kvi_groupIdentifier), kvi_groupIdentifier, OBJC_ASSOCIATION_RETAIN);
    
    [self kvi_tryAddToGroup];
}

- (void)setKvi_groupPriority:(NSInteger)kvi_groupPriority {
    objc_setAssociatedObject(self, @selector(kvi_groupPriority), @(kvi_groupPriority), OBJC_ASSOCIATION_RETAIN);
    
    [self kvi_tryAddToGroup];
}

#pragma mark - Properties(Get)

- (NSString *)kvi_groupIdentifier {
    return  objc_getAssociatedObject(self, @selector(kvi_groupIdentifier));
}

- (NSInteger)kvi_groupPriority {
    NSNumber *result = objc_getAssociatedObject(self, @selector(kvi_groupPriority));
    
    return (result == nil) ? NSNotFound : result.integerValue;
}

#pragma mark - Public

- (BOOL)kvi_isLastInGroup {
    NSArray *group = [self kvi_currentGroupTextFields];
    
    return group.lastObject == self;
}

- (void)kvi_moveNext {
    
    if (![self kvi_isLastInGroup]) {
        NSArray *group = [self kvi_currentGroupTextFields];
        
        NSInteger selfIndex = [group indexOfObject:self];
        
        if (selfIndex != NSNotFound) {
            UITextField *nextTextField = group[selfIndex + 1];
            
            [nextTextField becomeFirstResponder];
        }
        
    }
}

#pragma mark - Private

+ (NSMutableDictionary *)kvi_containerDictionary {
    
    static dispatch_once_t ContainerDictionaryOnceToken;
    
    static NSMutableDictionary *result;
    
    dispatch_once(&ContainerDictionaryOnceToken, ^{
        result = [NSMutableDictionary new];
    });
    
    return result;
    
}

- (NSMutableArray *)kvi_currentGroupTextFields {
    NSMutableDictionary *container = UITextField.kvi_containerDictionary;
    
    NSMutableArray *textFields;
    
    if (self.kvi_groupIdentifier == nil) {
        textFields = nil;
        
    } else {
        textFields = container[self.kvi_groupIdentifier];
        
        if (textFields == nil) {
            textFields = [NSMutableArray new];
            
            container[self.kvi_groupIdentifier] = textFields;
        }
    }
    
    return textFields;
}

- (void)kvi_sortCurrentGroup {
    NSMutableArray *group = [self kvi_currentGroupTextFields];
    
    [group sortUsingComparator:^NSComparisonResult(UITextField*  _Nonnull obj1, UITextField*  _Nonnull obj2) {
        return obj1.kvi_groupPriority > obj2.kvi_groupPriority;
    }];
}

- (void)kvi_tryAddToGroup {
    if (self.kvi_groupPriority != NSNotFound &&
        self.kvi_groupIdentifier != nil) {
        
        NSMutableArray *groupTextFields = [self kvi_currentGroupTextFields];
        
        if ([groupTextFields indexOfObject:self] == NSNotFound) {
         
            [groupTextFields addObject:self];
            
            [self kvi_sortCurrentGroup];
        }
        
    }
}

@end
