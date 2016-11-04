import UIKit

protocol BarChartViewDelegate: class {
    func barTapped(at index: Int)
}

class BarChartView: UIView {
    var values: [Double] = [] {
        didSet {
            self.subviews.forEach { $0.removeFromSuperview() }
            var currentLeftAnchor = leftAnchor
            for (index, value) in values.enumerated() {
                assert(value >= 0 && value <= 1)
                
                let bar = UIButton(type: .custom)
                bar.translatesAutoresizingMaskIntoConstraints = false
                bar.backgroundColor = UIColor.gray
                bar.tag = index
                bar.addTarget(self, action: #selector(didTap), for: .touchUpInside)
                
                addSubview(bar)
                
                bar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                bar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: CGFloat(value)).isActive = true
                bar.leftAnchor.constraint(equalTo: currentLeftAnchor, constant: 10).isActive = true
                bar.widthAnchor.constraint(equalToConstant: 30).isActive = true
                currentLeftAnchor = bar.rightAnchor
            }
        }
    }
    weak var delegate: BarChartViewDelegate?
    
    func didTap(sender: UIView) {
        delegate?.barTapped(at: sender.tag)
    }
}


class MyViewController: UIViewController, BarChartViewDelegate {
    var barChart: BarChartView = {
        let view = BarChartView(frame: CGRect(origin: CGPoint(x: 43, y: 0), size: CGSize(width: 300, height: 200)))
        view.backgroundColor = .white
        view.values = [0.1, 0.3, 0.6, 0.7, 0.5, 0.8, 0.1]
        return view
    }()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(barChart)
        barChart.delegate = self
    }
    
    func barTapped(at index: Int) {
        print("Bar tapped: \(index)")
        self.selectedIndex = index
    }
}


import PlaygroundSupport
let viewController = MyViewController()
PlaygroundPage.current.liveView = viewController
