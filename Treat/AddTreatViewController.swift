//
//  AddTreatViewController.swift
//  Treat
//
//  Created by Kelden Lin on 3/5/19.
//  Copyright © 2019 iSchool. All rights reserved.
//

import UIKit

struct TreatObject: Codable {
    let name: String
    let points: Int
    let category: String
}

class TreatOnlineDataSource : NSObject, UITableViewDataSource
{
    var data : [Treat] = []
    init(_ elements : [Treat]) {
        data = elements
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreatOnlineCell") as! TreatOnlineCell
        let currData = data[indexPath.row]
        
        cell.name.text = currData.name
        cell.category.text = currData.category
        cell.pointsButton.setTitle(String(currData.points), for: .normal)
        
        return cell
    }
}


class AddTreatViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var popularTableView: UITableView!
    
    var treats : [Treat] = []
    var dataSource : TreatOnlineDataSource? = nil
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row at \(indexPath)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set default Treat
        dataSource = TreatOnlineDataSource([])
        popularTableView.dataSource = dataSource
        popularTableView.delegate = self
        popularTableView.reloadData()
        
        // Fetch online Treats
        fetchJsonData("https://api.myjson.com/bins/zvc0e")
        print("test")
        
 
        // Do any additional setup after loading the view.
    }
    
    func fetchJsonData(_ fetchUrl: String){
        let url = URL(string: fetchUrl)
//        if url == nil {
//            self.refreshControl.endRefreshing()
//            self.showURLFailed();
//        }
//        else {
            URLSession.shared.dataTask(with: url!) { (data, res, err) in
                guard let data = data else {
                    // No data to decode
                    print("no data")
                    
                    return
                }
                
                guard let treat = try? JSONDecoder().decode([TreatObject].self, from: data) else {
                    // Couldn't decode data into a Category
                    print("data not readable")
                    return
                }
                
//                UserDefaults.standard.set(data, forKey: "data") // Saved for offline use
                let fetchedTreats : [Treat] = self.convertJsonToTreats(treat)
                
                DispatchQueue.main.async {
                    print(fetchedTreats)
                    self.treats = fetchedTreats
                    self.dataSource = TreatOnlineDataSource(self.treats)
                    self.popularTableView.dataSource = self.dataSource
                    self.popularTableView.reloadData()
                }
            }.resume()
        }
//    }
    
    
    func convertJsonToTreats (_ treats : [TreatObject]) -> [Treat] {
        var returnTreat : [Treat] = []
        for t in treats {
            let currTreat = Treat(name: t.name, points: t.points, category: t.category)
            returnTreat.append(currTreat)
        }
        
//        returnTreat = returnTreat.sorted(by: { $0.hits > $1.hits })
        
        return returnTreat
    }
    
    
}
