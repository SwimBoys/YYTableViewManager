//
//  YYSectionsViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/2.
//

import UIKit

class YYSectionsViewController: UIViewController {
    
    private var tableViewManager: YYTableViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "多个section列表"
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        /// 当有多个 section 时，最后一个属性设置为FALSE
        tableViewManager = YYTableViewManager(tableView: tableView, false)
        
        tableViewManager.register(YYDefaultCell.self)
        tableViewManager.register(YYXIBTableViewCell.self)
        tableViewManager.register(YYPureCodeCell.self)
        
        /// 第一组
        let oneHeaderV = UIView()
        oneHeaderV.backgroundColor = .gray
        let oneHeaderTitle = UILabel()
        oneHeaderTitle.textColor = .black
        oneHeaderTitle.text = "第一组"
        oneHeaderTitle.frame = CGRect(x: 15, y: 0, width: 100, height: 50)
        oneHeaderV.addSubview(oneHeaderTitle)
        let oneFooterV = UIView()
        oneFooterV.backgroundColor = .gray
        let oneSection = YYTableViewSection(headerView: oneHeaderV, footerView: oneFooterV)
        oneSection.headerHeight = 50
        oneSection.footerHeight = 20
        tableViewManager.add(section: oneSection)
        for index in 0...5 {
            let item = YYTableViewItem("YYDefaultCell")
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYDefaultCell {
                    cell.backgroundColor = .lightGray
                    cell.textLabel?.text = "第" + "\(index)" + "行"
                }
            }
            /// 添加左滑，删除 cell
            item.setLeftSwipeActionsHandler(["删除"]) { callBackItem, actionIndex in
                oneSection.delete([callBackItem], complection: nil)
            }
            oneSection.add(item: item)
        }
        
        /// 第二组
        let twoHeaderV = UIView()
        twoHeaderV.backgroundColor = .green
        let twoHeaderTitle = UILabel()
        twoHeaderTitle.textColor = .black
        twoHeaderTitle.text = "第二组"
        twoHeaderTitle.frame = CGRect(x: 15, y: 0, width: 100, height: 50)
        twoHeaderV.addSubview(twoHeaderTitle)
        let twoFooterV = UIView()
        twoFooterV.backgroundColor = .green
        let twoSection = YYTableViewSection(headerView: twoHeaderV, footerView: twoFooterV)
        twoSection.headerHeight = 50
        twoSection.footerHeight = 20
        tableViewManager.add(section: twoSection)
        for _ in 0...5 {
            let item = YYTableViewItem("YYXIBTableViewCell")
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYXIBTableViewCell {
                    cell.backgroundColor = .red
                }
            }
            /// 添加右滑，增加 cell
            item.setRightSwipeActionsHandler(["增加"], backgroundColorArr: [.systemGreen]) { callBackItem, actionIndex in
                let item1 = YYTableViewItem("YYXIBTableViewCell")
                twoSection.insert(item1, afterItem: callBackItem)
            }
            twoSection.add(item: item)
        }
        
        /// 第三组
        let threeHeaderV = UIView()
        threeHeaderV.backgroundColor = .purple
        let threeHeaderTitle = UILabel()
        threeHeaderTitle.textColor = .black
        threeHeaderTitle.text = "第三组"
        threeHeaderTitle.frame = CGRect(x: 15, y: 0, width: 100, height: 50)
        threeHeaderV.addSubview(threeHeaderTitle)
        let threeFooterV = UIView()
        threeFooterV.backgroundColor = .purple
        let threeSection = YYTableViewSection(headerView: threeHeaderV, footerView: threeFooterV)
        threeSection.headerHeight = 50
        threeSection.footerHeight = 20
        tableViewManager.add(section: threeSection)
        for _ in 0...5 {
            let item = YYTableViewItem("YYPureCodeCell")
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYPureCodeCell {
                    cell.backgroundColor = .systemPink
                }
            }
            threeSection.add(item: item)
        }
        
        
        tableViewManager.reload()
    }

}
