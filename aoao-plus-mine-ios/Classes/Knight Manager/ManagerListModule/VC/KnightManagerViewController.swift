//
//  KnightManagerViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit
import XLPagerTabStrip
import RxSwift
import aoao_plus_common_ios
import Tabman
import Pageboy


class KnightManagerViewController: TabmanViewController {
	private var viewControllers: [UIViewController] = []
	
	private var tmBarItemables: [TMBarItemable] = []
	
	let bar = TMBar.ButtonBar()
	
	let disposeBag = DisposeBag()
	
	public var customCommentRightBarButtonItem: UIBarButtonItem?{
		get{
			let addKnightButton = UIBarButtonItem.init(title: "添加骑手", style: .done, target: self, action: #selector(addKnightAction))
			addKnightButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .light)], for: .normal)
			addKnightButton.tintColor = UIColor(named: "Color_00AD66", in: AACommonMoudle.share.bundle, compatibleWith: nil)
			return addKnightButton
		}
	}
	
	public var customCommentLeftBarButtonItem: UIBarButtonItem?{
		get{
			let qhRightButton = UIBarButtonItem(image: UIImage(named: "popBack", in: AACommonMoudle.share.bundle, compatibleWith: nil), style: .done, target: self, action: #selector(popToBeforeViewController))
			qhRightButton.tintColor = UIColor(named: "navbackicon_06041D_8E8C96", in: AACommonMoudle.share.bundle, compatibleWith: nil)
			return qhRightButton
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUI()
		setTMBar()
	}
	/// 添加骑手方法
	@objc func addKnightAction() {
		"addKnight".openURL()
	}
	func setUI() {
		
		self.title = "骑手管理"

		let bgColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
		self.view.backgroundColor = bgColor
		
//		self.navigationItem.rightBarButtonItem = self.customCommentRightBarButtonItem
		self.navigationItem.leftBarButtonItem = customCommentLeftBarButtonItem
	}
	func setTMBar() {
		let tintColor = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .white
		let selectedTintColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .white
		
		let stroyboard = AAMineModule.share.mineStoryboard
		let vc_1 = stroyboard.instantiateViewController(withIdentifier: "KnightManagerListViewController") as! KnightManagerListViewController
		vc_1.workStatueType = .onlion
		
		let vc_2 = stroyboard.instantiateViewController(withIdentifier: "KnightManagerListViewController") as! KnightManagerListViewController
		vc_2.workStatueType = .offline
		
		viewControllers = [vc_1, vc_2]
		tmBarItemables = [TMBarItem(title: "在岗骑手"), TMBarItem(title: "离岗骑手")]
		self.dataSource = self
		// 超过边界表现
		bar.indicator.overscrollBehavior = .compress
		// 横线权重
		bar.indicator.weight = .custom(value: 2)
		bar.indicator.backgroundColor = selectedTintColor
		// 自动根据内容铺满
		bar.layout.contentMode = .fit
		// 设置选中颜色 默认颜色
		bar.buttons.customize { (button) in
			button.font = UIFont.systemFont(ofSize: 14)
			button.tintColor = tintColor
			button.selectedTintColor = selectedTintColor
		}
		
		// 过渡动画配置
		bar.layout.transitionStyle = .snap // Customize
		bar.backgroundView.style = .flat(color: UIColor.white)
		// 添加至指定view
		addBar(bar, dataSource: self, at: .top)
		
	}
	
	@objc func popToBeforeViewController(){
		self.view.endEditing(true)
		self.navigationController?.popViewController(animated: true)
	}
}

extension KnightManagerViewController: PageboyViewControllerDataSource, TMBarDataSource {

	func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
		return viewControllers.count
	}

	func viewController(for pageboyViewController: PageboyViewController,
						at index: PageboyViewController.PageIndex) -> UIViewController? {
		return viewControllers[index]
	}

	func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
		return nil
	}

	func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
		let item = tmBarItemables[index]
		return item
	}
}
