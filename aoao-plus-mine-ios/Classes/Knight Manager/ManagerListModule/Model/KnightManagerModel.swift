//
//	KnightManagerModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_plus_net_ios
import aoao_plus_common_ios


class KnightManagerModel : NSObject, NSCoding, AAModelProtocol{

	var id : String!
	// 骑手编码
	var code : String!
	// 配送状态(1:无单/50：配送中)
	var deliveryState : Int!
	// 姓名
	var name : String!
	// 电话
	var phone : String!
	// 角色【10：普通骑手、20：组长】
	var role : Int!
	var knightRoleType:UserRole {
		return UserRole.init(rawValue: role) ?? .none
	}
	var storeids: [String]!
	// 是否配送中
	var isDelivery:Bool {
		return userDeliveryState == .inDelivery
	}
	var userDeliveryState:DeliveryState {
		return DeliveryState.init(rawValue: deliveryState) ?? .none
	}
	// 是否展示离线按钮
	// 工作状态 == 离线 就隐藏
	var isHideDismissButton:Bool {
		if self.id == UserModelManager.manager.userInfoModel?.id {
			return true
		}
		return userWorkState == .offline
	}
	// 状态(100:在职/-100:离职)
	var state : Int!
	// 工作状态(100:在岗 -100:离岗)
	var workState : Int!
	var userWorkState: UserWorkState{
		return UserWorkState.init(rawValue: workState) ?? .none
	}
	// 加密的手机号码
	var phoneStr: String {
		if phone.count < 7 {
			return phone
		}
		//截取电话的前3个字符串
		let sub1 = phone.prefix(3)
		//截取某字符串的后3个字符串
		let sub2 = phone.suffix(4)
		return sub1 + "****" + sub2
	}

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["_id"].stringValue
		code = json["code"].stringValue
		deliveryState = json["delivery_state"].intValue
		name = json["name"].stringValue
		phone = json["phone"].stringValue
		role = json["role"].intValue
		state = json["state"].intValue
		workState = json["work_state"].intValue
		storeids = json["store_ids"].arrayValue.map{$0.stringValue}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if code != nil{
			dictionary["code"] = code
		}
		if deliveryState != nil{
			dictionary["delivery_state"] = deliveryState
		}
		if name != nil{
			dictionary["name"] = name
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if role != nil{
			dictionary["role"] = role
		}
		if state != nil{
			dictionary["state"] = state
		}
		if workState != nil{
			dictionary["work_state"] = workState
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         code = aDecoder.decodeObject(forKey: "code") as? String
         deliveryState = aDecoder.decodeObject(forKey: "delivery_state") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         role = aDecoder.decodeObject(forKey: "role") as? Int
         state = aDecoder.decodeObject(forKey: "state") as? Int
         workState = aDecoder.decodeObject(forKey: "work_state") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if deliveryState != nil{
			aCoder.encode(deliveryState, forKey: "delivery_state")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if role != nil{
			aCoder.encode(role, forKey: "role")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}
		if workState != nil{
			aCoder.encode(workState, forKey: "work_state")
		}

	}

}
