//
//  RowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol FormableRow: class {
    
    func configureWithRowFormer(rowFormer: RowFormer)
}

public protocol InlineRow: class {
    
    var inlineRowFormer: RowFormer { get }
    func editingDidBegin()
    func editingDidEnd()
}

internal protocol FormerValidatable: class {
    
    func validate() -> Bool
}

public class RowFormer: NSObject {
    
    public internal(set) final weak var former: Former?
    public private(set) final var cell: UITableViewCell?
    public internal(set) final var isEditing = false
    public var canBecomeEditing: Bool {
        return false
    }
    
    public private(set) var cellType: UITableViewCell.Type
    public private(set) var instantiateType: Former.InstantiateType
    public var onSelected: ((indexPath: NSIndexPath, rowFormer: RowFormer) -> Void)?
    public var cellHeight: CGFloat = 44.0
    public var enabled = true
    public var backgroundColor: UIColor?
    public var accessoryType: UITableViewCellAccessoryType?
    public var selectionStyle: UITableViewCellSelectionStyle?
    public var separatorInsets: UIEdgeInsets?
    public var tintColor: UIColor?
    
    public init<T: UITableViewCell where T: FormableRow>(
        cellType: T.Type,
        instantiateType: Former.InstantiateType,
        onSelected: ((NSIndexPath, RowFormer) -> Void)? = nil) {
            
            self.cellType = cellType
            self.instantiateType = instantiateType
            super.init()
            self.onSelected = onSelected
            self.initialize()
    }
    
    public func initialize() {
        
        self.backgroundColor = .whiteColor()
        self.separatorInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
    }
    
    final func cellConfigure() {
        
        if self.cell == nil {
            switch self.instantiateType {
            case .Class:
                self.cell = self.cellType.init(style: .Default, reuseIdentifier: nil)
            case .Nib(nibName: let nibName, bundle: let bundle):
                let bundle = bundle ?? NSBundle.mainBundle()
                self.cell = bundle.loadNibNamed(nibName, owner: nil, options: nil).first as? UITableViewCell
                assert(self.cell != nil, "Failed to load cell \(nibName) from nib.")
            }
        }
        if let formableRow = self.cell as? FormableRow {
            formableRow.configureWithRowFormer(self)
        }
        self.update()
    }
    
    final func purgeCell() {
        
        self.cell = nil
    }
    
    public func update() {
        
        if let cell = self.cell {
            
            cell.backgroundColor =? self.backgroundColor
            cell.separatorInset =? self.separatorInsets
            cell.accessoryType =? self.accessoryType
            cell.tintColor =? self.tintColor
            
            if self.enabled {
                cell.selectionStyle =? self.selectionStyle
            } else {
                cell.selectionStyle =? UITableViewCellSelectionStyle.None
            }
            
            if let row = cell as? FormableRow {
                row.configureWithRowFormer(self)
            }
        }
    }
    
    public func cellSelected(indexPath: NSIndexPath) {
        
        if self.enabled {
            self.onSelected?(indexPath: indexPath, rowFormer: self)
        }
    }
}