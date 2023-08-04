//
//  YYDefaultCellViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/1.
//

import UIKit

class YYDefaultCellViewController: UIViewController {

    private var tableViewManager: YYTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "默认cell"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        /// 当只有一个section时，最后一个属性设置为TRUE
        tableViewManager = YYTableViewManager(tableView: tableView, true)
        /// 注册
        tableViewManager.register(YYDefaultCell.self)
        /// 当只有一个section时，可在这操作 cell 点击
        tableViewManager.selectCellHandler = { item in
        }
        /// 设置cell 高度，当高度一样时
        tableViewManager.defaultTableViewCellHeight = 50
        
        /// 创建数据，添加 cell
        for index in 0...30 {
            let item = YYTableViewItem("YYDefaultCell")
            tableViewManager.section.add(item: item, false)
            
            /// 可单独为cell设置高度
            if index == 5 {
                item.cellHeight = 100
            }
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    cell.backgroundColor = .lightGray
                    cell.textLabel?.text = "第" + "\(index)" + "行"
                }
            }
            
            /// 也可在这里操作 cell 点击
            item.setSelectCellHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    print(cell)
                }
            }
        }
        
        tableViewManager.reload()
    }

}
