//
//	StatisticsDetailModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_net_ios

class StatisticsDetailModel : NSObject, NSCoding, AAModelProtocol{

	var id : String!
	var arrivedTime : Int!
	var arrivedViolationCount : Int!
	var arrivedViolationRate : String!
	var complaintRate : String!
	var complaintTc : Int!
	var courierId : String!
	var courierInfo : StatisticsDetailCourierInfo!
	var cph : Int!
	var createdAt : String!
	var deliveryArrivedTime : Int!
	var deliveryTime : Int!
	var done20Count : Int!
	var done20Rate : String!
	var done30Count : Int!
	var done30Rate : String!
	var doneViolationCount : Int!
	var doneViolationRate : String!
	var effectSales : Int!
	var hardlyTc : Int!
	var merchantId : String!
	var merchantInfo : StatisticsDetailMerchantInfo!
	var mergeCount : Int!
	var mergeRate : String!
	var orderTc : Int!
	var reachViolationCount : Int!
	var reachViolationRate : String!
	var realWorkTime : Int!
	var storeId : String!
	var storeInfo : StatisticsDetailMerchantInfo!
	var threeToFiveMergerOrderCount : Int!
	var trips : Int!
	var updateAt : String!
	var updatedAt : String!
	var within2kmCount : Int!
	var within3kmCount : Int!
	var workDate : Int!
	var workMonth : Int!
	/// 取消订单量
	var cancelCount: Int!
	/// 有效订单数量
	var effectCount: Int!
	var updateAtStr: String {
		if let updateAt = self.updatedAt, !updateAt.isEmpty{
			return updateAt.changeTimeStandardFromDateFormat() ?? ""
		}
		return ""
	}
	/// 20分钟送达率
	var done20RateStr: String {
		if let done20Rate = self.done20Rate, !done20Rate.isEmpty, done20Rate != "0.00%", done20Rate != "0"{
			return done20Rate
		} else {
			return "--"
		}
	}
	/// 20分钟送达率单位
	var done20RateUnitStr: String {
		if let done20Rate = self.done20Rate, !done20Rate.isEmpty, done20Rate != "0.00%", done20Rate != "0" {
			return "%"
		} else {
			return ""
		}
	}
	/// 30分钟送达率
	var done30RateStr: String {
		if let done30Rate = self.done30Rate, !done30Rate.isEmpty {
			return done30Rate.replacingOccurrences(of: "%", with: "")
		} else {
			return "--"
		}
	}
	/// 30分钟送达率单位
	var done30RateUnitStr: String {
		if let done30Rate = self.done30Rate, !done30Rate.isEmpty {
			return "%"
		} else {
			return ""
		}
	}
	
	/// 投诉率
	var complaintRateStr: String {
		if let complaintRate = self.complaintRate, !complaintRate.isEmpty, complaintRate != "0.00%", complaintRate != "0" {
			return complaintRate
		} else {
			return "--"
		}
	}
	/// 投诉率单位
	var complaintRateUnitStr: String {
		if let complaintRate = self.complaintRate, !complaintRate.isEmpty, complaintRate != "0.00%", complaintRate != "0"  {
			return "%"
		} else {
			return ""
		}
	}
	
	/// 3-5单并单
	var threeToFiveMergerOrderCountStr: String {
		if let threeToFiveMergerOrderCount = self.threeToFiveMergerOrderCount, threeToFiveMergerOrderCount != 0{
			return "\(threeToFiveMergerOrderCount)"
		} else {
			return "--"
		}
	}
	/// 3-5单并单单位
	var threeToFiveMergerOrderCountUnitStr: String {
		if let threeToFiveMergerOrderCount = self.threeToFiveMergerOrderCount, threeToFiveMergerOrderCount != 0{
			return "单"
		} else {
			return ""
		}
	}
	
	/// 有效订单量
	var effectCountStr: String {
		if let effectCount = self.effectCount{
			return "\(effectCount)"
		} else {
			return "--"
		}
	}
	/// 有效订单量单位
	var effectCountUnitStr: String {
		if let _ = self.effectCount{
			return "单"
		} else {
			return ""
		}
	}
	
