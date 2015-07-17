//
//  Episodios.swift
//  movileup
//
//  Created by iOS on 7/16/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Episodios: UITableView!
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
}
    

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
    //cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
    return cell
    }

}