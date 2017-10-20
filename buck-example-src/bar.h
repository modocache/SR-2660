#import <Foundation/Foundation.h>
#import "Bar-Swift.h"
#import "foo.h"

NS_ASSUME_NONNULL_BEGIN

@interface BarObject: NSObject

- (Bar *)bar;
- (FooObject *)foo;

@end

NS_ASSUME_NONNULL_END