	/// 取消订单量
	var cancelCountStr: String {
		if let cancelCount = self.cancelCount{
			return "\(cancelCount)"
		} else {
			return "--"
		}
	}
	/// 取消订单量单位
	var cancelCountUnitStr: String {
		if let _ = self.cancelCount{
			return "单"
		} else {
			return ""
		}
	}
	/// 提前关单
	var doneViolationCountCountStr: String {
		if let doneViolationCount = self.doneViolationCount{
			return "\(doneViolationCount)"
		} else {
			return "--"
		}
	}
	/// 提前关单单位
	var doneViolationCountUnitStr: String {
		if let _ = self.doneViolationCount{
			return "单"
		} else {
			return ""
		}
	}
	
	/// 2公里内订单
	var within2kmCountStr: String {
		if let within2kmCount = self.within2kmCount, within2kmCount != 0{
			return "\(within2kmCount)"
		} else {
			return "--"
		}
	}
	/// 2公里内订单单位
	var within2kmCountUnitStr: String {
		if let within2kmCount = self.within2kmCount, within2kmCount != 0{
			return "单"
		} else {
			return ""
		}
	}
	
	/// 3公里内订单
	var within3kmCountStr: String {
		if let within3kmCount = self.within3kmCount, within3kmCount != 0{
			return "\(within3kmCount)"
		} else {
			return "--"
		}
	}
	/// 3公里内订单单位
	var within3kmCountUnitStr: String {
		if let within3kmCount = self.within3kmCount, within3kmCount != 0{
			return "单"
		} else {
			return ""
		}
	}
	
	/// 派单+到店时间
	var deliveryArrivedTimeStr: String {
		if let deliveryArrivedTime = self.deliveryArrivedTime, deliveryArrivedTime != 0{
			return "\(deliveryArrivedTime)"
		} else {
			return "--"
		}
	}
	/// 派单+到店时间
	var deliveryArrivedTimeUnitStr: String {
		if let deliveryArrivedTime = self.deliveryArrivedTime, deliveryArrivedTime != 0{
			return "分钟"
		} else {
			return ""
		}
	}
	
