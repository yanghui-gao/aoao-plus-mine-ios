//
//  KnightManagerViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit
import RxSwift
import aoao_plus_net_ios
import SwiftyJSON
import Moya
import aoao_plus_common_ios

public class KnightManagerViewModel {
	
	let disposebag = DisposeBag()
	
	/// 获取店铺列表
	let outPutShopListResultObservable = PublishSubject<[ShopsContentModel]>()
	
	/// 获取当前店铺骑手列表
	let outPutCurrentShopKnightListObservable = PublishSubject<[KnightManagerModel]>()
	
	/// 处理获取店铺列表错误得情况
	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	/// 处理获取店铺骑手列表错误情况
	let outPutCurrentShopKnightErrorObservable = PublishSubject<AAErrorModel>()

	init(input: Input) {
		/*
		获取信息
		*/
		input.getShopListObservable.flatMapLatest { userid -> Single<Result<[ShopsContentModel], AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.getShopList(accountID: userid))
			return aoaoAPIProvider.rx.aoaoRequest(request).aoaoMapArray(dataType: ShopsContentModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let healthContent):
				let modeList = healthContent.filter{$0.role == 20}
				self.outPutShopListResultObservable.onNext(modeList)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		// 获取当前店铺骑手
		input.getShopKnightListObservable.flatMapLatest { storeID -> Single<Result<[KnightManagerModel], AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.getCurrentStoreKnightList(storeID: storeID))
			return aoaoAPIProvider.rx.aoaoRequest(request).aoaoMapArray(dataType: KnightManagerModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.outPutCurrentShopKnightListObservable.onNext(list)
			case .failure(let error):
				self.outPutCurrentShopKnightErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
	}
}
extension KnightManagerViewModel {
	struct Input {
		/// 获取店铺列表
		let getShopListObservable: Observable<String>
		/// 获取对应店铺骑手列表
		let getShopKnightListObservable: Observable<String>
	}
}
