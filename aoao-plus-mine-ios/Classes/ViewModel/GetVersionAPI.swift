//
//  GetVersionAPI.swift
//  aoao-mine-ios
//
//  Created by 高二豆 on 2021/4/18.
//
import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

enum GetVersionAPI {
    /// 获取版本号
    case getVersion
}
extension GetVersionAPI: TargetType, AuthenticationProtocol {
	var authenticationType: AuthenticationType? {
		return .xToken
	}
	
    
    var method: Moya.Method {
        return .get
    }
    
    var baseURL: URL {
        guard let url = URL(string: "https://itunes.apple.com/lookup") else {
            fatalError("非法的URL字符串: \(basicURL)")
        }
        return url
    }
    public var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .getVersion:
            params["id"] = "1554425649"
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    var headers: [String : String]? {
        return nil
    }
}
