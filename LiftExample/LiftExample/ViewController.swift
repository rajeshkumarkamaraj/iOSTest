//
//  ViewController.swift
//  LiftExample
//
//  Created by Rajesh Kumar Kamaraj on 28/03/18.
//  Copyright © 2018 Rajesh Kumar Kamaraj. All rights reserved.
//

import UIKit

enum LiftPosition : Int {
    case stayingStill
    case goingUp
    case goingDown
}

enum LiftCalls : Int {
    case toGoUp = 0
    case toGoDown
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var FloorNumberTextField: UITextField!
    @IBOutlet weak var liftNumberLabel: UILabel!
    @IBOutlet weak var liftTableView: UITableView!
    
    let totalFloors = 10
    var liftArray : Array<Lift> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        liftTableView.delegate = self
        liftTableView.dataSource = self
        loadLift()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func upButtonAction(_ sender: Any) {
        guard let currentFloor = FloorNumberTextField.text else { return }
        if let lift : Lift = self.getnearByLiftWithDirection(LiftCalls.toGoUp, Int(currentFloor)!){
            liftNumberLabel.text = String(lift.liftNumber)
        }
    }
    
    @IBAction func downButtonAction(_ sender: Any) {
        guard let currentFloor = FloorNumberTextField.text else { return }
        if let lift : Lift = self.getnearByLiftWithDirection(LiftCalls.toGoDown, Int(currentFloor)!){
            liftNumberLabel.text = String(lift.liftNumber)
        }
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        liftArray.removeAll()
        loadLift()
    }
    
    func loadLift() {
        for index in 0...10 {
            let lift = Lift.init(index)
            liftArray.append(lift)
        }
        liftTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liftArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LiftTableViewCell", for: indexPath) as? LiftTableViewCell {
            let lift = liftArray[indexPath.row]
            cell.liftNumberLabel.text = "\(lift.liftNumber)"
            cell.currentFloorLabel.text = "\(lift.currentFloor)"
            var currentStatus = "Staying Still"
            if lift.liftPosition != LiftPosition.stayingStill {
                currentStatus = lift.liftPosition == .goingUp ? "Going Up" : "Going Down"
            }
            cell.currentStatusLabel.text = currentStatus
            return cell
        }
        return UITableViewCell()
    }
    
    func getnearByLiftWithDirection(_ toGo : LiftCalls, _ currentFloor : Int) -> Lift? {
        if currentFloor <= totalFloors {
            var filteredSet : [Lift]
            if toGo == .toGoUp {
                filteredSet = liftArray.filter({ (lift) -> Bool in
                    if  lift.liftPosition == LiftPosition.goingUp,lift.currentFloor < currentFloor {
                        return true
                    }
                    return false
                })
                filteredSet = filteredSet.sorted(by: { (lift1, lift2) -> Bool in
                    return lift1.currentFloor > lift2.currentFloor
                })
            } else {
                filteredSet = liftArray.filter({ (lift) -> Bool in
                    if  lift.liftPosition == LiftPosition.goingDown,lift.currentFloor > currentFloor {
                        return true
                    }
                    return false
                })
                filteredSet = filteredSet.sorted(by: { (lift1, lift2) -> Bool in
                    return lift1.currentFloor < lift2.currentFloor
                })
            }
            
            if filteredSet.isEmpty {
                filteredSet = liftArray.filter({ (lift) -> Bool in
                    if  lift.liftPosition == LiftPosition.stayingStill {
                        return true
                    }
                    return false
                })
            }
            return filteredSet.first
        }
        return nil
    }
    
}

struct Lift {
    var liftNumber : Int = 0
    var liftPosition : LiftPosition = LiftPosition(rawValue: Int(arc4random_uniform(2) + 1))!
    var currentFloor : Int = Int(arc4random_uniform(11))
    var floorsToStop : Array<Int> = []
    
    init(_ number : Int) {
        liftNumber = number
        if currentFloor == 0 {
            liftPosition = .stayingStill
        }
    }
}

class LiftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var liftNumberLabel: UILabel!
    @IBOutlet weak var currentFloorLabel: UILabel!
    @IBOutlet weak var currentStatusLabel: UILabel!
}

