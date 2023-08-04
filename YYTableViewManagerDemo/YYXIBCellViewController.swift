//
//  YYXIBCellViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/2.
//  当使用自定义cell的时候，cell必须遵循 YYInternalCellProtocol

import UIKit

class YYXIBCellViewController: UIViewController {
    
    private var tableViewManager: YYTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "XIB自定义cell"
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        /// 当只有一个section时，最后一个属性设置为TRUE
        tableViewManager = YYTableViewManager(tableView: tableView, true)
        tableViewManager.register(YYXIBTableViewCell.self)
        tableViewManager.defaultTableViewCellHeight = 50
        
        for _ in 0...30 {
            let item = YYTableViewItem("YYXIBTableViewCell")
            tableViewManager.section.add(item: item, false)
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYXIBTableViewCell {
                    cell.backgroundColor = .lightGray
                }
            }
            
            /// 也可在这里操作 cell 点击
            item.setSelectCellHandler { callBackItem in
                if let cell = callBackItem.cell as? YYXIBTableViewCell {
                    print(cell)
                }
            }
        }
        
        tableViewManager.reload()
    }

}
