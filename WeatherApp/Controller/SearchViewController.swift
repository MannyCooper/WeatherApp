//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/28/21.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let networkModel = NetworkingModel()
    let databaseModel = DatabaseModel()
    
    var citiesInfoArray: [CityInfoModel] = [CityInfoModel]()

    @IBOutlet var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - SearchBar View

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count < 3 {
            self.citiesInfoArray.removeAll()
            self.tblView.reloadData()
            return
        }

        networkModel.getCityInfo(searchText)
            .done { citiesInfoArray in
                self.citiesInfoArray.removeAll()
                self.citiesInfoArray = citiesInfoArray
                self.tblView.reloadData()
            }
            .catch { error in
                print("SB Network Error:  \(error)")
            }
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell


        let city = citiesInfoArray[indexPath.row]
        
        cell.lblLocalizedName.text = city.localizedName
        cell.lblAreaCountry.text = city.administrativeID + ", " + city.countryLocalizedName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        databaseModel.addCityinDB(citiesInfoArray[indexPath.row])
        
        navigationController?.popViewController(animated: true)
    }
    
}
