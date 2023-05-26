//
//	KnightManagerModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_net_ios
import aoao_common_ios

enum KnightWorkType_Mine: Int {
	case working = 100
	case unWorking = -100
	
	func workStatusStr() -> String {
		switch self {
		case .working:
			return "在岗"
		default:
			return "离岗"
		}
	}
	func workStatusColor() -> UIColor? {
		switch self {
		case .working:
			return UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)
		default:
			return UIColor(named: "Color_FF6B31", in: AAMineModule.share.bundle, compatibleWith: nil)
		}
	}
}

class KnightManagerModel : NSObject, NSCoding, AAModelProtocol{

	var courierId : String!
	var courierMobile : String!
	var courierName : String!
	var doingOrderCount : Int!
    var errorOrderCount: Int!
	var doneCount : Int!
	var isLeisure : Bool!
	var overtimeCount : Int!
	var ridingDistance : Int!
	var storeId : String!
	var storeName : String!
	var workState : Int!
	var role: Int!
	var poi : [String] = []
	var distance: String {
        /// -1 代表无心跳
        if ridingDistance == -1 {
            return "--"
        }
		if let ridingDistance = self.ridingDistance, ridingDistance > 1000 {
            return "\(Double(ridingDistance) / 1000.00)km"
		}
		return "\(ridingDistance ?? 0)m"
	}
	/// 在岗状态
	var knightWorkType:KnightWorkType_Mine{
		return KnightWorkType_Mine(rawValue: self.workState) ?? .working
	}
	var isdoing:Bool {
		if let count = doingOrderCount, count > 0 {
			return true
		}
		return false
	}
	/// 骑手身份信息
	var knightRoleType: KnightRoleType{
		return KnightRoleType(rawValue: self.role) ?? .knight
	}
	/// 管理是否展示离岗按钮
	var isShowDismissButton: Bool {
		/// 工作状态为离岗 不展示
		if self.knightWorkType == .unWorking {
			return false
		}
		// 是自己不展示
		if self.courierId == UserModelManager.manager.userInfoModel?.id {
			return false
		}
		return true
	}
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		courierId = json["courier_id"].stringValue
		courierMobile = json["courier_mobile"].stringValue
		courierName = json["courier_name"].stringValue
		doingOrderCount = json["doing_order_count"].intValue
        errorOrderCount = json["error_order_count"].intValue
		doneCount = json["done_count"].intValue
		isLeisure = json["is_leisure"].boolValue
		overtimeCount = json["overtime_count"].intValue
		ridingDistance = json["riding_distance"].intValue
		storeId = json["store_id"].stringValue
		storeName = json["store_name"].stringValue
		workState = json["work_state"].intValue
		role = json["role"].intValue
		let poiArr = json["poi"].arrayValue
		for poiJson in poiArr{
			poi.append(poiJson.stringValue)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if courierId != nil{
			dictionary["courier_id"] = courierId
		}
		if courierMobile != nil{
			dictionary["courier_mobile"] = courierMobile
		}
		if courierName != nil{
			dictionary["courier_name"] = courierName
		}
		if doingOrderCount != nil{
			dictionary["doing_order_count"] = doingOrderCount
		}
		if doneCount != nil{
			dictionary["done_count"] = doneCount
		}
		if isLeisure != nil{
			dictionary["is_leisure"] = isLeisure
		}
		if overtimeCount != nil{
			dictionary["overtime_count"] = overtimeCount
		}
		if ridingDistance != nil{
			dictionary["riding_distance"] = ridingDistance
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
		if storeName != nil{
			dictionary["store_name"] = storeName
		}
		if workState != nil{
			dictionary["work_state"] = workState
		}
		if role != nil{
			dictionary["role"] = role
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         courierId = aDecoder.decodeObject(forKey: "courier_id") as? String
         courierMobile = aDecoder.decodeObject(forKey: "courier_mobile") as? String
         courierName = aDecoder.decodeObject(forKey: "courier_name") as? String
         doingOrderCount = aDecoder.decodeObject(forKey: "doing_order_count") as? Int
         doneCount = aDecoder.decodeObject(forKey: "done_count") as? Int
		 role = aDecoder.decodeObject(forKey: "role") as? Int
         isLeisure = aDecoder.decodeObject(forKey: "is_leisure") as? Bool
         overtimeCount = aDecoder.decodeObject(forKey: "overtime_count") as? Int
         ridingDistance = aDecoder.decodeObject(forKey: "riding_distance") as? Int
         storeId = aDecoder.decodeObject(forKey: "store_id") as? String
         storeName = aDecoder.decodeObject(forKey: "store_name") as? String
         workState = aDecoder.decodeObject(forKey: "work_state") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if courierId != nil{
			aCoder.encode(courierId, forKey: "courier_id")
		}
		if courierMobile != nil{
			aCoder.encode(courierMobile, forKey: "courier_mobile")
		}
		if role != nil{
			aCoder.encode(role, forKey: "role")
		}
		if courierName != nil{
			aCoder.encode(courierName, forKey: "courier_name")
		}
		if doingOrderCount != nil{
			aCoder.encode(doingOrderCount, forKey: "doing_order_count")
		}
		if doneCount != nil{
			aCoder.encode(doneCount, forKey: "done_count")
		}
		if isLeisure != nil{
			aCoder.encode(isLeisure, forKey: "is_leisure")
		}
		if overtimeCount != nil{
			aCoder.encode(overtimeCount, forKey: "overtime_count")
		}
		if ridingDistance != nil{
			aCoder.encode(ridingDistance, forKey: "riding_distance")
		}
		if storeId != nil{
			aCoder.encode(storeId, forKey: "store_id")
		}
		if storeName != nil{
			aCoder.encode(storeName, forKey: "store_name")
		}
		if workState != nil{
			aCoder.encode(workState, forKey: "work_state")
		}

	}

}
