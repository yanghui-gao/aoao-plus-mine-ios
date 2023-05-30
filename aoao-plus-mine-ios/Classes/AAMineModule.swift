//
//  AAMineModule.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/9.
//

import UIKit

let modulerName = "aoao-plus-mine-ios"

public class AAMineModule {
	public static let share = AAMineModule()
	
	let storyboardName = "Mine"
	
	public var mineStoryboard: UIStoryboard{
		return UIStoryboard(name: storyboardName, bundle: AAMineModule.share.bundle)
	}
	
	public var contractStoryboard: UIStoryboard{
		return UIStoryboard(name: "Contract", bundle: AAMineModule.share.bundle)
	}
	
	var bundle:Bundle?{
		get{
			guard let bundleURL = Bundle(for: AAMineModule.self).url(forResource: modulerName, withExtension: "bundle") else {
				return nil
			}
			guard let bundle = Bundle(url: bundleURL) else {
				return nil
			}
			return bundle
		}
	}
}
