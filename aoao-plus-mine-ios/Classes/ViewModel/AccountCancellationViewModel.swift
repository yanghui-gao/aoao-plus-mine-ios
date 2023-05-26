//
//  AccountCancellationViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2023/3/29.
//

import UIKit
import Moya
import aoao_plus_net_ios
import SwiftyJSON
import RxSwift
import aoao_plus_common_ios

class AccountCancellationViewModel {
	
	let disposebag = DisposeBag()

	// 账号注销内容回调
	let outPutAccountCancellationInfoObservable = PublishSubject<JSON>()
	
	// 发起账号注销回调
	let outPutCommitAccountCancellationObservable = PublishSubject<JSON>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		// 查询
		input.accountCancellationInfoObservable.flatMapLatest{ accessToken -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(AccountCancellationAPI.getAccountCancellationInfo)
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutAccountCancellationInfoObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		// 发起
		input.commitAccountCancellationObservable.flatMapLatest{ accessToken -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(AccountCancellationAPI.accountCancellation)
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutCommitAccountCancellationObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
	}

}
extension AccountCancellationViewModel {
	struct Input {
		let commitAccountCancellationObservable: Observable<Void>
		
		let accountCancellationInfoObservable: Observable<Void>
	}
}
