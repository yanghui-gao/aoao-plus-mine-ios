//
//  WorkStatusExamineAPI.swift
//  aoao-plus-mine-ios
//
//  Created by 高炀辉 on 2023/6/7.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

enum WorkStatusExamineAPI {
	/// 获取骑手工作信息
	case getKnightWorkInfo(id: String)
}
extension WorkStatusExamineAPI: TargetType, AuthenticationProtocol {
	
	var method: Moya.Method {
		return .post
	}
	
	var baseURL: URL {
		guard let url = URL(string: basicURL) else {
			fatalError("非法的URL字符串: \(basicURL)")
		}
		return url
	}
	var task: Task {
		var params: [String: Any] = [:]
		switch self {
		case .getKnightWorkInfo(let id):
			params["_id"] = id
		}
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}
	
	var headers: [String: String]? {
		switch self {
		case .getKnightWorkInfo(_):
			return ["X-CMD":"aoao.courier.work.get"]
		}
	}
	var authenticationType: AuthenticationType? {
		return .xToken
	}
}
