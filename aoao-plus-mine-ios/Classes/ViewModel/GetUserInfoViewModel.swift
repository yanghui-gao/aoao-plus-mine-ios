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
	typealias ParaType = (detectionDate: String, detectionOverdue: String, inoculate: String, detectionImageKey: String, inoculateImageKey: String)
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<UserInfoModel>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		input.getUserInfoContent.flatMapLatest{ accountID -> Single<Result<UserInfoModel, AAErrorModel>> in
			/// 用户信息
			let request = MultiTarget(UpLoadVaccineContentAPI.getKnightContent(accountID: accountID))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapObject(objectType: UserInfoModel.self)
		}.subscribe(onNext: { res in
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
		/// 获取序列
		let getUserInfoContent: Observable<String>
	}
}
