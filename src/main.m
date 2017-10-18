#import <Foundation/Foundation.h>

#import "Foo-Swift.h"
#import "Bar-Swift.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      NSLog(@"Hello, World!");
      NSLog(@"Foo = %ld", [[[Foo alloc] init] foo]);
      NSLog(@"Bar = %ld", [[[Bar alloc] init] bar]);
  }
	return 0;
}
