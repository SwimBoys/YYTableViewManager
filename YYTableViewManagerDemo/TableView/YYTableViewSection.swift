//
//  YYTableViewSection.swift
//  testDemo
//
//  Created by youyongpeng on 2023/4/3.
//
//  YYTableViewSection 为 section，控制着 tableView 的 section

import UIKit

open class YYTableViewSection: NSObject {
    
    /// YYTableViewManager
    private weak var _tableViewManager: YYTableViewManager?
    public var tableViewManager: YYTableViewManager {
        set {
            _tableViewManager = newValue
        }
        get {
            guard let tableViewManager = _tableViewManager else {
                YYPrint("Please add section to manager")
                fatalError()
            }
            return tableViewManager
        }
    }
    /// item 数组
    public var items = [YYTableViewItem]()
    /// section 头部view高度
    public var headerHeight: CGFloat!
    /// section 底部view高度
    public var footerHeight: CGFloat!
    /// section 头部view
    public var headerView: UIView?
    /// section 底部view
    public var footerView: UIView?
    /// section 角标
    public var index: Int {
        return tableViewManager.sections.yy_indexOf(self)
    }
    
    public typealias voidBlock = (() -> Void)?
    
    /// 初始化
    override public init() {
        super.init()
        items = []
        headerHeight = CGFloat.leastNormalMagnitude
        footerHeight = CGFloat.leastNormalMagnitude
    }
    
    /// 初始化
    /// - Parameter headerView: headerView
    public convenience init(headerView: UIView) {
        self.init(headerView: headerView, footerView: nil)
    }
    
    /// 初始化
    /// - Parameter footerView: footerView
    public convenience init(footerView: UIView) {
        self.init(headerView: nil, footerView: footerView)
    }
    
    /// 初始化
    /// - Parameters:
    ///   - headerView: headerView
    ///   - footerView: footerView
    public convenience init(headerView: UIView?, footerView: UIView?) {
        self.init()
        if let header = headerView {
            self.headerView = header
        }
        if let footer = footerView {
            self.footerView = footer
        }
    }
    
    /// 添加 item
    /// - Parameters:
    ///   - item: item
    ///   - isReload: 是否刷新section
    public func add(item: YYTableViewItem, _ isReload: Bool = false) {
        item.section = self
        items.append(item)
        if isReload {
            self.reload(.none)
        }
    }
    
    ///  插入 item
    /// - Parameters:
    ///   - item: item
    ///   - afterItem: 在哪个 item 后边
    ///   - animate: animate
    public func insert(_ item: YYTableViewItem!, afterItem: YYTableViewItem, animate: UITableView.RowAnimation = .automatic) {
        if !items.contains(where: { $0 == afterItem }) {
            YYPrint("can't insert because afterItem did not in sections")
            return
        }
        tableViewManager.tableView.beginUpdates()
        item.section = self
        items.insert(item, at: items.yy_indexOf(afterItem) + 1)
        tableViewManager.tableView.insertRows(at: [item.indexPath], with: animate)
        tableViewManager.tableView.endUpdates()
    }
    
    /// 插入 item 数组
    /// - Parameters:
    ///   - items: items
    ///   - afterItem: 在哪个 item 后边
    ///   - animate: animate
    public func insert(_ items: [YYTableViewItem], afterItem: YYTableViewItem, animate: UITableView.RowAnimation = .automatic) {
        if !self.items.contains(where: { $0 == afterItem }) {
            YYPrint("can't insert because afterItem did not in sections")
            return
        }
        tableViewManager.tableView.beginUpdates()
        let newFirstIndex = self.items.yy_indexOf(afterItem) + 1
        self.items.insert(contentsOf: items, at: newFirstIndex)
        var arrNewIndexPath = [IndexPath]()
        for i in 0 ..< items.count {
            items[i].section = self
            arrNewIndexPath.append(IndexPath(item: newFirstIndex + i, section: afterItem.indexPath.section))
        }
        tableViewManager.tableView.insertRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
    }
    
    /// 删除
    /// - Parameters:
    ///   - itemsToDelete: item 数组
    ///   - animate: animate
    public func delete(_ itemsToDelete: [YYTableViewItem], animate: UITableView.RowAnimation = .automatic, complection: voidBlock) {
        guard itemsToDelete.count > 0 else { return }
        tableViewManager.tableView.beginUpdates()
        var arrNewIndexPath = [IndexPath]()
        for item in itemsToDelete {
            arrNewIndexPath.append(item.indexPath)
        }
        for item in itemsToDelete {
            items.remove(at: items.yy_indexOf(item))
        }
        tableViewManager.tableView.deleteRows(at: arrNewIndexPath, with: animate)
        tableViewManager.tableView.endUpdates()
        complection?()
    }
    
    /// 删除所有的item
    /// - Parameter isReload: 是否刷新
    public func removeAllItems(_ isReload: Bool = true) {
        items.removeAll()
        if isReload {
            self.reload(.none)
        }
    }
    
    /// 重置 section
    /// - Parameters:
    ///   - array: item 数组
    ///   - isReload: 是否刷新
    public func replaceItemsFrom(array: [YYTableViewItem], _ isReload: Bool = true) {
        removeAllItems()
        items = array
        if isReload {
            self.reload(.none)
        }
    }
    
    /// 刷新 section
    /// - Parameter animation: animation
    public func reload(_ animation: UITableView.RowAnimation) {
        // If crash at here, section did not in manager！
        let index = tableViewManager.sections.yy_indexOf(self)
        UIView.performWithoutAnimation {
            tableViewManager.tableView.reloadSections(IndexSet(integer: index), with: animation)
        }
        
    }
}
