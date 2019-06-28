//
//  ASlots.swift
//  CobaTable


import Foundation
import UIKit

public class ASlotsAvailable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataDict = [NSDictionary?]()
    
    private var myTableView: UITableView!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
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
    
    
    
    func loadData() {
        let time = getDate()
        let url = URL(string: "https://api.data.gov.sg/v1/transport/carpark-availability?date_time=\(time)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                let response = response as? HTTPURLResponse
                
                guard let data = data else {
                    return
                }
                
                if response?.statusCode != 200  {
                    print("status response saat posting: \(String(describing: response?.statusCode)) ")
                }
                else {
                    do {
                        
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                        
                        
                        guard let dataJson = json?["items"] as? [NSDictionary] else {return}
                        
                        let def = dataJson[0]["carpark_data"] as! [NSDictionary]
                        
                        
                        self.dataDict = def
                        
                        print(self.dataDict)
                        
                        self.myTableView.reloadData()
                        
                    }
                        
                    catch{
                        print("tidak ada data JSON")
                    }
                }
                
            } // Penutup DispatchQueue.main.async
            }.resume()
        
        
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataDict.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.dataDict[indexPath.row]?["carpark_info"] as? [NSDictionary]
        let lot = info?[0]["lots_available"] as! String
        let totalLots = info?[0]["total_lots"] as! String
        let lotType = info?[0]["lot_type"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! ASlotsCell
        
        cell.myLabel.text = "Slot: \(String(describing: lot))"
        cell.myLabel1.text = "Total: \(String(describing: totalLots))"
        cell.myLabel2.text = "LOT_TYPE: \(lotType)"
        
        return cell
    }
    
}
