//
//  StatisticsViewController.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/30.
//

import UIKit
import aoao_plus_common_ios
import RxSwift
import Charts
import SwiftDate
import PGDatePicker

class StatisticsViewController: AAViewController {
	
	/// 数据统计CollectionView
	@IBOutlet weak var collectionView: UICollectionView!
	
	/// 店铺名
	@IBOutlet weak var shopNameLabel: UILabel!
	/// 选择店铺tap
	@IBOutlet var selectShopTap: UITapGestureRecognizer!
	/// 显示当前选中月份
    @IBOutlet weak var selectDateLabel: UILabel!
    /// 选月份
    @IBOutlet var selectMonthTap: UITapGestureRecognizer!
    /// 统计ViewModel
	var statisticsViewModel:StatisticsViewModel?
	
	// 获取骑手统计信息
    let getStatisticsObservable = PublishSubject<(courierid: String, storeID: String, date: String)>()
    
    /// 获取折线图信息
    let statisticsListObservable = PublishSubject<(courierid: String, storeID: String, fromDate: String, toDate: String)>()
	
	// 获取店铺列表
	let getshopListObservable = PublishSubject<(String)>()
	
	/// 店铺列表
	var shopsContentModelList:[ShopsContentModel] = []
	
	/// 统计数据Model
	var model: StatisticsDetailModel?
	
	/// 折线图list
	var statisticslineList: [LineModel]?
	
	/// Collection数据列表
	var statisticsList:[[String: String]] = []
	
	private var selectIndex = 0
	
	let disposeBag = DisposeBag()
    
    var shopsModel: ShopsContentModel?
    
    var monthStr = ""{
        didSet {
            self.selectDateLabel.text = self.monthStr
        }
    }
    var fromDate = ""
    var toDate = ""
    
    var selectDate:Date?
	
	/// 店铺ID
	var shopID: String?
	/// 用户ID
	var userInfoID: String?
	/// 选择店铺高度
	@IBOutlet weak var selectShopHeight: NSLayoutConstraint!
	
	/// 选择店铺View
	@IBOutlet weak var selectShopList: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		setUI()
		bindViewModel()
		
