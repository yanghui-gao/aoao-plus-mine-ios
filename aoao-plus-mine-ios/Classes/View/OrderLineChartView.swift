//
//  OrderLineChartView.swift
//  aoao-mine-ios
//
//  Created by 高炀辉 on 2021/3/31.
//

import UIKit
import Charts
import SwiftDate

/// 折线图展示所需模型
typealias LineModel = (
	time: Date, // 时间
	value: Int  // 金额
)

class OrderLineChartView: UIView, ChartViewDelegate {

	/// 数据源
	var lineModelList: [LineModel]!
	/// 折线图
	var chartView: LineChartView!
	let labelHeight = 50
	/// x轴间距
	let xLineSpace = 15
	
	var scrollView:UIScrollView!
	
	private var lineChartWidth:CGFloat!
	
	private var lineChartHeight:CGFloat!
	
	public var noneDataText = "暂无数据"
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.white
		self.isUserInteractionEnabled = true
	}
	override class func awakeFromNib() {
		super.awakeFromNib()
	}
	required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
		self.backgroundColor = UIColor.white
		self.isUserInteractionEnabled = true
		self.lineChartWidth = self.frame.size.width
		self.lineChartHeight = self.frame.size.height
		setUI()
	}
	func setUI() {
		self.scrollView = UIScrollView(frame: CGRect.init(x: 16, y: 0, width: self.frame.size.width, height: self.frame.size.height))
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.isUserInteractionEnabled = true
		self.addSubview(scrollView)
		
		self.chartView = LineChartView.init(frame: CGRect.init(x: 0, y: 0, width: Int(lineChartWidth), height: Int(lineChartHeight)))
		self.chartView.isUserInteractionEnabled = true
		self.chartView.noDataText = self.noneDataText
		scrollView.addSubview(self.chartView)
		
		//设置交互样式
		self.chartView.scaleYEnabled = false //取消Y轴缩放
		self.chartView.doubleTapToZoomEnabled = false //双击缩放
		self.chartView.dragEnabled = true //启用拖动手势
		self.chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
		self.chartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
		self.chartView.delegate = self
		
		// 下方的图例
		self.chartView.legend.enabled = false
	}
	func reloadData() {
		
		let needWidth: CGFloat = CGFloat(xLineSpace * self.lineModelList.count)
		if needWidth > lineChartWidth {
			scrollView.contentSize = CGSize.init(width: needWidth, height: scrollView.frame.size.height)
		}
		
		self.chartView.frame = CGRect.init(x: 0, y: 0, width: Int(max(scrollView.contentSize.width, lineChartWidth)) - 16 * 2, height: Int(lineChartHeight))
		
		var dataEntries = [ChartDataEntry]()
		
		// 自定义刻度标签文字
		var xValues = [String]()
		xValues.append("")
		var i = 0
		for obj in self.lineModelList {
			// y轴
			i += 1
			dataEntries.append(ChartDataEntry.init(x: Double(i), y: Double(obj.value)))
			// x轴
			if i % 5 == 0 || i == 1 {
				xValues.append(obj.time.toFormat("MM-dd"))
			} else {
				xValues.append("")
			}
			
		}
		print(dataEntries.count)
		// 这30条数据作为1根折线里的所有数据
		let chartDataSet = LineChartDataSet(dataEntries)
		// 设置线条
		chartDataSet.colors = [NSUIColor(red: 0/255.0, green: 173/255.0, blue: 102/255.0, alpha: 1)] // 线条颜色
		chartDataSet.drawCirclesEnabled = false // 不绘制转折点
		chartDataSet.mode = .cubicBezier // 贝塞尔曲线
		chartDataSet.drawValuesEnabled = false //不绘制拐点上的文字
		chartDataSet.drawFilledEnabled = true //开启填充色绘制
		chartDataSet.fillColor = NSUIColor(red: 182/255.0, green: 232/255.0, blue: 211/255.0, alpha: 1)  //设置填充色
		chartDataSet.fillAlpha = 0.4 //设置填充色透明度
		chartDataSet.drawHorizontalHighlightIndicatorEnabled = false //不显示横向十字线
		chartDataSet.highlightColor = NSUIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1) // 十字线颜色
		
		// 自定义X轴样式
		self.chartView.xAxis.labelPosition = .bottom //x轴显示在下方
		self.chartView.xAxis.drawGridLinesEnabled = false // 不显示x轴对应网格线
		self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
		self.chartView.xAxis.labelCount = xValues.count
		self.chartView.xAxis.granularity = 1
		self.chartView.xAxis.axisMinimum = 1
		self.chartView.xAxis.axisMaximum = Double(dataEntries.count)
		
		// Y轴样式
		self.chartView.leftAxis.drawLabelsEnabled = false //不显示左侧Y轴文字
		self.chartView.leftAxis.drawAxisLineEnabled = false //不显示左侧Y轴
		self.chartView.rightAxis.drawLabelsEnabled = false //不显示右侧Y轴文字
		self.chartView.rightAxis.drawAxisLineEnabled = false //不显示右侧Y轴
		self.chartView.rightAxis.drawGridLinesEnabled = false
		self.chartView.leftAxis.drawGridLinesEnabled = false // 左侧网格线
//		self.chartView.leftAxis.gridColor = NSUIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1) //Y轴对应网格线的颜色
//		self.chartView.leftAxis.gridLineWidth = 0.5 //Y轴对应网格线的大小
//		self.chartView.leftAxis.gridLineDashLengths = [4, 4] // 虚线各段长度
		
		self.chartView.setExtraOffsets(left: 20, top: 0, right: 20, bottom: 0)
		
		// 目前折线图只包括1根折线
		let chartData = LineChartData(dataSets: [chartDataSet])
		// 初始化数据
		self.chartView.data = chartData
        
        self.dismissMarkerView()
		
	}
	
	/// 折线上的点选中回调
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		if Int(entry.x) > self.lineModelList.count {
			self.dismissMarkerView()
			return
		}
		let model = self.lineModelList[Int(entry.x - 1)]
		self.showMarkerView(value: model.time.toFormat("MM月dd日 ") + "\n \(model.value) 单")
	}
	
	/// 展示小气泡
	func showMarkerView(value: String) {
		//使用气泡状的标签
		let marker = BalloonMarker(color: UIColor(white: 51/255, alpha: 1),
								   font: .systemFont(ofSize: 12),
								   textColor: .white,
								   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
		marker.chartView = self.chartView
		marker.minimumSize = CGSize(width: 80, height: 40)
		marker.setLabel(value)
		self.chartView.marker = marker
	}
	
	/// 隐藏小气泡
	func dismissMarkerView() {
		self.chartView.marker = nil
	}
	
}
