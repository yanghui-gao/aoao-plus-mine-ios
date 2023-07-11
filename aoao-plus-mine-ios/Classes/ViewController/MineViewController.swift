//
//  MineViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/9.
//

import UIKit
import RxSwift
import aoao_plus_common_ios

class MineViewController: AAViewController {
	/// 骑手名称
	@IBOutlet weak var nameLabel: UILabel!
	/// 骑手电话
	@IBOutlet weak var phoneLabel: UILabel!
	/// 实名状态
	@IBOutlet weak var authenticationLabel: UILabel!
    /// 未实名
    @IBOutlet weak var unAuthenticationLabel: UILabel!
    
	/// 入职状态图标
//	@IBOutlet weak var jobStatusimageView: UIImageView!
	/// 操作配置CollectionView
	@IBOutlet weak var configurationCollectionView: UICollectionView!
	
	@IBOutlet weak var rightButton: UIButton!
	
	let disposeBag = DisposeBag()
	
	var dateSource: [[String: String]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
    }
	// MARK: - 生命周期
   override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
	}
	func setUI() {
        if let model = UserModelManager.manager.userInfoModel {
            self.nameLabel.text = model.name
            self.phoneLabel.text = model.phoneStr
        }
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: self.view.frame.width / 3 - 15, height: self.view.frame.width / 3)
		self.configurationCollectionView.collectionViewLayout = layout
		
		self.authenticationLabel.layer.masksToBounds = true
        self.authenticationLabel.layer.cornerRadius = 9
        
        self.unAuthenticationLabel.layer.masksToBounds = true
        self.unAuthenticationLabel.layer.cornerRadius = 9
        
       
        if let user = UserModelManager.manager.userInfoModel {
            self.authenticationLabel.isHidden = user.authenticateState == .unAuthentication
            self.unAuthenticationLabel.isHidden = user.authenticateState == .authenticated
        }
       
		setCollectionDateSource()
	}
	func bindViewModel() {
		
		self.rightButton.rx.tap.subscribe(onNext: { _ in
			self.navigationController?.popViewController(animated: true)
		}).disposed(by: self.disposeBag)
		
		
	}
	func setCollectionDateSource() {
		if UserModelManager.manager.userInfoModel?.userRole == .groupLeader {
			dateSource = [["name": "接单检测", "icon": "examine", "type": "examine"],
						  ["name": "骑手信息", "icon": "knight", "type": "knight"],
						  ["name": "我的业绩", "icon": "result", "type": "statistics"],
						  ["name": "历史订单", "icon": "historyOrder", "type": "historyOrder"],
						  ["name": "运力调度", "icon": "distributeorder", "type": "distributeorder"],
						  ["name": "帮助", "icon": "help", "type": "help"],
						  ["name": "设置", "icon": "setup", "type": "setup"],
						  ["name": "培训学习", "icon": "learn", "type": "learn"],
						  ["name": "骑手管理", "icon": "knightManager", "type": "knightManager"]
			]
		} else {
			dateSource = [["name": "接单检测", "icon": "examine", "type": "examine"],
						  ["name": "骑手信息", "icon": "knight", "type": "knight"],
						  ["name": "我的业绩", "icon": "result", "type": "statistics"],
						  ["name": "历史订单", "icon": "historyOrder", "type": "historyOrder"],
						  ["name": "帮助", "icon": "help", "type": "help"],
						  ["name": "设置", "icon": "setup", "type": "setup"],
						  ["name": "培训学习", "icon": "learn", "type": "learn"]
						  
			]
		}
		
	}

}
extension MineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dateSource.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mine", for: indexPath) as! MineCollectionViewCell
		let dic = dateSource[indexPath.row]
		cell.nameLabel.text = dic["name"]
		if let iconName = dic["icon"] {
			cell.iconimageView.image = UIImage(named: iconName, in: AAMineModule.share.bundle , compatibleWith: nil)
		}
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let dic = dateSource[indexPath.row]
		if let type = dic["type"] {
			switch type {
			case "knight":
				"knight".openURL(para: ["accountID": UserModelManager.manager.userInfoModel?.id])
			case "help":
				"help".openURL()
			case "setup":
				"setup".openURL()
			case "distributeorder":
				"distributeOrder".openURL()
            case "historyOrder":
                "history".openURL()
			case "statistics":
				"statistics".openURL(para: ["userInfoID": UserModelManager.manager.userInfoModel?.id])
			case "learn":
				"learn".openURL()
			case "knightManager":
				"knightManager".openURL()
			case "examine":
				"workStatusExamine".openURL()
			default:
				print("other")
			}
		}
	}
}
