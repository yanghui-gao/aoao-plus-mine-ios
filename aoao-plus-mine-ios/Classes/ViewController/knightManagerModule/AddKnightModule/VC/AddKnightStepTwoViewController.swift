//
//  AddKnightStepTwoViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/8.
//

import UIKit
import aoao_common_ios
import RxSwift

/// 骑手信息编辑状态
enum KnightContentEditType: Int {
	// 创建
	case create = 10
	// 更新
	case update = 20
}
struct ChooseShopsModel {
	var name: String = ""
	var list: [ShopsContentModel] = []
}
class AddKnightStepTwoViewController: AAViewController {

	@IBOutlet weak var knightTableView: UITableView!
	
	var knightContentEditType:KnightContentEditType?
	
	var chooseShopViewModel:AddKnightStepTwoViewModel?
	
	let getLeaderShopListObservable = PublishSubject<String>()
	
	let getKnighthopListObservable = PublishSubject<String>()
	
	var knightaccountID: String?
	
	/// 未经排序的数据源
	var list:[ShopsContentModel] = []
	
	var dataSource:[ChooseShopsModel] = []{
		didSet{
			self.knightTableView.reloadData()
		}
	}
	
	var disposeBag = DisposeBag()
	
	let updateKnightObservable = PublishSubject<[ShopsContentModel]>()
	
	/// 创建骑手
	let createKnightObservable = PublishSubject<(name:String, mobile:String, idCardNum: String, shopList:[ShopsContentModel])>()
	
	var name: String?
	
	var mobile:String?
	 
	var idCardNum: String?
	
	@IBOutlet weak var commitButton: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		bindViewModel()
		setUI()
		
    }
	func setUI() {
		self.title = "添加骑手"
		
		let bgColor = UIColor(named: "bgcolor_F5F5F5_000000", in: AAMineModule.share.bundle, compatibleWith: nil)
		
		self.view.backgroundColor = bgColor
		
		/// 获取骑手店铺列表
		if let knightaccountID = self.knightaccountID, !knightaccountID.isEmpty {
			self.getKnighthopListObservable.onNext(knightaccountID)
		}
		/// 获取组长店铺列表
		if let accountID = UserModelManager.manager.userInfoModel?.id {
			self.getLeaderShopListObservable.onNext(accountID)
		}
		
		self.commitButton.alpha = 0.4
		self.commitButton.isEnabled = false
	}

	func bindViewModel() {
		let input = AddKnightStepTwoViewModel.Input.init(getLeaderShopListObservable: self.getLeaderShopListObservable,
														 getShopListObservable: self.getKnighthopListObservable,
														 createKnightObservable: self.createKnightObservable,
														 updateKnightObservable: self.updateKnightObservable, knightaccountID: self.knightaccountID)
		
		self.chooseShopViewModel = AddKnightStepTwoViewModel.init(input: input)
		
		self.createKnightObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		self.updateKnightObservable.subscribe(onNext: { _ in
			self.navigationController?.view.showLoadingMessage()
		}).disposed(by: disposeBag)
		
		
		
		/// 如果骑手未创建 监听改回调
		self.chooseShopViewModel?.addKnightLeaderResultObservable.subscribe(onNext: { [unowned self] list in
			guard let type = self.knightContentEditType else {
				return
			}
			if type == .update {
				return
			}
			self.list = list
			/// 去除相同商户号的数据源
			let merchantList = list.filterDuplicates{$0.merchantId}
			
			self.dataSource = merchantList.map({ merchantModel in
				// 初始化 ChooseShopsModel
				var chooseShopsModel = ChooseShopsModel()
				chooseShopsModel.name = merchantModel.merchantInfo.name
				if let model = list.first(where: {$0.merchantId == merchantModel.merchantId}){
					chooseShopsModel.list.append(model)
				}
				return chooseShopsModel
			})
		}).disposed(by: disposeBag)
		
		// 返回对应骑手添加的店铺列表
		self.chooseShopViewModel?.chooseShopListObservable.subscribe(onNext: { [unowned self] list in
			guard let type = self.knightContentEditType else {
				return
			}
			if type == .create {
				return
			}
			self.list = list
			let merchantList = list.filterDuplicates{$0.merchantId}
			
			self.dataSource = merchantList.map({ merchantModel in
				var chooseShopsModel = ChooseShopsModel()
				chooseShopsModel.name = merchantModel.merchantInfo.name
				_ = list.map({ model in
					if (model.merchantId == merchantModel.merchantId) {
						chooseShopsModel.list.append(model)
					}
				})
				return chooseShopsModel
			})
		}).disposed(by: disposeBag)
		
		self.commitButton.rx.tap.subscribe(onNext: { _ in
			guard let type = self.knightContentEditType else {
				return
			}
			guard let name = self.name else {
				return
			}
			
			guard let mobile = self.mobile else {
				return
			}
			guard let idCardNum = self.idCardNum else {
				return
			}
			if type == .create {
				// 调用创建骑手接口
				let selectList = self.list.filter{$0.isSelect == true}
				
				// 如果选中但未选择身份
				if selectList.filter({$0.knightWorkType == .none || $0.knightRoleType == .none}).count > 0 {
					self.view.makeToast("请填写完整")
					return
				}
				self.createKnightObservable.onNext((name: name, mobile: mobile, idCardNum: idCardNum, shopList: selectList))
			} else {
				// 调用编辑接口
				// 过滤未加入的列表
				let unJoinList = self.list.filter{$0.isJoin != true}
				let selectList = unJoinList.filter{$0.isSelect == true}
				// 如果选中但未选择身份
				if selectList.filter({$0.knightWorkType == .none || $0.knightRoleType == .none}).count > 0 {
					self.view.makeToast("请填写完整")
					return
				}
				self.updateKnightObservable.onNext(selectList)
			}
			
			
		}).disposed(by: disposeBag)
		
		
		self.chooseShopViewModel?.chooseShopResultObservable.subscribe(onNext: {[unowned self] _ in
			if let viewControllers = self.navigationController?.viewControllers {
				for vc in viewControllers {
					print(vc.theClassName)
					if vc.theClassName == "aoao_mine_ios.KnightManagerViewController" {
						
						self.navigationController?.popToViewController(vc, animated: true)
						
						return
					}
				}
			}
		}).disposed(by: disposeBag)
	}
}
extension AddKnightStepTwoViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSource.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource[section].list.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AddKnightChooseShopTableViewCell else {
			fatalError("Cell 初始化失败")
		}
		let model = self.dataSource[indexPath.section].list[indexPath.row]
		cell.roleHandle = { index in
			model.knightRoleType = index == 0 ? .knight : .knightLeader
			tableView.reloadData()
		}
		cell.workStatusHandle = { index in
			model.knightWorkType = index == 0 ? .fullTimeJob : .pluralJobs
			tableView.reloadData()
		}
		cell.model = model
		return cell
	}
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let cell = tableView.dequeueReusableCell(withIdentifier: "header") as? AddKnightChooseShopHeaderTableViewCell
		let model = self.dataSource[section]
		cell?.shopNameLabel.text = model.name
		return cell
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 34
	}
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.01
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let model = self.dataSource[indexPath.section].list[indexPath.row]
		if model.isJoin {
			return
		}
		model.isSelect = !model.isSelect
		
		let unJoinList = list.filter{!$0.isJoin}
		// 是否选中
		let isSelect = unJoinList.filter{$0.isSelect}.count > 0
		self.commitButton.alpha = isSelect ? 1 : 0.4
		self.commitButton.isEnabled = isSelect
		tableView.reloadData()
	}
}
