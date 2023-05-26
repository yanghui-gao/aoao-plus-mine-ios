//
//  UpLoadVaccineContentViewModel.swift
//  flashman
//
//  Created by 高炀辉 on 2021/1/25.
//  Copyright © 2021 white. All rights reserved.
//

import UIKit
import Moya
import aoao_net_ios
import SwiftyJSON
import RxSwift
import aoao_common_ios

class UpLoadVaccineContentViewModel {
	typealias ParaType = (detectionDate: String, detectionOverdue: String, inoculate: String, detectionImageKey: String, inoculateImageKey: String)
	
	let disposebag = DisposeBag()

	let outPutResultObservable = PublishSubject<JSON>()
	
	let outPutUpLoadVaccineContentObservable = PublishSubject<UpLoadVaccineContentModel>()

	let outPutErrorObservable = PublishSubject<AAErrorModel>()
	
	var para: ParaType?
	
	init(input: Input) {
		/// 获取详情
		input.getUpLoadVaccineContent.flatMapLatest { vaccinationId -> Single<Result<UpLoadVaccineContentModel, AAErrorModel>> in
			let request = MultiTarget(UpLoadVaccineContentAPI.getVaccineContent(vaccinationId: vaccinationId))
			return aoaoAPIProvider.rx.aoaoRequest(request).aoaoMapObject(objectType: UpLoadVaccineContentModel.self)
		}.subscribe(onNext: { res in
			switch res {
			case .success(let model):
				self.outPutUpLoadVaccineContentObservable.onNext(model)
			case .failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
		input.commitObservable.flatMapLatest{ para -> Observable<Result<JSON, AAErrorModel>> in
			guard let para = para else {
				return Observable.just(Result.failure(AAErrorModel.init(zhMessage: "上传失败, 请稍后再试")))
			}
			guard let healthCertificate = para.detectionImage, let healthCertificateBack = para.inoculateImage else {
                if para.isUpdate {
                    let request = MultiTarget(UpLoadVaccineContentAPI.upDateVaccineContent(vaccinationId: para.vaccinationId ?? "", vaccinationDate: para.inoculate, testingDate: para.detectionDate, testingExpireDate: para.detectionOverdue, testingAssetKey: nil, vaccinationAssetKey: nil))
                    return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON().asObservable()
                } else {
                    let request = MultiTarget(UpLoadVaccineContentAPI.upLoadVaccineContent(courierId: para.courierId, vaccinationDate: para.inoculate, testingDate: para.detectionDate, testingExpireDate: para.detectionOverdue, testingAssetKey: nil, vaccinationAssetKey: nil))
                    return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON().asObservable()
                }
			}
			return aoaoAPIProvider.rx.QHUploadImageArr(images: [healthCertificate, healthCertificateBack], domain: "accout").flatMapLatest { keys -> Single<Result<JSON, AAErrorModel>> in
                if keys.count <= 1 {
                    return Single.just(Result.failure(AAErrorModel.init(zhMessage: "上传失败, 请稍后再试")))
                }
                if para.isUpdate {
                    let request = MultiTarget(UpLoadVaccineContentAPI.upDateVaccineContent(vaccinationId: para.vaccinationId ?? "", vaccinationDate: para.inoculate, testingDate: para.detectionDate, testingExpireDate: para.detectionOverdue, testingAssetKey: keys[0], vaccinationAssetKey: keys[1]))
                    return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
                } else {
                    
                    let request = MultiTarget(UpLoadVaccineContentAPI.upLoadVaccineContent(courierId: para.courierId, vaccinationDate: para.inoculate, testingDate: para.detectionDate, testingExpireDate: para.detectionOverdue, testingAssetKey: keys[0], vaccinationAssetKey: keys[1]))
                    return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
                }
			}
		}.subscribe(onNext: { res in
			switch res {
			case .success(let json):
				self.outPutResultObservable.onNext(json)
			case.failure(let error):
				self.outPutErrorObservable.onNext(error)
			}
		}).disposed(by: disposebag)
		
        
        self.outPutResultObservable.flatMapLatest{ json -> Single<Result<UserInfoModel, AAErrorModel>> in
            /// 用户信息
            if let id = UserModelManager.manager.rootknightModel?.accountId {
                let request = MultiTarget(UpLoadVaccineContentAPI.getKnightContent(accountID: id))
                return aoaoAPIProvider.rx.aoaoRequest(request).mapObject(objectType: UserInfoModel.self)
            } else {
                return Single.just(Result.failure(AAErrorModel.init(zhMessage: "刷新用户信息失败")))
            }
        }.subscribe(onNext: { res in
            switch res {
            case .success(let usermodel):
                UserModelManager.manager.setUserModel(userModel: usermodel)
            case .failure(let error):
                self.outPutErrorObservable.onNext(error)
            }
        }).disposed(by: disposebag)
	}

}
extension UpLoadVaccineContentViewModel {
	struct Input {
		/// 提交序列
        let commitObservable: Observable<UpLoadVaccineContentViewController.ParaType?>
        
		/// 获取序列
		let getUpLoadVaccineContent: Observable<String>
	}
}
