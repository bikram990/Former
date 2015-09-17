//
//  SectionFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class SectionFormer: NSObject {
    
    // MARK: Public
    
    /// All RowFormers. Default is empty.
    public private(set) var rowFormers = [RowFormer]()
    
    /// ViewFormer of applying section header. Default is applying simply 10px spacing section header.
    public private(set) var headerViewFormer: ViewFormer? = ViewFormer(viewType: FormerHeaderFooterView.self, instantiateType: .Class)
    
    /// ViewFormer of applying section footer. Default is nil.
    public private(set) var footerViewFormer: ViewFormer?
    
    /// Return all row count.
    public var numberOfRows: Int {
        
        return self.rowFormers.count
    }
    
    public subscript(index: Int) -> RowFormer {
        
        return self.rowFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [RowFormer] {
        
        return Array<RowFormer>(self.rowFormers[range])
    }
    
    /// Add RowFormers to last index.
    public func add(rowFormers rowFormers: [RowFormer]) -> Self {
        
        self.rowFormers += rowFormers
        return self
    }
    
    /// Insert RowFormers to any index.
    public func insert(rowFormers rowFormers: [RowFormer], toIndex: Int) -> Self {
        
        let count = self.rowFormers.count
        
        if count == 0 ||  toIndex >= count {
            self.add(rowFormers: rowFormers)
        } else if toIndex == 0 {
            self.rowFormers = rowFormers + self.rowFormers
        } else {
            let last = self.rowFormers.count - 1
            self.rowFormers = self.rowFormers[0...(toIndex - 1)] + rowFormers + self.rowFormers[toIndex...last]
        }
        
        return self
    }
    
    /// Remove RowFormers from instances of RowFormer.
    public func remove(rowFormers rowFormers: [RowFormer]) -> Self {
        
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerate() {
            if rowFormers.contains(rowFormer) {
                self.remove(index)
                
                if ++removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove RowFormer from index.
    public func remove(atIndex: Int) -> Self {
        
        self.rowFormers.removeAtIndex(atIndex)
        return self
    }
    
    /// Remove RowFormers from range.
    public func remove(range: Range<Int>) -> Self{
        
        self.rowFormers.removeRange(range)
        return self
    }
    
    /// Set ViewFormer to apply section header.
    public func set(headerViewFormer viewFormer: ViewFormer?) -> Self {
        
        self.headerViewFormer = viewFormer
        return self
    }
    
    /// Set ViewFormer to apply section footer.
    public func set(footerViewFormer viewFormer: ViewFormer?) -> Self {
        
        self.footerViewFormer = viewFormer
        return self
    }
}