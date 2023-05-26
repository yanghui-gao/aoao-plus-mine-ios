//
//  StatisticsViewModel.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/30.
//

import UIKit
import Moya
import aoao_net_ios
import SwiftyJSON
import RxSwift
import aoao_common_ios

class StatisticsViewModel {
	
	let disposebag = DisposeBag()
	
	/// 骑手信息
	let outPutStatisticsDetailObservable = PublishSubject<StatisticsDetailModel>()
	/// 折线图回调
	let outPutStatisticsListObservable = PublishSubject<[StatisticsDetailModel]>()
	/// 店铺列表
	let outPutShopListObservable = PublishSubject<[ShopsContentModel]>()
	
	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	init(input: Input) {
		
		input.statisticsDetailObservable.flatMapLatest{ para -> Single<Result<StatisticsDetailModel, AAErrorModel>> in
            let request = MultiTarget(UpLoadVaccineContentAPI.getStatistics(courierid: para.courierid, storeID: para.storeID, date: para.date))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapObject(objectType: StatisticsDetailModel.self)
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutStatisticsDetailObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		/// 折线图
		input.statisticsListObservable.flatMapLatest{ para -> Single<Result<[StatisticsDetailModel], AAErrorModel>> in
            let request = MultiTarget(UpLoadVaccineContentAPI.getStatisticsList(courierid: para.courierid, storeID: para.storeID, fromDate: para.fromDate, toDate: para.toDate))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapArray(dataType: StatisticsDetailModel.self)
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.outPutStatisticsListObservable.onNext(list)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		/// 获取店铺列表
		input.getshopListObservable.flatMapLatest{ id -> Single<Result<[ShopsContentModel], AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.getShopList(accountID: id))
			return aoaoAPIProvider.rx.aoaoRequest(request).mapArray(dataType: ShopsContentModel.self)
			
		}.subscribe(onNext: { res in
			switch res {
			case .success(let list):
				self.outPutShopListObservable.onNext(list)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
	}

}
extension StatisticsViewModel {
	struct Input {
		/// 获取骑手信息
        let statisticsDetailObservable: Observable<(courierid: String, storeID: String, date: String)>
		/// 获取骑手信息(折线图)
        let statisticsListObservable: Observable<(courierid: String, storeID: String, fromDate: String, toDate: String)>
		/// 获取店铺列表
		let getshopListObservable: Observable<String>
	}
}
