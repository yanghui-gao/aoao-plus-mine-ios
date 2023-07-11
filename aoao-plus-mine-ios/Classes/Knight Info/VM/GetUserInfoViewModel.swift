//
//  GetUserInfoViewModel.swift
//  aoao-login-ios
//
//  Created by 高炀辉 on 2021/3/16.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class GetUserInfoViewModel {
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<KnightDetailInfoModel>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		input.getUserInfoContent
			.map{KnightInfoAPI.getKnightContent(accountID: $0)}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapObject(objectType: KnightDetailInfoModel.self)
			.subscribe(onNext: { res in
				switch res {
				case .success(let model):
					self.outPutResultObservable.onNext(model)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}

}
extension GetUserInfoViewModel {
	struct Input {
		/// 获取骑手信息序列
		let getUserInfoContent: Observable<String>
	}
}
