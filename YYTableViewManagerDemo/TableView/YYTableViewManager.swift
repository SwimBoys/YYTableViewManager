//
//  YYTableViewManager.swift
//  testDemo
//
//  Created by youyongpeng on 2023/4/3.
//
//  YYTableViewManager 为 tableView 的管理者

import UIKit

open class YYTableViewManager: NSObject {
    
    /// YYBaseTableView
    public var tableView: YYBaseTableView!
    /// section
    public var sections: [YYTableViewSection] = []
    private let minHeight: CGFloat = 0.00001
    // MARK: - 下边为只有一个 section 的设置
    /// 获取 section
    public var section: YYTableViewSection {
        get {
            guard let sec = sections.first else {
                fatalError()
            }
            return sec
        }
    }
    /// 默认 cell 的高度
    /// 当高度一样时，可只设置这个值
    var defaultTableViewCellHeight: CGFloat = 44
    /// 默认 cell 风格
    public var style: UITableViewCell.CellStyle = .default
    /// 默认 cell 附加样式
    public var accessoryType: UITableViewCell.AccessoryType = .none
    /// 默认 cell 选中时的 style
    public var selectionStyle: UITableViewCell.SelectionStyle = .none
    /// 默认 cell 是否允许被选中
    public var isAllowSelect: Bool = true
    /// cell 点击回调
    public typealias tableViewItemBlock = (YYTableViewItem) -> Void
    public var selectCellHandler: tableViewItemBlock?
    
    /// 初始化
    /// - Parameters:
    ///   - tableView: tableView
    ///   - isUseNormalSection: 是否使用默认的 section（当只有一个section时，可设置为TRUE）
    public init(tableView: YYBaseTableView, _ isUseNormalSection: Bool = false) {
        super.init()
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        if isUseNormalSection {
            add(section: YYTableViewSection())
        }
    }
    
    /// 注册 cell
    /// - Parameters:
    ///   - cell: cell
    ///   - cellReuseIdentifier: cellReuseIdentifier
    ///   - bundle: bundle
    public func register(_ cell: YYInternalCellProtocol.Type, _ cellReuseIdentifier: String = "", _ bundle: Bundle = Bundle.main) {
        var cellIdentifier = cellReuseIdentifier
        if cellReuseIdentifier == "" {
            cellIdentifier = "\(cell)"
        }
        if bundle.path(forResource: "\(cell)", ofType: "nib") != nil {
            tableView.register(UINib(nibName: "\(cell)", bundle: bundle), forCellReuseIdentifier: cellIdentifier)
        } else {
            tableView.register(cell, forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    /// 添加 section
    /// - Parameter section: section
    public func add(section: YYTableViewSection) {
        if !section.isKind(of: YYTableViewSection.self) {
            YYPrint("error section class")
            return
        }
        section.tableViewManager = self
        sections.append(section)
    }
    
    /// 刷新列表
    public func reload() {
        tableView.reloadData()
    }
    
    /// 更改item.cellHeight后，请使用此方法更新单元格高度
    public func updateHeight() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    /// 获取 section
    /// - Parameter index: section 角标
    /// - Returns: section
    func sectionFrom(index: Int) -> YYTableViewSection {
        let section = sections.count > index ? sections[index] : nil
        assert(section != nil, "section out of range")
        return section!
    }
    
    /// 获取 section 和 item
    /// - Parameter indexPath: indexPath
    /// - Returns: description
    func getSectionAndItem(indexPath: (section: Int, row: Int)) -> (section: YYTableViewSection, item: YYTableViewItem) {
        let section = sectionFrom(index: indexPath.section)
        let item = section.items.count > indexPath.row ? section.items[indexPath.row] : nil
        assert(item != nil, "row out of range")
        return (section, item!)
    }
    
    /// 删除 section
    /// - Parameters:
    ///   - section: section
    ///   - isReload: 是否刷新
    public func remove(section: YYTableViewSection, _ isReload: Bool = true) {
        if !(section as AnyObject).isKind(of: YYTableViewSection.self) {
            YYPrint("error section class")
            return
        }
        sections.remove(at: sections.yy_indexOf(section))
        if isReload {
            self.reload()
        }
    }
    
    /// 获取选中的 item
    /// - Returns: item 数组
    public func selectedItems() -> [YYTableViewItem] {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            var items = [YYTableViewItem]()
            for idx in indexPaths {
                items.append(sections[idx.section].items[idx.row])
            }
            return items
        }
        return []
    }
    
    /// 选中 item 数组
    /// - Parameters:
    ///   - items: item 数组
    ///   - animated: animated description
    ///   - scrollPosition: scrollPosition description
    public func selectItems(_ items: [YYTableViewItem], animated: Bool = true, scrollPosition: UITableView.ScrollPosition = .none) {
        for item in items {
            item.select(animated: animated, scrollPosition: scrollPosition)
        }
    }
    
    /// 取消选中 item 数组
    /// - Parameters:
    ///   - items: item 数组
    ///   - animated: animated description
    public func deselectItems(_ items: [YYTableViewItem], animated: Bool = true) {
        for item in items {
            item.deselect(animated: animated)
        }
    }
    
    // MARK: - 下边为只有一个 section 的方法
    /// 根据 row 获取 item
    /// - Parameters:
    ///   - row: row
    public func getItem(_ row: Int) -> YYTableViewItem? {
        if row < section.items.count {
            return section.items[row]
        }
        return nil
    }
}

// MARK: - UITableViewDataSource
extension YYTableViewManager: UITableViewDataSource {
    
    public func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = sectionFrom(index: section)
        return sectionModel.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (_, item) = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))

