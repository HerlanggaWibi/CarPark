//
//  ASlots.swift


import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public class ASlotsAvailable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataDict = [NSDictionary?]()
    
    var park = [CarParkModel]()
    
    private var myTableView: UITableView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(ASlotsCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
    }
    
    
    func getDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = format.string(from: date)
        let newString = formattedDate.replacingOccurrences(of: " ", with: "T")
        print(newString)
        return newString
    }
    
    func getData(){
        DispatchQueue.main.async {
            let time = self.getDate()
            let url = URL(string: "https://api.data.gov.sg/v1/transport/carpark-availability?date_time=\(time)")!
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let items = json["items"][0]["carpark_data"]
                    
                    items.array?.forEach({ (carpark) in
                        
                        let lot = carpark["carpark_info"][0]["lot_type"].stringValue
                        let lotA = carpark["carpark_info"][0]["lots_available"].stringValue
                        let total_lots = carpark["carpark_info"][0]["total_lots"].stringValue
                        
                        self.park.append(CarParkModel(lot_type: lot, lots_available: lotA, total_lots: total_lots))


                    })
                    
                    self.myTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return park.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lot = park[indexPath.row].lots_available
        let totalLots = park[indexPath.row].total_lots
        let lotType = park[indexPath.row].lot_type
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! ASlotsCell
        
        cell.myLabel.text = "Slot: \(String(describing: lot))"
        cell.myLabel1.text = "Total: \(String(describing: totalLots))"
        cell.myLabel2.text = "LOT_TYPE: \(lotType)"
        
        
        return cell
    }
    
}
