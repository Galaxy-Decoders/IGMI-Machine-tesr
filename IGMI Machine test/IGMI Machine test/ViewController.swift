//
//  ViewController.swift
//  IGMI Machine test
//
//  Created by Brijesh Ajudia on 02/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblSearch: UITableView!
    
    var searchModalClass: SearchTableModalClass?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableData()
    }
    
    // MARK: - SetUP Table Data
    func setUpTableData() {
        self.tblSearch.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: "TVCell")
        self.tblSearch.delegate = self
        self.tblSearch.dataSource = self
        
        self.tblSearch.backgroundColor = .white
        self.tblSearch.separatorStyle = .none
        self.tblSearch.tableHeaderView = UIView(frame: .zero)
        self.tblSearch.tableFooterView = UIView(frame: .zero)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getSearchTableData { isDatafetch in
            if isDatafetch {
                self.tblSearch.reloadData()
            }
        }
    }

}


//MARK: - API Calling
extension ViewController {
    func getSearchTableData(_ callback: ((_ isDatafetch: Bool) -> Void)?) {
        APIManager.sharedInstance.api_GetSearchtTableData { modalClass, error in
            if error != nil {
                print("<------ Error ------> ", error?.localizedDescription ?? "")
                callback?(false)
            }
            
            if modalClass != nil {
                self.searchModalClass = modalClass
                callback?(true)
            }
            else {
                print(msg_NoValidResponseInAPI)
                callback?(false)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchModalClass?.listed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath) as! TVCell
        
        let restObj = self.searchModalClass?.listed?[indexPath.row]
        
        cell.restTitle.text = restObj?.business_name ?? ""
        cell.restRateTitle.text = "\(restObj?.rating ?? "")" + "/5"
        cell.restDescTitle.text  = restObj?.description ?? ""
        
        cell.imgView.loadImageFromURL(themeURLString: restObj?.image ?? "")
        
        cell.imgView.setImageFromURL(imageString: restObj?.image ?? "") { imageFromURL in
            if let sdImage = imageFromURL {
                cell.imgView.image = sdImage
            }
        }
        
        cell.restLocationTitle.text = "Location: " + "\(restObj?.address ?? "")"
        cell.setUpTimeData(timeDataAll: restObj?.time_available)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let restObj = self.searchModalClass?.listed?[indexPath.row]
        
        
        let width = (UIScreen.main.bounds.width - CGFloat(8 + (5 * 8)))/CGFloat(5)
        let resu = ceil(Double(restObj?.time_available?.count ?? 0) / Double(5))
        let height = CGFloat((resu * Double(width)) + CGFloat(resu * 8))
        return height + 120 + 100 + 20
        
    }
    
    
}
