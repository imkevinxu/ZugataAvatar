//
//  ZAViewController.swift
//  ZugataAvatar
//
//  Created by Kevin Xu on 11/5/15.
//  Copyright © 2015 Kevin Xu. All rights reserved.
//

import UIKit
import SnapKit
import SwiftColors

// MARK: - Properties

final class ZAViewController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    let FIRST_TIME_LAUNCHED_KEY = "firstTimeLaunched"
    let NUMBER_OF_SIDES_KEY = "numberOfSides"
    let BORDER_WIDTH_KEY = "borderWidth"
    let BORDER_COLOR_KEY = "borderColor"
    let PICTURE_KEY = "picture"

    // MARK: IBOutlets

    @IBOutlet weak var avatarView: ZAAvatarView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var borderWidthLabel: UILabel!
    @IBOutlet weak var borderWidthSlider: UISlider!
    @IBOutlet weak var numberOfSidesLabel: UILabel!
    @IBOutlet weak var numberOfSidesSlider: UISlider!
}

// MARK: - View Lifecycle

extension ZAViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultValues()
    }

    private func setDefaultValues() {
        if !defaults.boolForKey(FIRST_TIME_LAUNCHED_KEY) {
            defaults.setBool(true, forKey: FIRST_TIME_LAUNCHED_KEY)
            defaults.setInteger(6, forKey: NUMBER_OF_SIDES_KEY)
            defaults.setInteger(10, forKey: BORDER_WIDTH_KEY)
            defaults.setObject("#007AFF", forKey: BORDER_COLOR_KEY)
            defaults.setObject(UIImagePNGRepresentation(UIImage(named: "profile")!), forKey: PICTURE_KEY)
            defaults.synchronize()
        }

        avatarView.numberOfSides = defaults.integerForKey(NUMBER_OF_SIDES_KEY)
        numberOfSidesLabel.text = "Number of Sides: \(defaults.integerForKey(NUMBER_OF_SIDES_KEY))"
        numberOfSidesSlider.value = Float(defaults.integerForKey(NUMBER_OF_SIDES_KEY))
        avatarView.borderWidth = CGFloat(defaults.integerForKey(BORDER_WIDTH_KEY))
        borderWidthLabel.text = "Border Width: \(defaults.integerForKey(BORDER_WIDTH_KEY))"
        borderWidthSlider.value = Float(defaults.integerForKey(BORDER_WIDTH_KEY))
        avatarView.borderColor = UIColor(hexString: defaults.objectForKey(BORDER_COLOR_KEY) as! String)
        colorLabel.text = "Color: \(defaults.objectForKey(BORDER_COLOR_KEY) as! String)"
        avatarView.picture = UIImage(data: defaults.objectForKey(PICTURE_KEY) as! NSData)
    }
}

// MARK: - User Interaction

extension ZAViewController {

    @IBAction func changeColorButtonTapped(sender: UIButton) {

        let alert = UIAlertController(title: "Change Color", message: "Enter a HEX value", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "#FFFFFF"
            textField.autocapitalizationType = .AllCharacters
        }

        let changeColorAction = UIAlertAction(title: "Change", style: .Default) { action in
            if let hexString = alert.textFields![0].text,
                   color = UIColor(hexString: hexString) {
                self.colorLabel.text = "Color: \(hexString)"
                self.avatarView.updateBorderColor(color)
                self.defaults.setObject(hexString, forKey: self.BORDER_COLOR_KEY)
                self.defaults.synchronize()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        alert.addAction(changeColorAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func borderWidthSliderChanged(slider: UISlider) {
        borderWidthLabel.text = "Border Width: \(Int(slider.value))"
        avatarView.updateBorderWidth(CGFloat(Int(slider.value)))
        defaults.setInteger(Int(slider.value), forKey: BORDER_WIDTH_KEY)
        defaults.synchronize()
    }

    @IBAction func numberOfSidesSliderChanged(slider: UISlider) {
        numberOfSidesLabel.text = "Number of Sides: \(Int(slider.value))"
        avatarView.updateNumberOfSides(Int(slider.value))
        defaults.setInteger(Int(slider.value), forKey: NUMBER_OF_SIDES_KEY)
        defaults.synchronize()
    }

    @IBAction func randomCatButtonTapped(sender: UIButton) {
        avatarView.updatePictureWithURL(NSURL(string: "https://theoldreader.com/kittens/200/200")!)
    }
}