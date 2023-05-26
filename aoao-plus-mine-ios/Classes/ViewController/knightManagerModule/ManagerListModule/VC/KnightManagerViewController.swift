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


class KnightManagerViewController: ButtonBarPagerTabStripViewController {
	/// 选择门店Tap
	@IBOutlet var selectShopTap: UITapGestureRecognizer!

	/// 请求骑手列表序列
	var requestObservable = PublishSubject<String>()
	
	/// ViewModel
	var viewModel: KnightManagerViewModel?
	
	/// 获取门店列表
	let getShopListObservable = PublishSubject<String>()
	
	/// 骑手列表获取成功回调
	var knightListResultObservable = PublishSubject<Void>()
	
	/// 门店ID
	var shopID: String?
	
	var selectIndex:Int?
	
	var shopsContentModelList:[ShopsContentModel] = []
	
	/// 在岗骑手
	var workingKnightList:[KnightManagerModel] = []
	/// 离岗
	var unWorkingKnightList:[KnightManagerModel] = []
	
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
	
	@IBOutlet weak var shopNameLabel: UILabel!
	
	override func viewDidLoad() {
		self.settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
		self.settings.style.buttonBarItemTitleColor = UIColor.init(named: "color_2DCF90", in: AAMineModule.share.bundle, compatibleWith: nil)
		self.settings.style.selectedBarBackgroundColor = UIColor.init(named: "color_2DCF90", in: AAMineModule.share.bundle, compatibleWith: nil) ?? UIColor.white
		self.settings.style.buttonBarHeight = 40
		self.settings.style.buttonBarBackgroundColor = UIColor.init(named: "boss_FFFFFF_1A1A1A", in: AAMineModule.share.bundle, compatibleWith: nil)
		self.settings.style.buttonBarItemBackgroundColor = UIColor.init(named: "boss_FFFFFF_1A1A1A", in: AAMineModule.share.bundle, compatibleWith: nil)
		self.settings.style.selectedBarHeight = 2
		changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
			guard changeCurrentIndex == true else { return }
			oldCell?.label.textColor = UIColor.init(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
			newCell?.label.textColor = UIColor(named: "color_2DCF90", in: AAMineModule.share.bundle, compatibleWith: nil)
		}
		super.viewDidLoad()
		self.bindViewModel()
		setUI()
	}
	/// 添加骑手方法
	@objc func addKnightAction() {
		"addKnight".openURL()
	}
	func setUI() {
		
		self.title = "骑手管理"
		containerView.frame.origin.y = containerView.frame.origin.y + 49
		buttonBarView.frame.origin.y = buttonBarView.frame.origin.y + 49
		
		if let accountID = UserModelManager.manager.userInfoModel?.id {
			self.getShopListObservable.onNext(accountID)
		}
		
		let bgColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
		self.view.backgroundColor = bgColor
		
//		self.navigationItem.rightBarButtonItem = self.customCommentRightBarButtonItem
		self.navigationItem.leftBarButtonItem = customCommentLeftBarButtonItem
		
		let notificationName = Notification.Name(rawValue: "getKnightListNotification")
		NotificationCenter.default.addObserver(self,
											selector:#selector(getList),
											name: notificationName, object: nil)
	}
	/// 获取对应店铺下的骑手列表
	@objc func getList() {
		if let accountID = UserModelManager.manager.userInfoModel?.id {
			self.getShopListObservable.onNext(accountID)
		}
//		guard let shopID = self.shopID else {
//			return
//		}
//		self.requestObservable.onNext(shopID)
	}
	func bindViewModel() {
		self.selectShopTap.rx.event.subscribe(onNext: { [self] _ in
			if self.shopsContentModelList.isEmpty {
				return
			}
			/// 跳转
			let stroyboard = AACommonMoudle.share.storyboard
			let shopVc = stroyboard.instantiateViewController(withIdentifier: "SelectShopViewController") as! SelectShopViewController
			shopVc.modalPresentationStyle = .overCurrentContext
			
			shopVc.chooseKnightObservable.subscribe(onNext: { [unowned self] index in
				/// 如果
				if !self.shopsContentModelList.isEmpty {
					self.selectIndex = index
					self.shopID = shopsContentModelList[index].storeInfo?.id
					self.shopNameLabel.text = shopsContentModelList[index].storeInfo?.name
					shopsContentModelList[index].isSelect = true
					/// 选择店铺后刷新列表
					self.requestObservable.onNext(self.shopID ?? "")
				}
			}).disposed(by: self.disposeBag)
			/// 每次都回传
			shopVc.dateSource = self.shopsContentModelList
			shopVc.selectIndex = self.selectIndex ?? 0
			self.navigationController?.present(shopVc, animated: true, completion: {
				UIView.animate(withDuration: 0.5) {
					shopVc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
				}
			})
		}).disposed(by: self.disposeBag)
		
		self.requestObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		
		self.getShopListObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		
		let input = KnightManagerViewModel.Input.init(getShopListObservable: self.getShopListObservable, getShopKnightListObservable: self.requestObservable)
		self.viewModel = KnightManagerViewModel(input: input)
		
		/// 获取商铺列表
		self.viewModel?.outPutShopListResultObservable.subscribe(onNext: { list in
			self.navigationController?.view.dissmissLoadingView()
			if list.isEmpty {
				// 提示
				let alert = UIAlertController(title: "提示", message: "您不是组长身份", preferredStyle: .alert)
				
				alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { _ in
					self.navigationController?.popViewController(animated: true)
				}))
				self.navigationController?.present(alert, animated: true)
				
				return
			}
			if let shopID = self.shopID, let model = list.filter({shopID == $0.storeInfo.id}).first {
				self.shopNameLabel.text = model.storeInfo.name
				model.isSelect = true
				self.shopsContentModelList = list
				self.requestObservable.onNext(shopID)
				
			} else {
				self.shopID = list.first?.storeInfo.id
				self.shopNameLabel.text = list.first?.storeInfo.name
				list.first?.isSelect = true
				self.shopsContentModelList = list
				self.requestObservable.onNext(self.shopID ?? "")
			}
			
			
		}).disposed(by: disposeBag)
		
		self.viewModel?.outPutCurrentShopKnightListObservable.subscribe(onNext: { [unowned self] list in
			self.navigationController?.view.dissmissLoadingView()
			
			self.workingKnightList = list.filter{$0.knightWorkType == .working}
			
			self.unWorkingKnightList = list.filter{$0.knightWorkType == .unWorking}
			
			self.knightListResultObservable.onNext(())
			
			self.reloadPagerTabStripView()
			
		}).disposed(by: disposeBag)
		
		
		/// 处理获取骑手列表时错误的情况
		self.viewModel?.outPutCurrentShopKnightErrorObservable.subscribe(onNext: { error in
			self.navigationController?.view.dissmissLoadingView()
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
		/// 处理获取店铺列表错误的情况
		self.viewModel?.outPutErrorObservable.subscribe(onNext: { error in
			
			self.navigationController?.view.dissmissLoadingView()
			
			let alert = UIAlertController(title: "提示", message: "获取店铺信息失败, 请重试", preferredStyle: .alert)

			alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { _ in
				self.navigationController?.popViewController(animated: true)
			}))
			self.navigationController?.present(alert, animated: true)
		}).disposed(by: disposeBag)
	}
	@objc func popToBeforeViewController(){
		self.view.endEditing(true)
		self.navigationController?.popViewController(animated: true)
	}
	
	override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
		let stroyboard = AAMineModule.share.mineStoryboard
		let vc_1 = stroyboard.instantiateViewController(withIdentifier: "KnightManagerListViewController") as! KnightManagerListViewController
		vc_1.workStatueType = .activeWorker
		vc_1.knightList = self.workingKnightList
		vc_1.storeID = self.shopID
//		vc_1.knightListResultObservable = self.knightListResultObservable
		let vc_2 = stroyboard.instantiateViewController(withIdentifier: "KnightManagerListViewController") as! KnightManagerListViewController
		vc_2.workStatueType = .dimission
		vc_2.knightList = self.unWorkingKnightList
		vc_2.storeID = self.shopID
//		vc_2.knightListResultObservable = self.knightListResultObservable
		return [vc_1, vc_2]
	}
	
	override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool){
		super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
		if indexWasChanged {
			print(toIndex)
		}
	}
}

