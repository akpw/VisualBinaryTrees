//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import UIKit

public func isBalanced<T: BinaryTree>(_ tree: T) -> String {
    return tree.isBalanced ? "Balanaced" : "Not Balanced"
}

/// Helps with Sample Sequences
public struct SequenceHelper {
    public static func randomCharacterSequence(length: Int) -> AnySequence<Character> {
        return AnySequence {  Void -> AnyIterator<Character> in
            var length = length
            return AnyIterator {
                guard length > 0 else { return nil }; length -= 1
                let fromChar: UInt32 = 48, toChar: UInt32 = 126
                let value = Int(arc4random_uniform(toChar - fromChar) + fromChar)
                guard let scalar = UnicodeScalar(value) else { return nil }
                return Character(scalar)
            }
        }
    }
    
    public static func minimalHeightBSTSequence<T: Comparable>(elements: [T]) -> AnySequence<T>{
        var elements = elements; elements.sort()
        return AnySequence { Void -> AnyIterator<T> in
            var stack = [elements[elements.startIndex..<elements.endIndex]]
            return AnyIterator<T> {
                while !stack.isEmpty {
                    let slice = stack.removeLast()
                    let midIdx = (slice.endIndex - slice.startIndex) >> 1 + slice.startIndex
                    if slice.startIndex < midIdx {
                        stack.append(slice[slice.startIndex..<midIdx])
                    }
                    if midIdx.advanced(by: 1) < slice.endIndex {
                        stack.append(slice[midIdx.advanced(by: 1)..<slice.endIndex])
                    }
                    return slice[midIdx]
                }
                return nil
            }
        }
    }
}
