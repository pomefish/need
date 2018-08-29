//
//  UIControl+Disable.m
//  guanxinApp
//
//  Created by 郑强飞 on 16/3/30.
//  Copyright © 2016年 Zhenwei. All rights reserved.
//

#import "UIControl+Disable.h"
#import "objc/runtime.h"

@implementation UIControl (Disable)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval )disable_EventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setDisable_EventInterval:(NSTimeInterval)disable_EventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(disable_EventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )cjr_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setCjr_acceptEventTime:(NSTimeInterval)cjr_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(cjr_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(cjr_sendAction:to:forEvent:));
    SEL mySEL = @selector(cjr_sendAction:to:forEvent:);
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    } else {
        method_exchangeImplementations(systemMethod, myMethod);
    }
}

- (void)cjr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (NSDate.date.timeIntervalSince1970 - self.cjr_acceptEventTime < self.disable_EventInterval) {
        return;
    }
    if (!target || !action) {
        return;
    }
    if (self.disable_EventInterval > 0) {
        self.cjr_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }

    [self cjr_sendAction:action to:target forEvent:event];
}

@end
