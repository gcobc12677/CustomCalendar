//
//  MCalendar.swift
//  Volvo
//
//  Created by 楊季儒 on 2017/9/5.
//  Copyright © 2017年 MingYao Li. All rights reserved.
//

import UIKit

class MCalendar: UIView {
    
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var monthOfYear: UILabel!
    @IBOutlet weak var dateContainer: UIStackView!
    
//    var dates = Set<UIButton>();
    var dates = [UIButton]();
    
    var currentMonthOfYear: Date!
    var dateFormatter: DateFormatter!
    
    var CALENDAR_BG = UIColor(displayP3Red: 221/255, green: 221/255, blue: 221/255, alpha: 1);
    var NORMAL_COLOR = UIColor(displayP3Red: 5/255, green: 98/255, blue: 175/255, alpha: 1);
    var SELECT_COLOR = UIColor(displayP3Red: 5/255, green: 98/255, blue: 175/255, alpha: 1);
    var DISABLE_COLOR = UIColor(displayP3Red: 136/255, green: 136/255, blue: 136/255, alpha: 1);
    
    var NORMAL_BG = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1);
    var SELECT_BG = UIColor(displayP3Red: 242/255, green: 77/255, blue: 47/255, alpha: 1);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        mInit();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        mInit();
    }
    
    func mInit() {
        Bundle.main.loadNibNamed("MCalendar", owner: self, options: nil);
        addSubview(rootView);
        rootView.frame = self.bounds;
        rootView.backgroundColor = CALENDAR_BG;
        rootView.autoresizingMask = [.flexibleHeight, .flexibleWidth];
        
        currentMonthOfYear = Date();
        
        dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "M月.YYYY";
        
        generateDayOfWeekLabels();
        generateDateLabels();
        
        updateUI();
    }
    
    func generateDayOfWeekLabels() {
        let rowContainer: UIStackView = UIStackView();
        rowContainer.axis = .horizontal
        rowContainer.distribution = .fillEqually
        rowContainer.alignment = .center
        rowContainer.spacing = 5.0
        
        for i in 0 ..< 7 {
            let codedLabel:UILabel = UILabel();
            codedLabel.textAlignment = .center;
            
            switch i {
            case 0:
                codedLabel.text = "日";
                break;
            case 1:
                codedLabel.text = "一";
                break;
            case 2:
                codedLabel.text = "二";
                break;
            case 3:
                codedLabel.text = "三";
                break;
            case 4:
                codedLabel.text = "四";
                break;
            case 5:
                codedLabel.text = "五";
                break;
            case 6:
                codedLabel.text = "六";
                break;
            default:
                break;
            }
            
            codedLabel.numberOfLines = 1;
            switch i {
            case 0, 6:
                codedLabel.textColor = UIColor.red;
                break;
            default:
                codedLabel.textColor = UIColor.black;
                break;
            }
            
            codedLabel.font = UIFont.systemFont(ofSize: 16);
            
            rowContainer.addArrangedSubview(codedLabel);
            codedLabel.translatesAutoresizingMaskIntoConstraints = false;
        }
        dateContainer.addArrangedSubview(rowContainer);
    }
    
    func generateDateLabels() {
        for row in 0 ..< 6 {
            let rowContainer: UIStackView = UIStackView();
            rowContainer.axis = .horizontal
            rowContainer.distribution = .fillEqually
            rowContainer.alignment = .center
            rowContainer.spacing = 5.0

            for dayOfWeek in 0 ..< 7 {
                let btn = UIButton();
                btn.titleLabel?.adjustsFontSizeToFitWidth = true
                btn.setTitle(String(format: "%d", dayOfWeek + row * 7), for: .normal);
                btn.setTitleColor(NORMAL_COLOR, for: .normal);
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                btn.backgroundColor = NORMAL_BG;
                
                rowContainer.addArrangedSubview(btn);
                btn.translatesAutoresizingMaskIntoConstraints = false;
                
                dates.append(btn);
            }
            
            dateContainer.addArrangedSubview(rowContainer);
        }
    }
    
    func updateUI() {
        monthOfYear.text = dateFormatter.string(from: currentMonthOfYear);
        
        let calendar = Calendar.current;
        var firstDayComponents = calendar.dateComponents([.year, .month, .day], from: currentMonthOfYear );
        firstDayComponents.day = 1;
        let firstDayCalendar = calendar.date(from: firstDayComponents);
        let firstDayOfWeek = calendar.component(.weekday, from: firstDayCalendar!);
        print(firstDayOfWeek);
        
        var lastDayComponents = calendar.dateComponents([.year, .month, .day], from: currentMonthOfYear );
        lastDayComponents.month! += 1;
        lastDayComponents.day = 1;
        lastDayComponents.day! -= 1;
        let lastDayCalendar = calendar.date(from: lastDayComponents);
        let lastDayOfMonth = calendar.component(.day, from: lastDayCalendar!);
        print(lastDayOfMonth);
        
        for (i, date) in dates.enumerated() {
            if ((i < 7 && i < firstDayOfWeek - 1) || i > firstDayOfWeek + lastDayOfMonth - 2) {
                date.setTitle(nil, for: .normal);
            } else {
                date.setTitle(String(format: "%d", i - firstDayOfWeek + 2), for: .normal);
            }
        }
    }
    
    @IBAction func onPrevClick(_ sender: UIButton) {
        var newDateComponent = DateComponents();
        newDateComponent.month = -1;
        currentMonthOfYear = Calendar.current.date(byAdding: newDateComponent, to: currentMonthOfYear);
        
        monthOfYear.text = dateFormatter.string(from: currentMonthOfYear);
        
        updateUI();
    }
    
    @IBAction func onNextClick(_ sender: UIButton) {
        var newDateComponent = DateComponents();
        newDateComponent.month = 1;
        currentMonthOfYear = Calendar.current.date(byAdding: newDateComponent, to: currentMonthOfYear);
        
        monthOfYear.text = dateFormatter.string(from: currentMonthOfYear);
        
        updateUI();
    }
}
