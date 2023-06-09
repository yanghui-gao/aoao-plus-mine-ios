//
//  AddKnightStepTwoViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/8.
//

import UIKit
import RxSwift
import aoao_plus_net_ios
import SwiftyJSON
import aoao_plus_common_ios
import Moya

typealias EditKnightShopPara = (storeID: String, merchantID: String, role: KnightRoleType, workType: KnightWorkType, courierid: String, opt: String)

class AddKnightStepTwoViewModel {
	
	let errorObservable = PublishSubject<AAErrorModel>()
	
	
	let addKnightLeaderResultObservable = PublishSubject<[ShopsContentModel]>()
	
	private let addKnightResultObservable = PublishSubject<[ShopsContentModel]>()
	
	let chooseShopListObservable = PublishSubject<[ShopsContentModel]>()
	
	let chooseShopResultObservable = PublishSubject<JSON>()

	let disposeBag = DisposeBag()

	init(input: Input) {
		/// 获取骑手组长店铺列表
		input.getLeaderShopListObservable.flatMapLatest { accountID -> Single<Result<[ShopsContentModel], AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.getShopList(accountID: accountID))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapArray(dataType: ShopsContentModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				let leaderList = list.filter{$0.role == 20}
				self.addKnightLeaderResultObservable.onNext(leaderList)
			case .failure(let error):
				self.errorObservable.onNext(error)
			}
		}).disposed(by: disposeBag)
		
		
		// 普通骑手
		input.getShopListObservable.flatMapLatest { accountID -> Single<Result<[ShopsContentModel], AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.getShopList(accountID: accountID))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapArray(dataType: ShopsContentModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.addKnightResultObservable.onNext(list)
			case .failure(let error):
				self.errorObservable.onNext(error)
			}
		}).disposed(by: disposeBag)
		
		/// 处理两个序列返回结果
		let observable = Observable.zip(self.addKnightLeaderResultObservable, self.addKnightResultObservable)
		
		observable.subscribe(onNext: { res in
			/// 如果骑手返回列表为空
			/// 代表骑手未加入任何门店直接返回
			if res.1.isEmpty {
				self.chooseShopListObservable.onNext(res.0)
			} else {
				// 取出相同的对象
				let leaderList = res.0
				let knightList = res.1
				for (index, model) in leaderList.enumerated() {
					leaderList[index].isSelect = knightList.contains(model)
					leaderList[index].isJoin = knightList.contains(model)
					/// 如果包含的话 则 处理 角色以及身份状态
					if knightList.contains(model) {
						if let knightModel = knightList.first(where: {$0.storeId == model.storeId}) {
							model.knightWorkType = knightModel.knightWorkType
							model.knightRoleType = knightModel.knightRoleType
						}
					} else {
						model.knightWorkType = .none
						model.knightRoleType = .none
					}
				}
				self.chooseShopListObservable.onNext(leaderList)
			}
		}).disposed(by: disposeBag)
		
		// 创建骑手
		input.createKnightObservable.flatMapLatest { para -> Single<Result<JSON, AAErrorModel>> in
			let paraList = para.shopList.map{ model in
				return (storeID: model.storeId ?? "", merchantID: model.merchantId ?? "", role: model.knightRoleType, workType: model.knightWorkType)
			}
			let request = MultiTarget(KnightManagerAPI.createKnight(name: para.name, mobile: para.mobile, idCardNum: para.idCardNum, courier_store_maps: paraList))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.chooseShopResultObservable.onNext(list)
			case .failure(let error):
				self.errorObservable.onNext(error)
			}
		}).disposed(by: disposeBag)
		
		// 编辑骑手店铺
		input.updateKnightObservable.flatMapLatest { para -> Single<Result<JSON, AAErrorModel>> in
			let paraList = para.map{ model in
				return (storeID: model.storeId ?? "", merchantID: model.merchantId ?? "", role: model.knightRoleType, workType: model.knightWorkType, courierid: input.knightaccountID ?? "", opt: "create")
			}
			let request = MultiTarget(KnightManagerAPI.editKnightShopList(courier_store_maps: paraList))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.chooseShopResultObservable.onNext(list)
			case .failure(let error):
				self.errorObservable.onNext(error)
			}
		}).disposed(by: disposeBag)
		
	}
}
extension AddKnightStepTwoViewModel{
	struct Input {
		/// 获取 组长管理店铺列表
		let getLeaderShopListObservable: Observable<(String)>
		
		/// 获取对应骑手的店铺列表
		let getShopListObservable: Observable<(String)>
		
		/// 创建骑手
		let createKnightObservable: Observable<(name:String, mobile:String, idCardNum: String, shopList:[ShopsContentModel])>
		
		/// 更新骑手的店铺列表
		let updateKnightObservable: Observable<[ShopsContentModel]>
		
		var knightaccountID: String?
	}
}
