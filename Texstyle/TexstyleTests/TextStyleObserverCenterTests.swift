//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import XCTest
@testable import Texstyle

final class TextStyleObserverCenter: XCTestCase {

    func testTextStyleChanging() {
        // Given
        var style: TextStyle? = .random
        style?.color = .white
        var text: Text? = .init(value: "string", style: style!)
        let attributedString = text!.attributed
        var changedAttributedString: NSAttributedString?
        var changedAttributedString2: NSAttributedString?
        // When
        autoreleasepool {
            style?.color = .red
            changedAttributedString = text!.attributed
            style?.color = .white
            changedAttributedString2 = text!.attributed
            style = nil
            text = nil
        }
        // Then
        XCTAssertNotEqual(attributedString, changedAttributedString, "Strings should not match")
        XCTAssertEqual(attributedString, changedAttributedString2, "Strings should match")
    }

    func testControlStateTextStyleChanging() {
        // Given
        let style: TextStyle = .random
        style.color = .white
        let text: ControlStateText = .init(value: "string", style: style)
        let attributedString = text.attributed
        let changedAttributedString: NSAttributedString?
        let changedAttributedString2: NSAttributedString?
        // When
        style.color = .red
        changedAttributedString = text.attributed
        style.color = .white
        changedAttributedString2 = text.attributed
        // Then
        XCTAssertNotEqual(attributedString, changedAttributedString, "Strings should not match")
        XCTAssertEqual(attributedString, changedAttributedString2, "Strings should match")
    }
}