	/// 离店违规占比
	var arrivedViolationRateStr: String {
		if let arrivedViolationRate = self.arrivedViolationRate, !arrivedViolationRate.isEmpty, arrivedViolationRate != "0.00%", arrivedViolationRate != "0" {
			return arrivedViolationRate
		} else {
			return "--"
		}
	}
	/// 离店违规占比单位
	var arrivedViolationRateUnitStr: String {
		if let arrivedViolationRate = self.arrivedViolationRate, !arrivedViolationRate.isEmpty, arrivedViolationRate != "0.00%", arrivedViolationRate != "0"  {
			return "%"
		} else {
			return ""
		}
	}
	/// 送达违规占比
	var doneViolationRateStr: String {
		if let doneViolationRate = self.doneViolationRate, !doneViolationRate.isEmpty {
			return doneViolationRate.replacingOccurrences(of: "%", with: "")
		} else {
			return "--"
		}
	}
	/// 送达违规占比单位
	var doneViolationRateUnitStr: String {
		if let doneViolationRate = self.doneViolationRate, !doneViolationRate.isEmpty {
			return "%"
		} else {
			return ""
		}
	}
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["_id"].stringValue
		arrivedTime = json["arrived_time"].intValue
		arrivedViolationCount = json["arrived_violation_count"].intValue
		arrivedViolationRate = json["arrived_violation_rate"].stringValue
		complaintRate = json["complaint_rate"].stringValue
		complaintTc = json["complaint_tc"].intValue
		courierId = json["courier_id"].stringValue
		let courierInfoJson = json["courier_info"]
		if !courierInfoJson.isEmpty{
			courierInfo = StatisticsDetailCourierInfo(fromJson: courierInfoJson)
		}
		cph = json["cph"].intValue
		createdAt = json["created_at"].stringValue
		deliveryArrivedTime = json["delivery_arrived_time"].intValue
		deliveryTime = json["delivery_time"].intValue
		done20Count = json["done_20_count"].intValue
		done20Rate = json["done_20_rate"].stringValue
		done30Count = json["done_30_count"].intValue
		done30Rate = json["done_30_rate"].stringValue
		doneViolationCount = json["done_violation_count"].intValue
		doneViolationRate = json["done_violation_rate"].stringValue
		effectSales = json["effect_sales"].intValue
		hardlyTc = json["hardly_tc"].intValue
		merchantId = json["merchant_id"].stringValue
		let merchantInfoJson = json["merchant_info"]
		if !merchantInfoJson.isEmpty{
			merchantInfo = StatisticsDetailMerchantInfo(fromJson: merchantInfoJson)
		}
		mergeCount = json["merge_count"].intValue
		mergeRate = json["merge_rate"].stringValue
		orderTc = json["order_tc"].intValue
		reachViolationCount = json["reach_violation_count"].intValue
		reachViolationRate = json["reach_violation_rate"].stringValue
		realWorkTime = json["real_work_time"].intValue
		storeId = json["store_id"].stringValue
		let storeInfoJson = json["store_info"]
		if !storeInfoJson.isEmpty{
			storeInfo = StatisticsDetailMerchantInfo(fromJson: storeInfoJson)
		}
		threeToFiveMergerOrderCount = json["three_to_five_merger_order_count"].intValue
		trips = json["trips"].intValue
		updateAt = json["update_at"].stringValue
		updatedAt = json["updated_at"].stringValue
		within2kmCount = json["within_2km_count"].intValue
		within3kmCount = json["within_3km_count"].intValue
		workDate = json["work_date"].intValue
		workMonth = json["work_month"].intValue
		cancelCount = json["cancel_count"].intValue
		effectCount = json["effect_count"].intValue
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
		if cancelCount != nil{
			dictionary["cancel_count"] = cancelCount
		}
		
