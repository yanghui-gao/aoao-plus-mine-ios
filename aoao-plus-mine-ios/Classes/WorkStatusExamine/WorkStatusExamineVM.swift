//
//  WorkStatusExamineVM.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/6/7.
//


import UIKit
import RxSwift
import aoao_plus_net_ios
import SwiftyJSON
import Moya
import aoao_plus_common_ios

class WorkStatusExamineVM {
	
	let disposebag = DisposeBag()
	
	// 获取骑手信息
	let outPutKnightUserInfoModelResultObservable = PublishSubject<KnightUserInfoModel>()
	
	let outPutErrorObservable = PublishSubject<AAErrorModel>()

	init(input: Input) {
		
		/// 获取骑手工作状态
		input.getKnightWorkInfoObservable
			.map{WorkStatusExamineAPI.getKnightWorkInfo(id: $0)}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.aoaoMapObject(objectType: KnightUserInfoModel.self)
			.subscribe(onNext: { res in
				switch res {
				case .success(let model):
					// 缓存
					UserModelManager.manager.setUserModel(userModel: model)
					self.outPutKnightUserInfoModelResultObservable.onNext(model)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}
	
}
extension WorkStatusExamineVM {
	struct Input {
		/// 获取骑手工作状态
		let getKnightWorkInfoObservable: Observable<(String)>
	}
}
