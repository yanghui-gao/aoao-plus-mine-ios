//
//  ChangePhoneViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/4/7.
//

import UIKit
import Moya
import aoao_net_ios
import SwiftyJSON
import RxSwift
import aoao_common_ios

class ChangePhoneViewModel {
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<JSON>()
	
	let outPutGetOldPhoneCodeObservable = PublishSubject<JSON>()
	
	let outPutGetNewPhoneCodeObservable = PublishSubject<JSON>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		/// 获取旧手机号验证码
		input.getOldPhoneCode?.flatMapLatest{ para -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.getCode(phone: para.phone, if_voice: para.if_voice, event: para.event))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutGetOldPhoneCodeObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		/// 获取新手机号验证码
		input.getNewPhoneCode?.flatMapLatest{ para -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.getCode(phone: para.phone, if_voice: para.if_voice, event: para.event))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutGetNewPhoneCodeObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		
		/// 验证手机号是否存在
		input.checkPhoneObservable?.flatMapLatest{ para -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.checkNewPhone(phone: para.phone, idCardNum: para.idCardNum))
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
extension ChangePhoneViewModel {
	struct Input {
		/// 获取旧手机号验证码
		let getOldPhoneCode: Observable<(phone: String, if_voice: Bool, event: String)>?
		/// 校验手机号是否被占用
		let checkPhoneObservable: Observable<(phone: String, idCardNum: String)>?
		/// 获取新手机号验证码
		let getNewPhoneCode: Observable<(phone: String, if_voice: Bool, event: String)>?
	}
}