        var cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier) as? YYInternalCellProtocol
        if cell == nil {
            var itemStyle = self.style
            if let itemS = item.style {
                itemStyle = itemS
            }
            cell = (YYDefaultCell(style: itemStyle, reuseIdentifier: item.cellIdentifier) as YYInternalCellProtocol)
        }
        let unwrappedCell = cell!
        if let itemAccessoryType = item.accessoryType {
            unwrappedCell.accessoryType = itemAccessoryType
        } else {
            unwrappedCell.accessoryType = self.accessoryType
        }
        if let itemSelectionStyle = item.selectionStyle {
            unwrappedCell.selectionStyle = itemSelectionStyle
        } else {
            unwrappedCell.selectionStyle = self.selectionStyle
        }
        unwrappedCell.cellPrepared()
        return unwrappedCell
    }
}

// MARK: - UITableViewDelegate
extension YYTableViewManager: UITableViewDelegate {
    
    public func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))
        if let itemHandler = obj.item.selectCellHandler {
            itemHandler(obj.item)
        }
        if let handler = self.selectCellHandler {
            handler(obj.item)
        }
    }
    
    public func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = sectionFrom(index: section)
        return sectionModel.headerView
    }

    public func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = sectionFrom(index: section)
        return sectionModel.footerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = sectionFrom(index: section)
        if sectionModel.headerView != nil {
            if (sectionModel.headerHeight > minHeight && sectionModel.headerHeight != CGFloat.leastNormalMagnitude) {
                return sectionModel.headerHeight
            }
        }
        return minHeight
    }

    public func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = sectionFrom(index: section)
        if sectionModel.footerView != nil {
            if (sectionModel.footerHeight > minHeight && sectionModel.footerHeight != CGFloat.leastNormalMagnitude) {
                return sectionModel.footerHeight
            }
        }
        return minHeight
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        let item = section.items[indexPath.row]
        if (item.cellHeight != 0) {
            return item.cellHeight
        }
        return defaultTableViewCellHeight
    }
    
    public func tableView(_: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! YYInternalCellProtocol).cellDidDisappear()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let obj = getSectionAndItem(indexPath: (indexPath.section, indexPath.row))
        obj.item.cell = cell
        if let itemHandler = obj.item.cellWillDisplayHandler {
            itemHandler(obj.item)
        }
        (cell as! YYInternalCellProtocol).cellWillAppear()
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))
        var isAllow = isAllowSelect
        if let itemIsAllow = obj.item.isAllowSelect {
            isAllow = itemIsAllow
        }
        if isAllow {
            return indexPath
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))
        var conf: UISwipeActionsConfiguration?
        if let titleArr = obj.item.leftSwipeActionsTitleArr {
            var actionArr: [UIContextualAction] = []
            for i in 0..<titleArr.count {
                let action = UIContextualAction(style: .normal, title: titleArr[i]) { action, view, completion in
                    obj.item.leftSwipeActionsBackHandler?(obj.item, i)
                    completion(true)
                }
                if let colorArr = obj.item.leftSwipeActionsBackgroundColorArr, i < colorArr.count {
                    action.backgroundColor = colorArr[i]
                } else {
                    action.backgroundColor = .red
                }
                if let imageNameArr = obj.item.leftSwipeActionsImageNameArr, i < imageNameArr.count {
                    action.image = UIImage.init(named: imageNameArr[i])
                }
                actionArr.append(action)
            }
            conf = UISwipeActionsConfiguration(actions: actionArr)
        }
        return conf
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let obj = getSectionAndItem(indexPath: (section: indexPath.section, row: indexPath.row))
        var conf: UISwipeActionsConfiguration?
        if let titleArr = obj.item.rightSwipeActionsTitleArr {
            var actionArr: [UIContextualAction] = []
            for i in 0..<titleArr.count {
                let action = UIContextualAction(style: .normal, title: titleArr[i]) { action, view, completion in
                    obj.item.rightSwipeActionsBackHandler?(obj.item, i)
                    completion(true)
                }
                if let colorArr = obj.item.rightSwipeActionsBackgroundColorArr, i < colorArr.count {
                    action.backgroundColor = colorArr[i]
                } else {
                    action.backgroundColor = .red
                }
                if let imageNameArr = obj.item.rightSwipeActionsImageNameArr, i < imageNameArr.count {
                    action.image = UIImage.init(named: imageNameArr[i])
                }
                actionArr.append(action)
            }
            conf = UISwipeActionsConfiguration(actions: actionArr)
        }
        return conf
    }
}

