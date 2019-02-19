//
//  ThemesViewController.swift
//  NunezJonathan_CE09
//
//  Created by Jonathan Nunez on 12/13/18.
//  Copyright © 2018 Jonathan Nunez. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    // MARK: Preparations
    @IBOutlet weak var colorDemoTableView: UITableView!
    
    // Sliders
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // Slider Labels
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    
    // Segment Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set title of page
        navigationItem.title = "Themes"
        
        // Build a border around the demo tableView
        colorDemoTableView.layer.masksToBounds = true
        colorDemoTableView.layer.borderColor = UIColor.black.cgColor
        colorDemoTableView.layer.borderWidth = 2.0
        
        colorDemoTableView.dataSource = self
        
        // Set all slider values to "1"
        for slider in [redSlider, greenSlider, blueSlider] {
            slider?.value = 1
        }
        // Set all sliderLabel values to "1"
        for label in [redLabel, greenLabel, blueLabel] {
            label?.text = "1"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = colorDemoTableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "Title"
        
        return cell
    }
    
    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        // Reset slider values to "1"
        for slider in [redSlider, greenSlider, blueSlider] {
            slider?.value = 1
        }
        // Reset sliderLabel values to "1"
        for label in [redLabel, greenLabel, blueLabel] {
            label?.text = "1"
        }
        // Reset the color of the demo tableView
        colorDemoTableView.backgroundColor = UIColor.white
        // Reset the color of the demo tableViewCell
        for cell in colorDemoTableView.visibleCells {
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.textLabel?.textColor = UIColor.black
        }
    }
    
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        switch sender.tag {
        case 0:
            // Red Slider
            // Update label
            redLabel.text = sender.value.description
        case 1:
            // Green Slider
            // Update label
            greenLabel.text = sender.value.description
        case 2:
            // Blue Slider
            // Update label
            blueLabel.text = sender.value.description
        default:
            print("")
        }
        // Call on segmentController identifier method
        colorBasedOnSegement()
        
    }
    
    func colorBasedOnSegement() {
        // Determine with segement was selected
        switch segmentControl.selectedSegmentIndex {
        case 0:
            // Update Table View color
            colorDemoTableView.layer.backgroundColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1).cgColor
        case 1:
            // Update Table Cell color
            for cell in colorDemoTableView.visibleCells {
                cell.layer.backgroundColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1).cgColor
            }
        case 2:
            // Update Table Text
            for cell in colorDemoTableView.visibleCells {
                cell.textLabel?.textColor = UIColor(displayP3Red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
            }
        default:
            print("")
        }
    }
    

}
