//
//  knightInfoAPI.swift
//  flashman
//
//  Created by 高炀辉 on 2021/1/25.
//  Copyright © 2021 white. All rights reserved.
//

import Foundation
import Moya
import aoao_plus_net_ios
import RxSwift
import aoao_plus_common_ios

enum KnightInfoAPI {
    /// 获取骑手信息
    case getKnightContent(accountID: String)
}
extension KnightInfoAPI: TargetType, AuthenticationProtocol {
	public var baseURL: URL {
		guard let url = URL(string: basicURL) else {
			fatalError("非法的URL字符串: \(basicURL)")
		}
		return url
	}
	public var method: Moya.Method {
		return .post
    }
	public var task: Task {
		var params: [String: Any] = [:]
		switch self {
		case .getKnightContent(let courierId):
			params["_id"] = courierId
		}
		return .requestParameters(parameters: params, encoding: JSONEncoding.default)
	}

	public var headers: [String: String]? {
		switch self {
		case .getKnightContent(_):
			return ["X-CMD":"aoao.courier.courier.get"]
		
		}
	}
	public var authenticationType: AuthenticationType? {
		return .xToken
	}
}
