//
//  KnightManagerListViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/9.
//

import UIKit
import RxSwift
import aoao_net_ios
import SwiftyJSON
import aoao_common_ios
import Moya

class KnightManagerListViewModel: RefreshProtocol {
	
	let errorObservable = PublishSubject<AAErrorModel>()
	
	let addKnightResultObservable = PublishSubject<JSON>()
	
	var refreshStatusManage = PublishSubject<RefreshStatus>()

	let disposeBag = DisposeBag()

	init(input: Input) {
		input.dismissionObservable.flatMapLatest { para -> Single<Result<JSON, AAErrorModel>> in
			let request = MultiTarget(KnightManagerAPI.dissmission(accountID: para.accountID, storeID: para.storeID, workState: WorKState.dimission))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
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
extension KnightManagerListViewModel{
	struct Input {
		/// 离岗序列
		let dismissionObservable: Observable<(accountID: String, storeID: String, workState: WorKState)>
	}
}
