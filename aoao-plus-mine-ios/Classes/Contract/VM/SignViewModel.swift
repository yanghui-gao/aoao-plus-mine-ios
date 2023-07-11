//
//  SingleViewModel.swift
//  boss-plus-mine-ios
//
//  Created by 高炀辉 on 2023/5/29.
//

import UIKit
import RxSwift
import aoao_plus_net_ios
import Moya
import SwiftyJSON

class SignViewModel {
    // 错误
    let errorObservable = PublishSubject<AAErrorModel>()
    
    // 获取签约信息报错
    let singErrorObservable = PublishSubject<AAErrorModel>()
    
    // 签名信息
    let signInfoObservable = PublishSubject<JSON>()

    // 签名回调
    let signObservable = PublishSubject<JSON>()
    
    // disposebag
    let disposebag = DisposeBag()
    
    
    init(input: Input) {
        
        input.contractCreatObservable
			.map{ContractAPI.createContract}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON()
			.subscribe(onNext: { res in
				switch res{
				case .success(let json):
					self.signInfoObservable.onNext(json)
				case .failure(let error):
					self.errorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
		
		
		input.signObservable
			.map{ContractAPI.signContract(id: $0._id, signImg: $0.signBase64)}
			.map{MultiTarget($0)}
			.flatMapLatest{aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON()
			.subscribe(onNext: { res in
				switch res{
				case .success(let json):
					self.signObservable.onNext(json)
				case .failure(let error):
					self.singErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
    }
}

extension SignViewModel{
    struct Input {
        // 创建协议
        let contractCreatObservable: Observable<Void>
        
        // 合并签字内容并上传序列
        // 合同id 签名base64
        let signObservable: Observable<(_id:String, signBase64:String)>
    }
}
