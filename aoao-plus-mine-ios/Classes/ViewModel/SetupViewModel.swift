//
//  SetupViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/15.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class SetupViewModel {
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<JSON>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		input.getVersionObservable.flatMapLatest{ accessToken -> Single<Result<JSON, AAErrorModel>> in
            let request = MultiTarget(GetVersionAPI.getVersion)
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
extension SetupViewModel {
	struct Input {
		/// 获取版本号
		let getVersionObservable: Observable<Void>
	}
}
