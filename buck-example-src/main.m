#import <Foundation/Foundation.h>

#import "bar.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      NSLog(@"Hello, World!");
      NSLog(@"Foo = %ld", [[[[[BarObject alloc] init] foo] foo] foo]);
      NSLog(@"Bar = %ld", [[[[BarObject alloc] init] bar] bar]);
  }
	return 0;
}
