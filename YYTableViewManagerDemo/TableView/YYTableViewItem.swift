//
//  YYTableViewItem.swift
//  testDemo
//
//  Created by youyongpeng on 2023/4/3.
//
//
//  YYTableViewItem为单个cell的代理,可自由设置一些参数


import UIKit

open class YYTableViewItem: NSObject {
    
    /// YYTableViewManager
    public var tableVManager: YYTableViewManager {
        return section.tableViewManager
    }
    /// YYTableViewSection，当前 item 所属的 section
    private weak var _section: YYTableViewSection?
    public var section: YYTableViewSection {
        set {
            _section = newValue
        }
        get {
            guard let s = _section else { fatalError() }
            return s
        }
    }
    /// 重用标识符
    public var cellIdentifier: String!
    /// cell的高度，可单独设置
    public var cellHeight: CGFloat = 0
    /// cell 风格
    public var style: UITableViewCell.CellStyle?
    /// cell 附加样式
    public var accessoryType: UITableViewCell.AccessoryType?
    /// cell 选中时的 style
    public var selectionStyle: UITableViewCell.SelectionStyle?
    /// cell 是否允许被选中
    public var isAllowSelect: Bool?
    /// cell 是否选中
    public var isSelected: Bool {
        return cell.isSelected
    }
    /// 获取当前 item 对应的 cell
    public var cell: UITableViewCell!
    /// 获取 cell 的 IndexPath
    public var indexPath: IndexPath {
        let rowIndex = self.section.items.yy_indexOf(self)
        let section = tableVManager.sections.yy_indexOf(self.section)
        return IndexPath(item: rowIndex, section: section)
    }
    public typealias tableViewItemBlock = (YYTableViewItem) -> Void
    /// cell即将显示回调，在这个回调里边可获得显示的 cell，要不然 cell 为 nil
    public var cellWillDisplayHandler: tableViewItemBlock?
    public func setCellWillDisplayHandler(_ handler: ((_ callBackItem: YYTableViewItem) -> Void)?) {
        cellWillDisplayHandler = { item in
            handler?(item)
        }
    }
    /// cell点击事件的回调
    public var selectCellHandler: tableViewItemBlock?
    public func setSelectCellHandler(_ handler: ((_ callBackItem: YYTableViewItem) -> Void)?) {
        selectCellHandler = { item in
            handler?(item)
        }
    }
    /// cell 左滑事件回调
    var leftSwipeActionsTitleArr: [String]?
    var leftSwipeActionsBackgroundColorArr: [UIColor]?
    var leftSwipeActionsImageNameArr: [String]?
    public typealias swipeActionsBlock = (YYTableViewItem, Int) -> Void
    public var leftSwipeActionsBackHandler: swipeActionsBlock?
    public func setLeftSwipeActionsHandler(_ titleArr: [String], backgroundColorArr: [UIColor] = [], imageNameArr: [String] = [], _ handler: ((_ callBackItem: YYTableViewItem, _ actionIndex: Int) -> Void)?) {
        leftSwipeActionsTitleArr = titleArr
        leftSwipeActionsBackgroundColorArr = backgroundColorArr
        leftSwipeActionsImageNameArr = imageNameArr
        leftSwipeActionsBackHandler = { (item, index) in
            handler?(item, index)
        }
    }
    /// cell 右滑事件回调
    var rightSwipeActionsTitleArr: [String]?
    var rightSwipeActionsBackgroundColorArr: [UIColor]?
    var rightSwipeActionsImageNameArr: [String]?
    public var rightSwipeActionsBackHandler: swipeActionsBlock?
    public func setRightSwipeActionsHandler(_ titleArr: [String], backgroundColorArr: [UIColor] = [], imageNameArr: [String] = [], _ handler: ((_ callBackItem: YYTableViewItem, _ actionIndex: Int) -> Void)?) {
        rightSwipeActionsTitleArr = titleArr
        rightSwipeActionsBackgroundColorArr = backgroundColorArr
        rightSwipeActionsImageNameArr = imageNameArr
        rightSwipeActionsBackHandler = { (item, index) in
            handler?(item, index)
        }
    }
    
    /// 初始化
    /// - Parameter cellIdentifier: 重用标识符
    init(_ cellIdentifier: String) {
        super.init()
        self.cellIdentifier = cellIdentifier
    }
    
    /// 刷新单个cell
    /// - Parameter animation: animation
    public func reload(_ animation: UITableView.RowAnimation) {
        tableVManager.tableView.beginUpdates()
        tableVManager.tableView.reloadRows(at: [indexPath], with: animation)
        tableVManager.tableView.endUpdates()
    }
    
    /// 删除单个cell
    /// - Parameter animation: animation
    public func delete(_ animation: UITableView.RowAnimation = .automatic) {
        if !section.items.contains(where: { $0 == self }) {
            YYPrint("can't delete because this item did not in section")
            return
        }
        let indexPath = self.indexPath
        section.items.remove(at: indexPath.row)
        tableVManager.tableView.deleteRows(at: [indexPath], with: animation)
    }
    
    /// 滚动到cell
    /// - Parameters:
    ///   - animated: animated
    ///   - scrollPosition: scrollPosition
    public func scroll(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        tableVManager.tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    /// 选中单个cell
    /// - Parameters:
    ///   - animated: animated
    ///   - scrollPosition: scrollPosition
    public func select(animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        if let isAllow = isAllowSelect {
            if isAllow {
                tableVManager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
            }
        } else {
            if tableVManager.isAllowSelect {
                tableVManager.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
            }
        }
    }
    
    /// 取消选中单个cell
    /// - Parameter animated: animated
    public func deselect(animated: Bool = true) {
        tableVManager.tableView.deselectRow(at: indexPath, animated: animated)
    }
}

// MARK: - YYInternalCellProtocol
public protocol YYInternalCellProtocol where Self: UITableViewCell {
    func cellPrepared()
    /// cell即将出现在屏幕中的回调方法 在这个方法里面赋值
    func cellWillAppear()
    func cellDidDisappear()
}

public extension YYInternalCellProtocol {
    func cellPrepared() {}
    func cellWillAppear() {}
    func cellDidDisappear() {}
}
