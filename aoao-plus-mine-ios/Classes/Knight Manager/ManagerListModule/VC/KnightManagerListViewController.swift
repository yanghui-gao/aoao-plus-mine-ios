//
//  KnightManagerListViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit
import aoao_plus_common_ios
import RxSwift
import DZNEmptyDataSet

class KnightManagerListViewController: AAViewController {
	/// tableView
	@IBOutlet weak var listTableView: UITableView!
	/// 工作状态
	var workStatueType:UserWorkState = .onlion
	
	/// 数据源
	var knightList:[KnightManagerModel] = []
	
	///
	var knightManagerViewModel:KnightManagerViewModel?
	
	/// 离岗序列
	let dismissionObservable = PublishSubject<(knightid: String, workState: UserWorkState)>()
	
	/// 骑手列表获取成功回调
	var knightListObservable = PublishSubject<(workType: UserWorkState, page: Int)>()
	
	var page = 1
	
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.knightListObservable.onNext((workType: self.workStatueType, page: 1))
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
		
		let Input = KnightManagerViewModel.Input.init(getShopKnightListObservable: self.knightListObservable, dismissionObservable: self.dismissionObservable)
		
		self.knightManagerViewModel = KnightManagerViewModel.init(input: Input)

		/// 下拉刷新
		self.knightManagerViewModel?.refreshBind(to: self.listTableView, headerHandle: {
			self.knightListObservable.onNext((workType: self.workStatueType, page: 1))
		}, footerHandle: {
			self.page += 1
			self.knightListObservable.onNext((workType: self.workStatueType, page: self.page))
		}).disposed(by: self.disposeBag)
		
		/// 订单请求回调
		self.knightManagerViewModel?.outPutKnightListObservable
			.subscribe(onNext: { [unowned self] res in
				if res.isRrefresh {
					self.knightList = res.data
				} else {
					self.knightList += res.data
				}
				self.listTableView.reloadData()
		}).disposed(by: disposeBag)
		
		self.knightManagerViewModel?
			.outPutOrderMetaResultObservable
			.subscribe(onNext: { [unowned self] meta in
				self.knightManagerViewModel?.refreshStatusManage.onNext(.endFooterRefresh)
				self.knightManagerViewModel?.refreshStatusManage.onNext(.endHeaderRefresh)
				// 处理是否还有更多数据
				let hasMore = meta["has_more"].boolValue
				// 请求成功 page 变化
				self.page = meta["page"].intValue
				//
				self.knightManagerViewModel?.refreshStatusManage.onNext(.footerStatus(isHidden: false, isNoMoreData: !hasMore))
			}).disposed(by: disposeBag)
		
		/// 错误回调
		self.knightManagerViewModel?
			.outPutErrorObservable
			.subscribe(onNext: { error in
				self.navigationController?.view.makeToast(error.zhMessage)
				self.navigationController?.view.dissmissLoadingView()
			}).disposed(by: disposeBag)
		
		// 离岗操作
		self.dismissionObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		/// 离岗回调
		self.knightManagerViewModel?
			.dismissionResultObservable
			.subscribe(onNext: { res in
				self.navigationController?.view.dissmissLoadingView()
				// 重新获取列表
				self.knightListObservable.onNext((workType: self.workStatueType, page: 1))
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
			let alert = UIAlertController(title: "提示", message: "确认将该骑手变为离岗状态?", preferredStyle: .alert)
			let confim = UIAlertAction(title: "确认", style: .default, handler: { action in
				/// 调用离岗
				self.dismissionObservable.onNext((knightid: model.id, workState: .offline))
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
		// 如果是自己的信息 相当于点击mine
		"knight".openURL(para: ["accountID": model.id, "type": KnightInfoPushType.knightManager])
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
	public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
		return true
	}
}
