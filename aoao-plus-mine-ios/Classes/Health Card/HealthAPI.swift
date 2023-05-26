//
//  MineAPI.swift
//  boss-mine-ios
//
//  Created by 高炀辉 on 2020/8/24.
//

import Foundation
import Moya
import aoao_net_ios
import RxSwift
import aoao_common_ios

enum HealthAPI {
    /// 保存健康证信息
    case saveHealthCard(healthCertificate: String,
						healthCertificateBack: String,
						healthCertificateStart: Int,
						healthCertificateEnd: Int,
						userid: String)
    /// 获取健康证信息
    case getHealthCard(userID: String)
}
extension HealthAPI: TargetType, AuthenticationProtocol {
    
    
    var method: Moya.Method {
        return .post
    }
    
    var baseURL: URL {
        guard let url = URL(string: basicURL) else {
            fatalError("非法的URL字符串: \(basicURL)")
        }
        return url
    }
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .saveHealthCard(let healthCertificate, let healthCertificateBack, let healthCertificateStart, let healthCertificateEnd, let userid):
            params["front_image_key"] = healthCertificate
            params["back_image_key"] = healthCertificateBack
            params["from_date"] = healthCertificateStart
            params["end_date"] = healthCertificateEnd
            params["courier_id"] = userid
            params["storage_type"] = SavePhotoType.SavePhotoTypeQiNiu.rawValue
        case .getHealthCard(let userID):
            params["courier_id"] = userID
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getHealthCard(_):
            return ["X-CMD": "dms.certificate.health_card.get"]
        case .saveHealthCard:
            return ["X-CMD": "dms.certificate.health_card.upsert"]
        }
    }
	var authenticationType: AuthenticationType? {
		return .xToken
	}
}
