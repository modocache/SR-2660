#import "bar.h"

@implementation BarObject

- (Bar *)bar {
  return [Bar new];
}

- (FooObject *)foo {
  return [FooObject new];
}

@end

