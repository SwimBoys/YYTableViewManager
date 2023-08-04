//
//  YYXIBTableViewCell.swift
//  YYTableViewManagerDemo
//
//  Created by youyongpeng on 2023/8/2.
//

import UIKit

class YYXIBTableViewCell: UITableViewCell, YYInternalCellProtocol {

    @IBOutlet weak var titleLabel: UILabel!
    
    func cellWillAppear() {
        print("cellWillAppear")
        
        titleLabel.text = "这是标题"
    }
    
    func cellPrepared() {
        print("cellPrepared")
    }
    
    func cellDidDisappear() {
        print("cellDidDisappear")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
