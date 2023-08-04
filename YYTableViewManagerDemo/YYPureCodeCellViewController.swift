//
//  YYPureCodeCellViewController.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/2.
//

import UIKit

class YYPureCodeCellViewController: UIViewController {

    private var tableViewManager: YYTableViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.title = "纯代码自定义cell"
        
        let tableView = YYBaseTableView(frame: CGRect(x: 0, y: gTitleBarHeight, width: KScreenW, height: KScreenH - gTitleBarHeight - gSafeAreaInsets.bottom), style: .plain)
        self.view.addSubview(tableView)
        /// 当只有一个section时，最后一个属性设置为TRUE
        tableViewManager = YYTableViewManager(tableView: tableView, true)
        tableViewManager.register(YYPureCodeCell.self)
        tableViewManager.defaultTableViewCellHeight = 50
        
        for _ in 0...30 {
            let item = YYTableViewItem("YYPureCodeCell")
            tableViewManager.section.add(item: item, false)
            item.setCellWillDisplayHandler { callBackItem in
                if let cell = callBackItem.cell as? YYPureCodeCell {
                    cell.backgroundColor = .lightGray
                }
            }
        }
        
        tableViewManager.reload()
    }

}

class YYPureCodeCell: UITableViewCell, YYInternalCellProtocol {
    
    var nameLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        
        nameLable = UILabel()
        nameLable.font = UIFont.systemFont(ofSize: 15)
        nameLable.textColor = .black
        nameLable.text = "未知用户"
        nameLable.frame = CGRect(x: 10, y: 0, width: 100, height: 50)
        contentView.addSubview(nameLable)
    }
}