		/// 获取用户信息
		if let id = self.userInfoID {
			self.getshopListObservable.onNext(id)
		}
    }
	func setUI() {
		
		if self.userInfoID == UserModelManager.manager.userInfoModel?.id {
			self.title = "我的业绩"
		} else {
			self.title = "骑手业绩"
		}
		
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.minimumInteritemSpacing = 0.0 //item左右间隔
		flowLayout.minimumLineSpacing = 5.0 //item上下间隔
		flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) //item对象上下左右的距离
		let width = (self.view.frame.size.width - 20) / 3
		flowLayout.itemSize = CGSize(width: width, height: width) //每一个 item 对象大小
		flowLayout.scrollDirection = .vertical //设置滚动方向,默认垂直方向.
		flowLayout.headerReferenceSize = CGSize.init(width: self.view.frame.size.width, height: 282)
		flowLayout.footerReferenceSize = CGSize.init(width: self.view.frame.size.width, height: 50)
		collectionView.setCollectionViewLayout(flowLayout, animated: false)
		
		self.statisticsList = [["name": "有效订单量", "value": "--", "unit" : ""],
						  ["name": "取消订单量", "value": "--", "unit" : ""],
						  ["name": "提前关单量", "value": "--", "unit" : ""],
						  ["name": "30分钟送达占比", "value": "--", "unit" : ""],
						  ["name": "妥投违规占比", "value": "--", "unit" : ""]]
	}
    func setDatePicker() {
        let datePickManager = PGDatePickManager()
        datePickManager.confirmButtonTextColor = UIColor(named: "Color_00AD66", in: AAMineModule.share.bundle, compatibleWith: nil)
        datePickManager.cancelButtonTextColor = UIColor(named: "boss_000000-60_FFFFFF-60", in: AAMineModule.share.bundle, compatibleWith: nil)
        datePickManager.headerViewBackgroundColor = UIColor(named: "color_F8F8F8", in: AAMineModule.share.bundle, compatibleWith: nil)
        datePickManager.titleLabel.text = "选择日期"
        let datePicker = datePickManager.datePicker
        datePicker?.datePickerMode = .yearAndMonth
        
        
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyyMMdd"
        let minDate = formatter.date(from: "20210101")
        
        datePicker?.setDate(self.selectDate, animated: false)
        
        datePicker?.minimumDate = minDate
        datePicker?.maximumDate = Date()
        datePicker?.selectedDate = { date in
            if let date = date, let year = date.year, let month = date.month {
                
                let time_str = "\(year)\(month < 10 ? "0\(month)": "\(month)")02"
                formatter.dateFormat = "yyyyMMdd"
                
                
				if let model = self.shopsModel, let id = self.userInfoID, let selectdate = formatter.date(from: time_str) {
                    self.selectDate = selectdate
                    formatter.dateFormat = "yyyy-MM"
                    self.monthStr = formatter.string(from: selectdate)
                    
                    formatter.dateFormat = "yyyyMM01"
                    self.fromDate = formatter.string(from: selectdate)
                    
                    print(selectdate.monthDays)
                    let date = Date()
                    let todayformatter = DateFormatter()
                    todayformatter.locale = Locale.init(identifier: "zh_CN")
                    todayformatter.dateFormat = "yyyy-MM"
                    let todayStr = todayformatter.string(from: date)
                    /// 如果选中月是当前月
                    /// 结束日期为昨天
                    /// 不是当前月 结束日期为 月底
                    if self.monthStr == todayStr {
                        let toDate = selectdate - 1.days
                        formatter.dateFormat = "yyyyMM\(selectdate.monthDays)"
                        self.toDate = formatter.string(from: toDate)
                    } else {
                        formatter.dateFormat = "yyyyMM\(selectdate.monthDays)"
                        self.toDate = formatter.string(from: selectdate)
                    }
                    
                    
                    
                    /// 获取骑手信息
                    self.statisticsListObservable.onNext((courierid: id, storeID: model.storeInfo.id, fromDate: self.fromDate, toDate: self.toDate))
                    self.getStatisticsObservable.onNext((courierid: id, storeID: model.storeInfo.id, date: self.monthStr.replacingOccurrences(of: "-", with: "")))
                }
            }
            
        }
        self.present(datePickManager, animated: true, completion: nil)
        
    }
	func bindViewModel() {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM"
        self.monthStr = formatter.string(from: date)
        formatter.dateFormat = "yyyyMM01"
        self.fromDate = formatter.string(from: date)
        formatter.dateFormat = "yyyyMMdd"
        self.toDate = formatter.string(from: date)
        
        self.selectDate = Date()
        
        /// 选择月份
        self.selectMonthTap.rx
            .event.subscribe(onNext: {[unowned self] _ in
                self.setDatePicker()
            }).disposed(by: disposeBag)
        
		let input = StatisticsViewModel.Input.init(
			statisticsDetailObservable: self.getStatisticsObservable,
			statisticsListObservable: self.statisticsListObservable,
			getshopListObservable: self.getshopListObservable)
		
		self.statisticsViewModel = StatisticsViewModel.init(input: input)
		
		/// 返回数据处理
		self.statisticsViewModel?.outPutStatisticsDetailObservable.subscribe(onNext: { model in
			
			self.statisticsList = [["name": "有效订单量", "value": "\(model.effectCountStr)", "unit" : "\(model.effectCountUnitStr)"],
								   ["name": "取消订单量", "value": "\(model.cancelCountStr)", "unit" : "\(model.cancelCountUnitStr)"],
							  ["name": "提前关单量", "value": "\(model.doneViolationCountCountStr)", "unit" : "\(model.doneViolationCountUnitStr)"],
							  ["name": "30分钟送达占比", "value": "\(model.done30RateStr)", "unit" : "\(model.done30RateUnitStr)"],
							  ["name": "妥投违规占比", "value": "\(model.doneViolationRateStr)", "unit" : "\(model.doneViolationRateUnitStr)"]]
			self.model = model
			self.collectionView.reloadData()
			//			self.confimOrderLabel.text = "\(model.orderTc ?? 0)"
//			self.updateLabel.text = "最近更新时间: \(model.updateAtStr)"
//			// 20分钟送达率
//			self.onTimeLabel.text = model.done20RateStr
//			self.onTimeUnitLabel.text = model.done20RateUnitStr
//			// 投诉率
//			self.complaintsLabel.text = model.complaintRateStr
//			self.complaintsUnitLabel.text = model.complaintRateUnitStr
//			// 并单量
//			self.orderMergeLabel.text = model.threeToFiveMergerOrderCountStr
//			self.orderMergeUnitLabel.text = model.threeToFiveMergerOrderCountUnitStr
//			// 提前关闭
//			self.DeliveryAdvanceLabel.text = model.doneViolationCountCountStr
//			self.DeliveryAdvanceUnitLabel.text = model.doneViolationCountUnitStr
//			// 2公里内
//			self.twokilometreLabel.text = model.within2kmCountStr
//			self.twokilometreUnitLabel.text = model.within2kmCountUnitStr
//
//			// 3公里内
//			self.threekilometreLabel.text = model.within3kmCountStr
//			self.threekilometreUnitLabel.text = model.within3kmCountUnitStr
//
//			// 派单+到店时间
//			self.sendOrdersLabel.text = model.deliveryArrivedTimeStr
//			self.sendOrdersUnitLabel.text = model.deliveryArrivedTimeUnitStr
//
//			// 离店违规占比
//			self.leaveStoreViolationsLabel.text = model.arrivedViolationRateStr
//			self.leaveStoreViolationsUnitLabel.text = model.arrivedViolationRateUnitStr
//
//			// 离店违规占比
//			self.deliveryVioLationsLabel.text = model.doneViolationRateStr
//			self.deliveryVioLationsUnitLabel.text = model.doneViolationRateUnitStr
			
		}).disposed(by: self.disposeBag)
		
		/// 店铺列表
		self.statisticsViewModel?.outPutShopListObservable.subscribe(onNext: { list in
			self.shopsContentModelList = list
			if !list.isEmpty {
				/// 获取选中指定的店铺信息
				if let shopID = self.shopID, let userID = self.userInfoID {
					if let model = list.first(where: {$0.storeId == shopID}) {
						self.shopsModel = model
						self.selectIndex = 0
						
						/// 设置店铺名称
						self.shopNameLabel.text = model.storeInfo.name
						
						/// 获取骑手信息
						self.statisticsListObservable.onNext((courierid: userID, storeID: shopID, fromDate: self.fromDate, toDate: self.toDate))
						self.getStatisticsObservable.onNext((courierid: userID, storeID: shopID, date: self.monthStr.replacingOccurrences(of: "-", with: "")))
						
						model.isSelect = true
					}
					self.selectShopList.isHidden = true
					self.selectShopHeight.constant = 0
				} else {
					self.selectShopList.isHidden = false
					self.selectShopHeight.constant = 49
					if let model = list.first, let id = self.userInfoID {
						self.shopsModel = model
						self.selectIndex = 0
						
						/// 设置店铺名称
						self.shopNameLabel.text = model.storeInfo?.name
						
						/// 获取骑手信息
						self.statisticsListObservable.onNext((courierid: id, storeID: model.storeInfo.id, fromDate: self.fromDate, toDate: self.toDate))
						self.getStatisticsObservable.onNext((courierid: id, storeID: model.storeInfo.id, date: self.monthStr.replacingOccurrences(of: "-", with: "")))
						
						model.isSelect = true
					}
				}
			}
		}).disposed(by: disposeBag)
		
		/// 折线图处理
		self.statisticsViewModel?.outPutStatisticsListObservable.subscribe(onNext: { list in
			
			var lineModelList:[LineModel] = []
            if let date = self.selectDate{
                if let monthFirstDay = date.toFormat("yyyy-MM-01").toDate("yyyy-MM-dd", region: Region.current) {
                    for index in 1...date.monthDays {
                        let day = monthFirstDay + index.days
                        
                        lineModelList.append((time: day.date, value: 0))
                    }
                }
                for index in 0...lineModelList.count - 1 {
                    for model in list {
                        let dayNumber = Int(lineModelList[index].time.toFormat("yyyyMMdd"))
                        if model.workDate == dayNumber {
                            lineModelList[index].value = model.orderTc
                        }
                    }
                }
                print(lineModelList)
                self.statisticslineList = lineModelList
                self.collectionView.reloadData()
            }
			
		}).disposed(by: self.disposeBag)
		
		/// 错误处理
		self.statisticsViewModel?.outPutErrorObservable.subscribe(onNext: { error in
			self.view.makeToast(error.zhMessage)
		}).disposed(by: disposeBag)
		
		self.selectShopTap.rx.event.subscribe(onNext: { _ in
            if self.shopsContentModelList.isEmpty {
                return
            }
			/// 跳转
			let stroyboard = AACommonMoudle.share.storyboard
			let shopVc = stroyboard.instantiateViewController(withIdentifier: "SelectShopViewController") as! SelectShopViewController
			shopVc.modalPresentationStyle = .overCurrentContext
			
//			shopVc.chooseKnightObservable.subscribe(onNext: { [unowned self] index in
//                if !self.shopsContentModelList.isEmpty {
//					
//                    self.shopsModel = shopsContentModelList[index]
//                    
//					self.selectIndex = index
//					
//					self.shopNameLabel.text = shopsContentModelList[index].storeInfo?.name
//					
//					shopsContentModelList[index].isSelect = true
//					
//					guard let id = shopsContentModelList[index].storeInfo.id else {
//						return
//					}
//					guard let courierid = self.userInfoID else {
//						return
//					}
//                    
//                    self.statisticsListObservable.onNext((courierid: courierid, storeID: id, fromDate: self.fromDate, toDate: self.toDate))
//                    self.getStatisticsObservable.onNext((courierid: courierid, storeID: id, date: self.monthStr.replacingOccurrences(of: "-", with: "")))
//				}
//				
//			}).disposed(by: self.disposeBag)
			/// 每次都回传
//			shopVc.dateSource = self.shopsContentModelList
//			shopVc.selectIndex = self.selectIndex
			self.navigationController?.present(shopVc, animated: true, completion: {
				UIView.animate(withDuration: 0.5) {
					shopVc.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
				}
			})
		}).disposed(by: disposeBag)
	}
}
extension StatisticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.statisticsList.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StatisticsCollectionViewCell
		cell.titleLabel.text = self.statisticsList[indexPath.row]["name"]
		cell.unitLabel.text = self.statisticsList[indexPath.row]["unit"]
		cell.valueLabel.text = self.statisticsList[indexPath.row]["value"]
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		var reuseIdentifier = "header"
		if kind == UICollectionView.elementKindSectionFooter {
			reuseIdentifier = "footer"
			let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
			 as! StatisticsFooterCollectionReusableView
			view.model = self.model
			return view
		} else {
			reuseIdentifier = "header"
			let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
			 as! StatisticsHeaderCollectionReusableView
			view.model = self.model
			view.lineList = self.statisticslineList
			return view
		}
	}
	
}
