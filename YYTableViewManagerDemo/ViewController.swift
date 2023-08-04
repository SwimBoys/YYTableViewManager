//
//  ViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/1.
//

import UIKit

let KDeviceIsIPad = UIDevice.current.userInterfaceIdiom == .pad
/// 状态栏高度
var gStatusBarHeight : CGFloat { get { return gSafeAreaInsets.top } }
/// navigationBar的高度 (不包括状态栏)
var gNavigationBarHeight : CGFloat = KDeviceIsIPad ? 50 : 44
/// 上navigationBar的高度 (包括状态栏)
var gTitleBarHeight : CGFloat { get { return gSafeAreaInsets.top + gNavigationBarHeight } }

class ViewController: UIViewController {
    
    private var tableViewManager: YYTableViewManager!
    private let titleArr = ["默认cell", "XIB自定义cell", "纯代码自定义cell", "多个section列表", "添加上拉和下拉刷新"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fpsLabel = YYFPSLabel()
        let keyWindow = UIApplication.shared.keyWindow!
        let x = KScreenW - fpsLabel.frame.width - 4
        let y = gTitleBarHeight + 60
        fpsLabel.frame = CGRect(x: x, y: y, width: fpsLabel.frame.width, height: fpsLabel.frame.height)
        keyWindow.addSubview(fpsLabel)
        
        view.backgroundColor = .white
        self.title = "列表"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        tableViewManager = YYTableViewManager(tableView: tableView, true)
        tableViewManager.register(YYDefaultCell.self)
        
        tableViewManager.selectCellHandler = { [weak self] item in
            guard let this = self else {return}
            if item.indexPath.row == 0 {
                this.navigationController?.pushViewController(YYDefaultCellViewController(), animated: true)
            } else if item.indexPath.row == 1 {
                this.navigationController?.pushViewController(YYXIBCellViewController(), animated: true)
            } else if item.indexPath.row == 2 {
                this.navigationController?.pushViewController(YYPureCodeCellViewController(), animated: true)
            } else if item.indexPath.row == 3 {
                this.navigationController?.pushViewController(YYSectionsViewController(), animated: true)
            } else if item.indexPath.row == 4 {
                this.navigationController?.pushViewController(YYRefreshViewController(), animated: true)
            }
        }
        
        for title in titleArr {
            let item = YYTableViewItem("YYDefaultCell")
            tableViewManager.section.add(item: item, false)
            item.cellHeight = 50
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    cell.textLabel?.text = title
                    cell.backgroundColor = .gray
                }
            }
        }
        
        tableViewManager.reload()
    }
    


}

