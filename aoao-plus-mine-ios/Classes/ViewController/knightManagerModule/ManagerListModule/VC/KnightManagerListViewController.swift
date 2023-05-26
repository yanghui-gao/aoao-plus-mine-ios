//
//  KnightManagerListViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit
import XLPagerTabStrip
import aoao_plus_common_ios
import RxSwift
import DZNEmptyDataSet

class KnightManagerListViewController: AAViewController, IndicatorInfoProvider {
	
	
	func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
		switch self.workStatueType {
		case .activeWorker:
			return IndicatorInfo(title: "在岗骑手")
		case .dimission:
			return IndicatorInfo(title: "离岗骑手")
		default:
			return IndicatorInfo(title: "")
		}
	}
	

	/// tableView
	@IBOutlet weak var listTableView: UITableView!
	/// 工作状态
	var workStatueType:WorKState = .activeWorker
	
	/// 数据源
	var knightList:[KnightManagerModel] = []
	
	///
	var knightManagerListViewModel:KnightManagerListViewModel?
	
	/// 离岗序列
	let dismissionObservable = PublishSubject<(accountID: String, storeID: String, workState: WorKState)>()
	
	/// 店铺ID
	var storeID: String?
	
	let notificationName = Notification.Name(rawValue: "getKnightListNotification")
	
	/// 骑手列表获取成功回调
	var knightListResultObservable = PublishSubject<Void>()
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
	
	func setUI() {
		let bgColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
		self.view.backgroundColor = bgColor
		
		self.listTableView.layer.cornerRadius = 4
		self.listTableView.layer.masksToBounds = true
		
		self.listTableView.emptyDataSetSource = self
		
		self.listTableView.emptyDataSetDelegate = self
		
		self.listTableView.tableFooterView = UIView()
	}

	func bindViewModel() {
		
		let Input = KnightManagerListViewModel.Input.init(dismissionObservable: self.dismissionObservable)
		
		self.knightManagerListViewModel = KnightManagerListViewModel.init(input: Input)
		
		
		self.dismissionObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		/// 离岗回调
		self.knightManagerListViewModel?.addKnightResultObservable.subscribe(onNext: { res in
			self.navigationController?.view.dissmissLoadingView()
			/// 请求列表
			NotificationCenter.default.post(name: self.notificationName, object: self,userInfo: nil)
		}).disposed(by: disposeBag)
		
		/// 下拉刷新
		self.knightManagerListViewModel?.refreshBind(to: self.listTableView, headerHandle: {
			// 发送通知
			NotificationCenter.default.post(name: self.notificationName, object: self,userInfo: nil)
		}, footerHandle: nil).disposed(by: self.disposeBag)
		
		/// 订单请求回调
		self.knightListResultObservable.subscribe(onNext: { [unowned self] _ in
			self.knightManagerListViewModel?.refreshStatusManage.onNext(.endHeaderRefresh)
			self.listTableView.reloadData()
		}).disposed(by: disposeBag)
		
		/// 错误回调
		self.knightManagerListViewModel?.errorObservable.subscribe(onNext: { error in
			self.navigationController?.view.makeToast(error.zhMessage)
			self.navigationController?.view.dissmissLoadingView()
		}).disposed(by: disposeBag)
	}
}
extension KnightManagerListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return knightList.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? KnightManagerTableViewCell else {
			fatalError("Cell 初始化失败")
		}
		let model = self.knightList[indexPath.row]
		cell.model = model
		cell.dismissionButtonHandle = {
			guard let storeID = self.storeID else {
				return
			}
			let alert = UIAlertController(title: "提示", message: "确认将该骑手变为离岗状态?", preferredStyle: .alert)
			let confim = UIAlertAction(title: "确认", style: .default, handler: { action in
				/// 调用离岗
				self.dismissionObservable.onNext((accountID: model.courierId, storeID: storeID, workState: WorKState.dimission))
			})
			let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
			cancel.setValue(UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
			confim.setValue(UIColor(named: "color_19B675", in: AAMineModule.share.bundle, compatibleWith: nil), forKey:"titleTextColor")
			alert.addAction(confim)
			alert.addAction(cancel)
			self.navigationController?.present(alert, animated: true)
			
		}
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = self.knightList[indexPath.row]
		guard let shopID = self.storeID else {
			return
		}
		"knight".openURL(para: ["accountID": model.courierId, "shopID": shopID])
	}
}

extension KnightManagerListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
	public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
		return UIImage(named: "none", in: AAMineModule.share.bundle, compatibleWith: nil)
	}
	public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		let attributes = [
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
			NSAttributedString.Key.foregroundColor: UIColor(named: "boss_000000-40_FFFFFF-40", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .darkGray
		]
		return NSAttributedString(string: "暂无骑手", attributes: attributes)
	}
	func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
		let attributes = [
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0),
			NSAttributedString.Key.foregroundColor: UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil) ?? .darkGray
		]
		return NSAttributedString(string: "点击刷新", attributes: attributes)
	}
	func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
		/// 刷新列表
		NotificationCenter.default.post(name: self.notificationName, object: self,userInfo: nil)
	}
	public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
		return true
	}
}
