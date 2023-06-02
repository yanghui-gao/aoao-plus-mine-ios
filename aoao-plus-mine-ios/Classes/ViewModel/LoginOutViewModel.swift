//
//  LoginOutViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/25.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class LoginOutViewModel {
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<JSON>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		input.loginOutObservable.flatMapLatest{ accessToken -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.loginOut)
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
			
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
extension LoginOutViewModel {
	struct Input {
		/// 退出序列
		let loginOutObservable: Observable<String>
	}
}
