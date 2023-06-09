//
//  KnightManagerViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/6/7.
//

import UIKit
import RxSwift
import aoao_plus_net_ios
import SwiftyJSON
import Moya
import aoao_plus_common_ios

class KnightManagerViewModel: RefreshProtocol {
	
	let disposebag = DisposeBag()
	
	var refreshStatusManage = PublishSubject<RefreshStatus>()
	/// 离岗回调
	let dismissionResultObservable = PublishSubject<JSON>()
	
	/// 获取当前状态骑手列表
	let outPutKnightListObservable = PublishSubject<(data: [KnightManagerModel], isRrefresh: Bool)>()
	/// 额外参数
	let outPutOrderMetaResultObservable = PublishSubject<JSON>()
	
	/// 处理获取店铺骑手列表错误情况
	let outPutErrorObservable = PublishSubject<AAErrorModel>()

	init(input: Input) {
		// 获取骑手列表
		input.getShopKnightListObservable
			.map{KnightManagerAPI.getKnightList(workType: $0.workType, page: $0.page)}
			.map{MultiTarget($0)}
			.flatMapLatest {aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapArrayAndMeta(dataType: KnightManagerModel.self)
			.subscribe(onNext: { res in
				switch res {
				case .success(let result):
					let isrefresh = result.meta["page"].intValue == 1
					self.outPutKnightListObservable.onNext((data: result.data, isRrefresh: isrefresh))
					self.outPutOrderMetaResultObservable.onNext(result.meta)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
		
		
		input.dismissionObservable
			.map{KnightManagerAPI.dissmission(knightid: $0.knightid, workState: $0.workState)}
			.map{MultiTarget($0)}
			.flatMapLatest {aoaoAPIProvider.rx.aoaoRequestToObservable($0)}
			.mapSwiftJSON()
			.subscribe(onNext: { res in
				switch res {
				case .success(let result):
					self.dismissionResultObservable.onNext(result)
				case .failure(let error):
					self.outPutErrorObservable.onNext(error)
				}
			}).disposed(by: disposebag)
	}
}
extension KnightManagerViewModel {
	struct Input {
		/// 获取骑手列表
		let getShopKnightListObservable: Observable<(workType: UserWorkState, page: Int)>
		/// 离岗序列
		let dismissionObservable: Observable<(knightid: String, workState: UserWorkState)>
	}
}
