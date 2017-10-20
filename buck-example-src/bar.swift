import Foundation
import Foo

@objc public class Bar: NSObject {
	@objc public func bar() -> Int {
	  return Foo().foo() + 4
	}
}
