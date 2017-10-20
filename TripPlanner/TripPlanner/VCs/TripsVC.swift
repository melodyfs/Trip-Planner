//
//  TripsVC.swift
//  TripPlanner
//
//  Created by Melody on 10/17/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import UIKit

class TripsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trips: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Networking.shared.fetch(route: .getUser, data: nil) { (data) in
            let trips = try? JSONDecoder().decode(Trip.self, from: data)
            print(trips!)
            guard let trip = trips?.trips else { return }
            
//            let trips = try? JSONDecoder().decode([NewTrip].self, from: data)
//            guard let trip = trips else {return}
//
            self.trips = trip
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    

}

extension TripsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripTableViewCell", for: indexPath) as! TripTableViewCell
        let trip = trips[indexPath.row]
        
        cell.destinationLabel.text = trip.destination
        cell.startDateLabel.text = trip.start_date
        cell.endDateLabel.text = trip.end_date
        
        return cell
    }
    
}

extension TripsVC: UITableViewDelegate {

}

