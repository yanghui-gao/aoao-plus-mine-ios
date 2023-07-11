//
//  SetPassWordViewModel.swift
//  aoao-plus-order-ios
//
//  Created by 高炀辉 on 2023/6/2.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class SetPassWordViewModel {
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<JSON>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	let outPutButtonIsEnableObservable = PublishSubject<Bool>()
	
	init(input: Input) {
		//
		Observable.combineLatest(input.oldPassWordObservable, input.newPassWordObservable, input.confimPassWordObservable){!$0.isEmpty && !$1.isEmpty && !$2.isEmpty}
			.subscribe(onNext: { isok in
				self.outPutButtonIsEnableObservable.onNext(isok)
		}).disposed(by: disposebag)
		
		input.setPassWordObservable
			.map{UpLoadVaccineContentAPI.setNewPassWord(oldPassword: $0.oldpassword, password: $0.newpassword)}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON().subscribe(onNext: { res in
				switch res {
				case .success(let model):
					self.outPutResultObservable.onNext(model)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}

}
extension SetPassWordViewModel {
	struct Input {
		
		let oldPassWordObservable: Observable<String>
		let newPassWordObservable: Observable<String>
		let confimPassWordObservable: Observable<String>
		/// 设置密码
		let setPassWordObservable: Observable<(oldpassword: String?, newpassword: String)>
	}
}
