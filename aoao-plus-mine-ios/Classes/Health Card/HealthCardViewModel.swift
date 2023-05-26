//
//  HealthCardViewModel.swift
//  boss-mine-ios
//
//  Created by 高炀辉 on 2020/9/3.
//

import UIKit
import Moya
import aoao_net_ios
import SwiftyJSON
import RxSwift
import aoao_common_ios

class HealthCardViewModel {

    let disposebag = DisposeBag()

    let outPutResultObservable = PublishSubject<JSON>()
    
    let outPutHealthCardResultObservable = PublishSubject<HealthContentModel>()

    let outPutErrorObservable = PublishSubject<AAErrorModel>()
    
    private var imageKeysArr:[String] = []
    
    private var commitPara:Para?
    
    private var healthCertificate:String?
    
    private var healthCertificateBack:String?

	typealias Para = (healthCertificate: UIImage?, healthCertificateBack: UIImage?, healthCertificateStart: Int, healthCertificateEnd: Int, userid: String)
    
    typealias CommitPara = (healthCertificate: String?, healthCertificateBack: String?, healthCertificateStart: Int, healthCertificateEnd: Int, userid: String)

    private let commitObservable = PublishSubject<Void>()
    
    init(input: Input) {
        /*
         获取信息
         */
        
        input.getHealthCardObservable.flatMapLatest { userid -> Single<Result<HealthContentModel, AAErrorModel>> in
            let request = MultiTarget(HealthAPI.getHealthCard(userID: userid))
            return aoaoAPIProvider.rx.aoaoRequest(request).aoaoMapObject(objectType: HealthContentModel.self)
        }.subscribe(onNext: { res in
            switch res {
            case .success(let healthContent):
                self.outPutHealthCardResultObservable.onNext(healthContent)
            case .failure(let error):
                self.outPutErrorObservable.onNext(error)
            }
        }).disposed(by: disposebag)
        
        /// 提交序列
        input.commitObservable.flatMapLatest{ para -> Observable<Result<[String], AAErrorModel>> in
            self.commitPara = para
            if let healthCertificate = para.healthCertificate, let healthCertificateBack = para.healthCertificateBack {
                return aoaoAPIProvider.rx.QHUploadImageArr(images: [healthCertificate, healthCertificateBack], domain: "health").flatMapLatest{ list in
                    return Observable.just(Result.success(list))
                }
            }
            return Observable.just(Result.failure(AAErrorModel.init(zhMessage: "上传失败, 请稍后再试")))
        }.subscribe(onNext: { res in
            switch res {
            case .success(let keys):
                if keys.count == 2{
                    self.healthCertificate = keys[0]
                    self.healthCertificateBack = keys[1]
                    self.commitObservable.onNext(())
                }
                
            case .failure(let error):
                self.outPutErrorObservable.onNext(error)
            }
        }).disposed(by: disposebag)
        
        self.commitObservable.flatMapLatest{ [unowned self] _ -> Single<Result<JSON, AAErrorModel>> in
            let request = MultiTarget(HealthAPI.saveHealthCard(healthCertificate: self.healthCertificate ?? "", healthCertificateBack: self.healthCertificateBack ?? "", healthCertificateStart: self.commitPara?.healthCertificateStart ?? 0, healthCertificateEnd: self.commitPara?.healthCertificateEnd ?? 0, userid: self.commitPara?.userid ?? ""))
            return aoaoAPIProvider.rx.aoaoRequest(request).mapSwiftJSON()
        }.subscribe(onNext: { res in
            switch res {
            case .success(let json):
                self.outPutResultObservable.onNext(json)
            case .failure(let error):
                self.outPutErrorObservable.onNext(error)
            }
        }).disposed(by: disposebag)
        
        self.outPutResultObservable.flatMapLatest{ _ -> Single<Result<UserInfoModel, AAErrorModel>> in
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
extension HealthCardViewModel {
    struct Input {
        let commitObservable: Observable<Para>
        let getHealthCardObservable: Observable<String>
    }
}
