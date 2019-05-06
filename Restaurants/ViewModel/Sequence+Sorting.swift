//
//  Sequence+Sorting
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation

//extension for Sequence protocol to sort by more than one comparison criteria
extension Sequence {
    typealias ClosureCompare = (Iterator.Element, Iterator.Element) -> ComparisonResult
    func sorted(by comparisons: ClosureCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1, e2)
                guard comparisonResult == .orderedSame
                    else { return comparisonResult == .orderedAscending }
            }
            return false
        }
    }
}
