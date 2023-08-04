//
//  YYRefreshViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/2.
//

import UIKit

class YYRefreshViewController: UIViewController {

    private var tableViewManager: YYTableViewManager!
    
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "添加上拉和下拉刷新"
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        tableViewManager = YYTableViewManager(tableView: tableView, true)
        tableViewManager.register(YYDefaultCell.self)
        tableViewManager.defaultTableViewCellHeight = 50
        tableView.setRefreshStyle(.Normal)
        tableView.loadNewDataCallback = { [weak self] in
            guard let this = self else {return}
            /// 模拟网络请求
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                this.loadNewData()
            }
        }
        tableView.loadMoreDataCallback = { [weak self] in
            guard let this = self else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                this.loadMoreData()
            }
        }
        tableView.headerRefreshViewStart()
    }
    
    func loadNewData() {
        page = 1
        tableViewManager.section.removeAllItems()
        for _ in 0...10 {
            let item = YYTableViewItem("YYDefaultCell")
            tableViewManager.section.add(item: item, false)
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    cell.backgroundColor = .lightGray
                    cell.textLabel?.text = "第" + "\(callBackItem.indexPath.row)" + "行"
                }
            }
        }
        tableViewManager.reload()
        tableViewManager.tableView.showFooterRefrsehView()
        tableViewManager.tableView.EndRefrseh(.MoreData, isShowNoMoreDataTitle: true)
    }

    func loadMoreData() {
        page += 1
        for _ in 0...10 {
            let item = YYTableViewItem("YYDefaultCell")
            tableViewManager.section.add(item: item, false)
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    cell.backgroundColor = .lightGray
                    cell.textLabel?.text = "第" + "\(callBackItem.indexPath.row)" + "行"
                }
            }
        }
        tableViewManager.reload()
        if page == 3 {
            tableViewManager.tableView.EndRefrseh(.NoMoreData, isShowNoMoreDataTitle: false)
        } else {
            tableViewManager.tableView.EndRefrseh(.MoreData, isShowNoMoreDataTitle: true)
        }
    }
}
