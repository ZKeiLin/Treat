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
    var userTreats : [Treat] = []
    
    init(_ elements : [Treat]) { data = elements }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let showCount = data.count < 5 ? data.count : 5
        return showCount // Show first 5 "Popular" Treats
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreatOnlineCell") as! TreatOnlineCell
        let currData = data[indexPath.row]
        
        cell.name.text = currData.name
        cell.category.text = currData.category
        cell.pointsButton.setTitle(String(currData.points), for: .normal)
        
        for t in userTreats {
            if t.name == currData.name {
                cell.pointsButton.setTitle("Added", for: .normal)
                cell.pointsButton.titleLabel?.font = .systemFont(ofSize: 13.0)
                cell.pointsButton.setTitleColor(UIColor.gray, for: .normal)
                cell.pointsButton.isEnabled = false
                break
            }
        }
        
        cell.pointsButton.tag = indexPath.row
        
        return cell
    }
}

class TreatOnlineCategoryDataSource : NSObject, UITableViewDataSource
{
    var data : [String] = []
    init(_ elements : [String]) { data = elements }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TreatCategoryCell") as! TreatCategoryCell
        cell.name.text = data[indexPath.row]
        
        return cell
    }
}



class AddTreatViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var popularTableView: UITableView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var userTreats : [Treat] = []
    var treats : [Treat] = []
    var categories : [String] = []
    var dataSource : TreatOnlineDataSource? = nil
    var categoryDataSource : TreatOnlineCategoryDataSource? = nil
    
    
    @IBAction func cancelAdd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTreat (_ sender : UIButton) {
        SecondViewController.GlobalVariable.addedTreat = treats[sender.tag]
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Popular Treat Table
        dataSource = TreatOnlineDataSource(treats)
        dataSource?.userTreats = userTreats
        popularTableView.dataSource = dataSource
        popularTableView.delegate = self
        popularTableView.reloadData()
        
        // Initialize Category Treat Table
        categoryDataSource = TreatOnlineCategoryDataSource(categories)
        categoryTableView.dataSource = categoryDataSource
        categoryTableView.delegate = self
        categoryTableView.reloadData()
        
        // Fetch online Treats (Sample JSON)
        fetchJsonData("https://api.myjson.com/bins/1002ja")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "treatCategorySegue" {
            if let indexPath = categoryTableView.indexPathForSelectedRow {
                let treatCategoryView = segue.destination as! TreatCategoryViewController
                treatCategoryView.treats = getTreatsFromCategory(categories[indexPath.row])
                treatCategoryView.userTreats = userTreats
            }
        } else if segue.identifier == "treatNewSegue" {
            let createTreatView = segue.destination as! CreateTreatViewController
            createTreatView.categoryList = categories
        }
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
                    // All Treats
                    self.treats = fetchedTreats
                    self.dataSource = TreatOnlineDataSource(self.treats)
                    self.dataSource?.userTreats = self.userTreats
                    self.popularTableView.dataSource = self.dataSource
                    self.popularTableView.reloadData()
                    
                    // Categories
                    self.categories = self.getCategories(self.treats)
                    self.categoryDataSource = TreatOnlineCategoryDataSource(self.categories)
                    self.categoryTableView.dataSource = self.categoryDataSource
                    self.categoryTableView.reloadData()

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
                self.categories = getCategories(returnTreat)
        
        return returnTreat
    }
    
    func getCategories (_ treats : [Treat]) -> [String] {
        var returnCategories : [String] = []
        for t in treats {
            if !returnCategories.contains(t.category) { returnCategories.append(t.category) }
        }
        
        return returnCategories
    }
    
    func getTreatsFromCategory (_ category : String) -> [Treat] {
        var returnTreat : [Treat] = []
        for t in treats {
            if t.category == category { returnTreat.append(t) }
        }
        
        return returnTreat
    }
    
}
