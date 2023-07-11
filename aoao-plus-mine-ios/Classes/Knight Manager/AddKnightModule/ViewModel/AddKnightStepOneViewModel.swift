//
//  AddKnightStepOneViewModel.swift
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

class AddKnightStepOneViewModel {
	
	let errorObservable = PublishSubject<AAErrorModel>()
	
	let addKnightResultObservable = PublishSubject<CheckKnightModel>()

	let disposeBag = DisposeBag()

	init(input: Input) {
		input.textFieldObservabel.flatMapLatest { para -> Single<Result<CheckKnightModel, AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.checkKnightContent(name: para.name, phone: para.phoneNumber, idCardNum: para.idCardNumber))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapObject(objectType: CheckKnightModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.addKnightResultObservable.onNext(model)
			case .failure(let error):
				self.errorObservable.onNext(error)
			}
		}).disposed(by: disposeBag)
	}
}
extension AddKnightStepOneViewModel{
	struct Input {
		let textFieldObservabel: Observable<(name: String, idCardNumber: String, phoneNumber: String)>
	}
}
