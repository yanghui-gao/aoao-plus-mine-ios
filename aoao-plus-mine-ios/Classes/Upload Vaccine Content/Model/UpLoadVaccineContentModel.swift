//
//	UpLoadVaccineContentModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON
import aoao_net_ios

class UpLoadVaccineContentModel : NSObject, NSCoding, AAModelProtocol{

	var courierId : String!
	var courierInfo : UpLoadVaccineContentCourierInfo!
	var createdAt : String!
	var doneAt : String!
	var id : String!
	var reason : String!
	var rejectAt : String!
	var state : Int!
	var testingAssetId : String!
	var testingAssetUrl : String!
	var testingDate : String!
	var testingExpireDate : String!
	var vaccinationAssetId : String!
	var vaccinationAssetUrl : String!
	var vaccinationDate : String!
	var vaccinationState: UpLoadVaccineContentViewController.UpLoadVaccineContentState? {
		return UpLoadVaccineContentViewController.UpLoadVaccineContentState.init(rawValue: self.state)
	}

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
    required init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		courierId = json["courier_id"].stringValue
		let courierInfoJson = json["courier_info"]
		if !courierInfoJson.isEmpty{
			courierInfo = UpLoadVaccineContentCourierInfo(fromJson: courierInfoJson)
		}
		createdAt = json["created_at"].stringValue
		doneAt = json["done_at"].stringValue
		id = json["id"].stringValue
		reason = json["reason"].stringValue
		rejectAt = json["reject_at"].stringValue
		state = json["state"].intValue
		testingAssetId = json["testing_asset_id"].stringValue
		testingAssetUrl = json["testing_asset_url"].stringValue
		testingDate = json["testing_date"].stringValue
		testingExpireDate = json["testing_expire_date"].stringValue
		vaccinationAssetId = json["vaccination_asset_id"].stringValue
		vaccinationAssetUrl = json["vaccination_asset_url"].stringValue
		vaccinationDate = json["vaccination_date"].stringValue
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
		if courierInfo != nil{
			dictionary["courier_info"] = courierInfo.toDictionary()
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if doneAt != nil{
			dictionary["done_at"] = doneAt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if reason != nil{
			dictionary["reason"] = reason
		}
		if rejectAt != nil{
			dictionary["reject_at"] = rejectAt
		}
		if state != nil{
			dictionary["state"] = state
		}
		if testingAssetId != nil{
			dictionary["testing_asset_id"] = testingAssetId
		}
		if testingAssetUrl != nil{
			dictionary["testing_asset_url"] = testingAssetUrl
		}
		if testingDate != nil{
			dictionary["testing_date"] = testingDate
		}
		if testingExpireDate != nil{
			dictionary["testing_expire_date"] = testingExpireDate
		}
		if vaccinationAssetId != nil{
			dictionary["vaccination_asset_id"] = vaccinationAssetId
		}
		if vaccinationAssetUrl != nil{
			dictionary["vaccination_asset_url"] = vaccinationAssetUrl
		}
		if vaccinationDate != nil{
			dictionary["vaccination_date"] = vaccinationDate
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
         courierInfo = aDecoder.decodeObject(forKey: "courier_info") as? UpLoadVaccineContentCourierInfo
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         doneAt = aDecoder.decodeObject(forKey: "done_at") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         reason = aDecoder.decodeObject(forKey: "reason") as? String
         rejectAt = aDecoder.decodeObject(forKey: "reject_at") as? String
         state = aDecoder.decodeObject(forKey: "state") as? Int
         testingAssetId = aDecoder.decodeObject(forKey: "testing_asset_id") as? String
         testingAssetUrl = aDecoder.decodeObject(forKey: "testing_asset_url") as? String
         testingDate = aDecoder.decodeObject(forKey: "testing_date") as? String
         testingExpireDate = aDecoder.decodeObject(forKey: "testing_expire_date") as? String
         vaccinationAssetId = aDecoder.decodeObject(forKey: "vaccination_asset_id") as? String
         vaccinationAssetUrl = aDecoder.decodeObject(forKey: "vaccination_asset_url") as? String
         vaccinationDate = aDecoder.decodeObject(forKey: "vaccination_date") as? String

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
		if courierInfo != nil{
			aCoder.encode(courierInfo, forKey: "courier_info")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if doneAt != nil{
			aCoder.encode(doneAt, forKey: "done_at")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if reason != nil{
			aCoder.encode(reason, forKey: "reason")
		}
		if rejectAt != nil{
			aCoder.encode(rejectAt, forKey: "reject_at")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}
		if testingAssetId != nil{
			aCoder.encode(testingAssetId, forKey: "testing_asset_id")
		}
		if testingAssetUrl != nil{
			aCoder.encode(testingAssetUrl, forKey: "testing_asset_url")
		}
		if testingDate != nil{
			aCoder.encode(testingDate, forKey: "testing_date")
		}
		if testingExpireDate != nil{
			aCoder.encode(testingExpireDate, forKey: "testing_expire_date")
		}
		if vaccinationAssetId != nil{
			aCoder.encode(vaccinationAssetId, forKey: "vaccination_asset_id")
		}
		if vaccinationAssetUrl != nil{
			aCoder.encode(vaccinationAssetUrl, forKey: "vaccination_asset_url")
		}
		if vaccinationDate != nil{
			aCoder.encode(vaccinationDate, forKey: "vaccination_date")
		}

	}

}