		if arrivedTime != nil{
			dictionary["arrived_time"] = arrivedTime
		}
		if arrivedViolationCount != nil{
			dictionary["arrived_violation_count"] = arrivedViolationCount
		}
		if arrivedViolationRate != nil{
			dictionary["arrived_violation_rate"] = arrivedViolationRate
		}
		if complaintRate != nil{
			dictionary["complaint_rate"] = complaintRate
		}
		if complaintTc != nil{
			dictionary["complaint_tc"] = complaintTc
		}
		if courierId != nil{
			dictionary["courier_id"] = courierId
		}
		if courierInfo != nil{
			dictionary["courier_info"] = courierInfo.toDictionary()
		}
		if cph != nil{
			dictionary["cph"] = cph
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if deliveryArrivedTime != nil{
			dictionary["delivery_arrived_time"] = deliveryArrivedTime
		}
		if deliveryTime != nil{
			dictionary["delivery_time"] = deliveryTime
		}
		if done20Count != nil{
			dictionary["done_20_count"] = done20Count
		}
		if done20Rate != nil{
			dictionary["done_20_rate"] = done20Rate
		}
		if done30Count != nil{
			dictionary["done_30_count"] = done30Count
		}
		if done30Rate != nil{
			dictionary["done_30_rate"] = done30Rate
		}
		if doneViolationCount != nil{
			dictionary["done_violation_count"] = doneViolationCount
		}
		if doneViolationRate != nil{
			dictionary["done_violation_rate"] = doneViolationRate
		}
		if effectSales != nil{
			dictionary["effect_sales"] = effectSales
		}
		if hardlyTc != nil{
			dictionary["hardly_tc"] = hardlyTc
		}
		if merchantId != nil{
			dictionary["merchant_id"] = merchantId
		}
		if merchantInfo != nil{
			dictionary["merchant_info"] = merchantInfo.toDictionary()
		}
		if mergeCount != nil{
			dictionary["merge_count"] = mergeCount
		}
		if mergeRate != nil{
			dictionary["merge_rate"] = mergeRate
		}
		if orderTc != nil{
			dictionary["order_tc"] = orderTc
		}
		if reachViolationCount != nil{
			dictionary["reach_violation_count"] = reachViolationCount
		}
		if reachViolationRate != nil{
			dictionary["reach_violation_rate"] = reachViolationRate
		}
		if realWorkTime != nil{
			dictionary["real_work_time"] = realWorkTime
		}
		if storeId != nil{
			dictionary["store_id"] = storeId
		}
		if storeInfo != nil{
			dictionary["store_info"] = storeInfo.toDictionary()
		}
		if threeToFiveMergerOrderCount != nil{
			dictionary["three_to_five_merger_order_count"] = threeToFiveMergerOrderCount
		}
		if trips != nil{
			dictionary["trips"] = trips
		}
		if updateAt != nil{
			dictionary["update_at"] = updateAt
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if within2kmCount != nil{
			dictionary["within_2km_count"] = within2kmCount
		}
		if within3kmCount != nil{
			dictionary["within_3km_count"] = within3kmCount
		}
		if workDate != nil{
			dictionary["work_date"] = workDate
		}
		if workMonth != nil{
			dictionary["work_month"] = workMonth
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
         arrivedTime = aDecoder.decodeObject(forKey: "arrived_time") as? Int
         arrivedViolationCount = aDecoder.decodeObject(forKey: "arrived_violation_count") as? Int
         arrivedViolationRate = aDecoder.decodeObject(forKey: "arrived_violation_rate") as? String
         complaintRate = aDecoder.decodeObject(forKey: "complaint_rate") as? String
         complaintTc = aDecoder.decodeObject(forKey: "complaint_tc") as? Int
         courierId = aDecoder.decodeObject(forKey: "courier_id") as? String
         courierInfo = aDecoder.decodeObject(forKey: "courier_info") as? StatisticsDetailCourierInfo
         cph = aDecoder.decodeObject(forKey: "cph") as? Int
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         deliveryArrivedTime = aDecoder.decodeObject(forKey: "delivery_arrived_time") as? Int
         deliveryTime = aDecoder.decodeObject(forKey: "delivery_time") as? Int
         done20Count = aDecoder.decodeObject(forKey: "done_20_count") as? Int
         done20Rate = aDecoder.decodeObject(forKey: "done_20_rate") as? String
         done30Count = aDecoder.decodeObject(forKey: "done_30_count") as? Int
         done30Rate = aDecoder.decodeObject(forKey: "done_30_rate") as? String
         doneViolationCount = aDecoder.decodeObject(forKey: "done_violation_count") as? Int
         doneViolationRate = aDecoder.decodeObject(forKey: "done_violation_rate") as? String
         effectSales = aDecoder.decodeObject(forKey: "effect_sales") as? Int
         hardlyTc = aDecoder.decodeObject(forKey: "hardly_tc") as? Int
         merchantId = aDecoder.decodeObject(forKey: "merchant_id") as? String
         merchantInfo = aDecoder.decodeObject(forKey: "merchant_info") as? StatisticsDetailMerchantInfo
         mergeCount = aDecoder.decodeObject(forKey: "merge_count") as? Int
         mergeRate = aDecoder.decodeObject(forKey: "merge_rate") as? String
         orderTc = aDecoder.decodeObject(forKey: "order_tc") as? Int
         reachViolationCount = aDecoder.decodeObject(forKey: "reach_violation_count") as? Int
         reachViolationRate = aDecoder.decodeObject(forKey: "reach_violation_rate") as? String
         realWorkTime = aDecoder.decodeObject(forKey: "real_work_time") as? Int
         storeId = aDecoder.decodeObject(forKey: "store_id") as? String
         storeInfo = aDecoder.decodeObject(forKey: "store_info") as? StatisticsDetailMerchantInfo
         threeToFiveMergerOrderCount = aDecoder.decodeObject(forKey: "three_to_five_merger_order_count") as? Int
         trips = aDecoder.decodeObject(forKey: "trips") as? Int
         updateAt = aDecoder.decodeObject(forKey: "update_at") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         within2kmCount = aDecoder.decodeObject(forKey: "within_2km_count") as? Int
         within3kmCount = aDecoder.decodeObject(forKey: "within_3km_count") as? Int
         workDate = aDecoder.decodeObject(forKey: "work_date") as? Int
         workMonth = aDecoder.decodeObject(forKey: "work_month") as? Int

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
		if arrivedTime != nil{
			aCoder.encode(arrivedTime, forKey: "arrived_time")
		}
		if arrivedViolationCount != nil{
			aCoder.encode(arrivedViolationCount, forKey: "arrived_violation_count")
		}
		if arrivedViolationRate != nil{
			aCoder.encode(arrivedViolationRate, forKey: "arrived_violation_rate")
		}
		if complaintRate != nil{
			aCoder.encode(complaintRate, forKey: "complaint_rate")
		}
		if complaintTc != nil{
			aCoder.encode(complaintTc, forKey: "complaint_tc")
		}
		if courierId != nil{
			aCoder.encode(courierId, forKey: "courier_id")
		}
		if courierInfo != nil{
			aCoder.encode(courierInfo, forKey: "courier_info")
		}
		if cph != nil{
			aCoder.encode(cph, forKey: "cph")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if deliveryArrivedTime != nil{
			aCoder.encode(deliveryArrivedTime, forKey: "delivery_arrived_time")
		}
		if deliveryTime != nil{
			aCoder.encode(deliveryTime, forKey: "delivery_time")
		}
		if done20Count != nil{
			aCoder.encode(done20Count, forKey: "done_20_count")
		}
		if done20Rate != nil{
			aCoder.encode(done20Rate, forKey: "done_20_rate")
		}
		if done30Count != nil{
			aCoder.encode(done30Count, forKey: "done_30_count")
		}
		if done30Rate != nil{
			aCoder.encode(done30Rate, forKey: "done_30_rate")
		}
		if doneViolationCount != nil{
			aCoder.encode(doneViolationCount, forKey: "done_violation_count")
		}
		if doneViolationRate != nil{
			aCoder.encode(doneViolationRate, forKey: "done_violation_rate")
		}
		if effectSales != nil{
			aCoder.encode(effectSales, forKey: "effect_sales")
		}
		if hardlyTc != nil{
			aCoder.encode(hardlyTc, forKey: "hardly_tc")
		}
		if merchantId != nil{
			aCoder.encode(merchantId, forKey: "merchant_id")
		}
		if merchantInfo != nil{
			aCoder.encode(merchantInfo, forKey: "merchant_info")
		}
		if mergeCount != nil{
			aCoder.encode(mergeCount, forKey: "merge_count")
		}
		if mergeRate != nil{
			aCoder.encode(mergeRate, forKey: "merge_rate")
		}
		if orderTc != nil{
			aCoder.encode(orderTc, forKey: "order_tc")
		}
		if reachViolationCount != nil{
			aCoder.encode(reachViolationCount, forKey: "reach_violation_count")
		}
		if reachViolationRate != nil{
			aCoder.encode(reachViolationRate, forKey: "reach_violation_rate")
		}
		if realWorkTime != nil{
			aCoder.encode(realWorkTime, forKey: "real_work_time")
		}
		if storeId != nil{
			aCoder.encode(storeId, forKey: "store_id")
		}
		if storeInfo != nil{
			aCoder.encode(storeInfo, forKey: "store_info")
		}
		if threeToFiveMergerOrderCount != nil{
			aCoder.encode(threeToFiveMergerOrderCount, forKey: "three_to_five_merger_order_count")
		}
		if trips != nil{
			aCoder.encode(trips, forKey: "trips")
		}
		if updateAt != nil{
			aCoder.encode(updateAt, forKey: "update_at")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if within2kmCount != nil{
			aCoder.encode(within2kmCount, forKey: "within_2km_count")
		}
		if within3kmCount != nil{
			aCoder.encode(within3kmCount, forKey: "within_3km_count")
		}
		if workDate != nil{
			aCoder.encode(workDate, forKey: "work_date")
		}
		if workMonth != nil{
			aCoder.encode(workMonth, forKey: "work_month")
		}

	}

}
