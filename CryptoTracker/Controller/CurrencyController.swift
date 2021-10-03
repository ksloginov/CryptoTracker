//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Konstantin Loginov on 03/10/2021.
//

import UIKit
import Charts
import Alamofire

class CurrencyController: UIViewController {
    @IBOutlet weak var tickerSegment: UISegmentedControl!
    @IBOutlet weak var viewTicker: UIView!
    @IBOutlet weak var lblTicker: UILabel!
    @IBOutlet weak var lblExchangeRate: UILabel!
    @IBOutlet weak var lblExchangeTicker: UILabel!
    @IBOutlet weak var stackCurrentRate: UIStackView!
    @IBOutlet weak var linearChartView: LineChartView!
    @IBOutlet weak var dateRangeSegment: UISegmentedControl!
    
    @IBAction func onTickerSegmentChange(_ sender: Any) {
        selectTicket(CryptoCurrency.allCases[tickerSegment.selectedSegmentIndex])
    }
    
    @IBAction func onDateRangeSegmentChange(_ sender: Any) {
        selectTicket(CryptoCurrency.allCases[tickerSegment.selectedSegmentIndex])
    }
    
    private let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    private let dataService = DataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CryptoTracker"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = titleTextAttributes
        setupDateRangeSegment()
        setupTickerSegment()
        setupChart()
    }
    
    private func setupChart() {
        linearChartView.xAxis.labelPosition = .bottom
        linearChartView.rightAxis.enabled = false
        linearChartView.legend.enabled = false
        
        let xAxis = linearChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12.0, weight: .semibold)
        xAxis.labelTextColor = .white
        xAxis.valueFormatter = DateAxisValueFormatter()
        xAxis.setLabelCount(6, force: false)
        xAxis.gridColor = .white.withAlphaComponent(0.1)
        xAxis.gridLineWidth = 1.0
        
        let yAxis = linearChartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 12.0, weight: .semibold)
        yAxis.labelTextColor = .white
        yAxis.gridColor = .white.withAlphaComponent(0.1)
        yAxis.valueFormatter = CurrencyAxisValueFormatter()
        yAxis.gridLineWidth = 1.0
    }

    private func setupTickerSegment() {
        tickerSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        tickerSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        tickerSegment.selectedSegmentTintColor = .tintColor
        
        tickerSegment.removeAllSegments()
        for ticker in CryptoCurrency.allCases.reversed() {
            tickerSegment.insertSegment(withTitle: ticker.symbol, at: 0, animated: false)
        }
        
        tickerSegment.selectedSegmentIndex = 0
        selectTicket(.BTC)
    }
    
    private func setupDateRangeSegment() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        dateRangeSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        dateRangeSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        dateRangeSegment.selectedSegmentTintColor = .tintColor
        
        dateRangeSegment.removeAllSegments()
        for option in DateRange.allCases.reversed() {
            dateRangeSegment.insertSegment(withTitle: option.rawValue, at: 0, animated: false)
        }
        
        dateRangeSegment.selectedSegmentIndex = 1
    }
    
    private var currentCurrency: CryptoCurrency? = nil
    
    private func selectTicket(_ currency: CryptoCurrency) {
        
        if currentCurrency != currency {
            currentCurrency = currency
            
            lblTicker.text = currency.symbol
            lblExchangeRate.text = " "
            lblExchangeTicker.text = " "
            viewTicker.backgroundColor = currency.color
            
            dataService.loadExchangeRate(currency) { exchangeRate in
                DispatchQueue.main.async { [weak self] in
                    if let rate = exchangeRate?.rate {
                        self?.lblExchangeRate.text = String(format: "%.2f", rate)
                        self?.lblExchangeTicker.text = "USD"
                    }
                }
            }
        }
        
        let selectedPeriod = DateRange.allCases[dateRangeSegment.selectedSegmentIndex]
        guard let date = selectedPeriod.date else { return }
        
        linearChartView.alpha = 0.0
        dataService.loadHistoricalExchangeRate(currency, startingDate: date, period: selectedPeriod.period) { exchangeRates in
            DispatchQueue.main.async { [weak self] in
                guard let exchangeRates = exchangeRates else { return }
                let entries = exchangeRates.map({ ChartDataEntry(x: $0.time.timeIntervalSince1970, y: $0.rate) })
                
                let set = LineChartDataSet(entries)
                set.drawCirclesEnabled = false
                set.drawValuesEnabled = false
                set.drawFilledEnabled = true
                set.mode = .cubicBezier
                set.lineWidth = 3.0
                
                let primaryColor: UIColor = currency.color ?? .green
                set.setColor(primaryColor)
                let colors = [primaryColor.cgColor, primaryColor.withAlphaComponent(0.1).cgColor] as CFArray

                if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: nil) {
                    set.fill = LinearGradientFill(gradient: gradient, angle: -90)
                    set.fillAlpha = 1.0
                }

                UIView.animate(withDuration: 0.2) {
                    self?.linearChartView.alpha = 1.0
                }

                self?.linearChartView.data = LineChartData(dataSet: set)
            }
        }
        
    }

}

