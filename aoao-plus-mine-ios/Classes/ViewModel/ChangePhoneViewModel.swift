//
//  ChangePhoneViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/7.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class ChangePhoneViewModel {
	
	let disposebag = DisposeBag()
	// 获取验证码回调
	let outPutResultObservable = PublishSubject<JSON>()
	// 错误回调
	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		/// 修改手机号 -> 获取验证码
		input.getCodeObservable
			.map{UpLoadVaccineContentAPI.getCode(phone: $0.phone, event: $0.event)}
			.map{MultiTarget($0)}
			.flatMapLatest{ aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON()
			.subscribe(onNext: { res in
				switch res {
				case .success(let json):
					self.outPutResultObservable.onNext(json)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}

}
extension ChangePhoneViewModel {
	struct Input {
		/// 获取验证码
		let getCodeObservable: Observable<(phone: String, event: InputCodeType)>
	}
}