class YYDefaultCell: UITableViewCell, YYInternalCellProtocol {

    func cellPrepared() {
    }
}

/// 屏幕宽
let KScreenW = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
/// 屏幕高
let KScreenH = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
/// 竖屏只有statusbar的安全边距
var gSafeAreaInsets: UIEdgeInsets {
    get {
        return UIEdgeInsets(top: UIDevice.vg_statusBarHeight(), left: 0, bottom: UIDevice.vg_safeDistanceBottom(), right: 0)
    }
}

extension UIDevice {
    
    /// 底部安全区高度
    static func vg_safeDistanceBottom() -> CGFloat {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
    /// 顶部状态栏高度（包括安全区）
    static func vg_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}

/// 带格式Log
public func YYPrint<T>(_ message: T,
                        file: String = #file,
                        line: Int = #line,
                        funcName : String = #function) {
    #if DEBUG
    print(" -YYPrint- \((file as NSString).lastPathComponent) - [\(funcName)] - [\(line)] \n -YYPrint- \(message)")
    #endif
}

extension Array where Element: Equatable {
    func yy_indexOf(_ element: Element) -> Int {
        var index: Int?

        #if swift(>=5)
            index = firstIndex { (e) -> Bool in
                e == element
            }
        #else
            index = self.index(where: { (e) -> Bool in
                e == element
            })
        #endif

        assert(index != nil, "Can't find element in array, please check you code")
        return index!
    }
}
