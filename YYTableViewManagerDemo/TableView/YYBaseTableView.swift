//
//  YYBaseTableView.swift
//  testDemo
//
//  Created by youyongpeng on 2023/4/3.
//

import UIKit

/// 加载数据类型
enum YYLoadDataStyle {
    /// 获取新数据
    case LoadNewData
    /// 获取更多数据
    case LoadMoreData
}

/// 列表数据刷新类型
enum YYDataRefreshStyle {
    /// 有上拉，有下拉
    case Normal
    /// 只有下拉，没上拉
    case DropDown
    /// 只有上拉，没有下拉
    case PullUp
}

/// 列表结果类型
enum YYTableViewResultStyle {
    /// 没有更多数据
    case NoMoreData
    /// 有更多数据
    case MoreData
    /// 数据为空
    case DataEmpty
    /// 请求失败
    case Fail
}

/// 列表刷新类型
enum YYTableViewRefreshStyle {
    /// 文本
    case Text
    /// 动图
    case Gif
    /// 微信
    case Wechat
}

open class YYBaseTableView: UITableView {
    
    private var refreshStyle: YYTableViewRefreshStyle = .Text
    private var headerRefreshView: ESRefreshHeaderView?
    private var footerRefreshView: ESRefreshFooterView?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadUI()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if style == .grouped {
            tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 0.01))
        }
        loadUI()
    }
    
    private func loadUI() {
        backgroundColor = .white
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        layoutMargins = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            estimatedRowHeight = 0;
            estimatedSectionFooterHeight = 0;
            estimatedSectionHeaderHeight = 0;
            contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
    var loadNewDataCallback : (()->())?
    var loadMoreDataCallback : (()->())?
    
    func setRefreshStyle(_ style: YYDataRefreshStyle, _ refreshStyle: YYTableViewRefreshStyle = .Text) {
        self.refreshStyle = refreshStyle
        if style == .Normal {
            addRefreshHeader()
            addRefreshFooter()
        } else if style == .DropDown {
            addRefreshHeader()
        } else if style == .PullUp {
            addRefreshFooter()
        }
    }
    
    private func addRefreshHeader() {
        var headerRefresh: ESRefreshProtocol & ESRefreshAnimatorProtocol = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        if refreshStyle == .Gif {
            var imageNames = [String]()
            for idx in 1 ... 8 {
                imageNames.append("icon_shake_animation_\(idx)")
            }
            var imageNames1 = [String]()
            for idx in 1 ... 5 {
                imageNames1.append("icon_pull_animation_\(idx)")
            }
            headerRefresh = GifRefreshHeaderAnimator.init(frame: .zero, gifBeginImageNameArr: imageNames1, gifStartImageNameArr: imageNames)
        } else if refreshStyle == .Wechat {
            headerRefresh = WXRefreshHeaderAnimator(frame: .zero, imageName: "icon_wechat")
            self.layoutIfNeeded()
        }
        headerRefreshView = self.es.addPullToRefresh(animator: headerRefresh) { [weak self] in
            guard let this = self else { return }
            this.contentInset.bottom = 0
            this.loadNewData()
        }
    }
    
    private func addRefreshFooter() {
        let footerRefresh: ESRefreshProtocol & ESRefreshAnimatorProtocol = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        footerRefreshView = self.es.addInfiniteScrolling(animator: footerRefresh) { [weak self] in
            guard let this = self else { return }
            this.loadMoreData()
        }
        footerRefreshView?.isHidden = true
    }
    
    private func loadNewData() {
        loadNewDataCallback?()
    }
    
    private func loadMoreData() {
        loadMoreDataCallback?()
    }
    
    func headerRefreshViewStart() {
        if headerRefreshView != nil {
            self.es.startPullToRefresh()
        }
    }
    
    func showFooterRefrsehView() {
        if footerRefreshView != nil {
            self.footerRefreshView?.isHidden = false
            self.footerRefreshView?.resetNoMoreData()
        }
    }
    
    func hideFooterRefrsehView(_ isReservedBottomSafetyDistance: Bool = false) {
        if footerRefreshView != nil {
            self.footerRefreshView?.isHidden = true
        }
        if isReservedBottomSafetyDistance {
            contentInset.bottom = gSafeAreaInsets.bottom
        }
    }
    
    func footerRefreshViewNoMoreData() {
        if footerRefreshView != nil {
            self.es.noticeNoMoreData()
        }
    }
    
    func EndRefrseh(_ status: YYTableViewResultStyle, _ isReservedBottomSafetyDistance: Bool = false, isShowNoMoreDataTitle: Bool = false) {
        if headerRefreshView != nil {
            self.es.stopPullToRefresh()
        }
        if footerRefreshView != nil {
            self.es.stopLoadingMore()
        }
        if status == .NoMoreData {
            if isShowNoMoreDataTitle {
                footerRefreshViewNoMoreData()
            } else {
                hideFooterRefrsehView(isReservedBottomSafetyDistance)
            }
        } else if status == .MoreData {
            showFooterRefrsehView()
        }
    }
}
