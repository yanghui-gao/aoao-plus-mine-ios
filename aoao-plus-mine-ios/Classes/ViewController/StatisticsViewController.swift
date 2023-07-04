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
    let getStatisticsObservable = PublishSubject<(courierid: String, date: String)>()

	
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
    // 月份
    var monthStr = ""{
        didSet {
            self.selectDateLabel.text = self.monthStr
        }
    }
	// 折线图开始时间
    var fromDate = ""
	// 折线图结束时间
    var toDate = ""
    // 选中时间
    var selectDate:Date?
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
		if let id = self.userInfoID, let selectDate = self.selectDate {
			let formatter = DateFormatter()
			formatter.locale = Locale.init(identifier: "zh_CN")
			formatter.dateFormat = "yyyyMM"
			let selectDate = formatter.string(from: selectDate)
			// 获取统计信息
			self.getStatisticsObservable.onNext((courierid: id, date: selectDate))
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
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyyMMdd"
		// 选择器开始时间
        let minDate = formatter.date(from: "20210101")
        // 选中时间
        datePicker?.setDate(self.selectDate, animated: false)
        // 开始时间
        datePicker?.minimumDate = minDate
		// 结束时间
        datePicker?.maximumDate = today
        datePicker?.selectedDate = { dateComponents in
			// 选中时间解包
			guard let dateComponents = dateComponents, let selectdate = Calendar.current.date(from: dateComponents), let id = self.userInfoID else {
				self.view.aoaoMakeToast("获取时间失败, 请重试")
				return
			}
			// 选中的时间
			self.selectDate = selectdate
			
			formatter.dateFormat = "yyyy-MM"
			// 用于展示
			self.monthStr = formatter.string(from: selectdate)
			
			formatter.dateFormat = "yyyyMM01"
			// 折线图开始时间
			self.fromDate = formatter.string(from: selectdate)

			/// 如果选中月是当前月
			/// 结束日期为昨天
			/// 不是当前月 结束日期为 月底
			// 时间格式化
			// selectdate.monthDays 代表这个月的天数
			// 结束日期为 20230630
			formatter.dateFormat = "yyyyMM\(selectdate.monthDays)"
			self.toDate = formatter.string(from: selectdate)
			
			formatter.dateFormat = "yyyyMM"
			// 请求参数 月份
			let paraDate = formatter.string(from: selectdate)
			/// 获取骑手信息
			self.getStatisticsObservable.onNext((courierid: id, date: paraDate))
            
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
			statisticsDetailObservable: self.getStatisticsObservable)
		
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
		
		
		
		/// 折线图处理
		self.statisticsViewModel?.outPutStatisticsListObservable.subscribe(onNext: { list in
			
			var lineModelList:[LineModel] = []
            if let date = self.selectDate{
                if let monthFirstDay = date.toFormat("yyyy-MM-01").toDate("yyyy-MM-dd", region: Region.current) {
                    for index in 1...date.monthDays {
						let day = monthFirstDay + index.days
                        let value = list[index - 1]
                        lineModelList.append((time: day.date, value: value))
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
