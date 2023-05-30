//
//  ContractVM.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import UIKit
import RxSwift
import aoao_plus_net_ios
import Moya
import SwiftyJSON

class ContractVM {
	// 错误
	let errorObservable = PublishSubject<AAErrorModel>()
	
	// 合同信息
	let contractInfoObservable = PublishSubject<JSON>()
	
	// disposebag
	let disposebag = DisposeBag()
	
	
	init(input: Input) {
		
		input.getContractObservable
			.map{ContractAPI.getContract(knightID: $0)}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON()
			.subscribe(onNext: { res in
				switch res{
				case .success(let json):
					self.contractInfoObservable.onNext(json)
				case .failure(let error):
					self.errorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}
}

extension ContractVM{
	struct Input {
		// 获取协议内容序列
		let getContractObservable: Observable<String>
	}
}
