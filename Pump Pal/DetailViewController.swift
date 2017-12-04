//
//  DetailViewController.swift
//  EasyExercise
//
//  Created by Charlie Gamer on 11/28/17.
//  Copyright © 2017 Charlie Gamer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var groupTextLabel: UITextField!
    @IBOutlet weak var repsTextLabel: UITextField!
    @IBOutlet weak var setsTextLabel: UITextField!
    @IBOutlet weak var restTimeTextLabel: UITextField!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    var exercises: Exercises?
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBarButtonItem.isEnabled = false
        detailsTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if let exercises = exercises {
            self.updateUserInterface()
            cancelBarButtonItem.title = "Back"
            saveBarButtonItem.title = "Update"
        } else {
            exercises = Exercises(exerciseTitle: "", exerciseGroup: "", exerciseReps: 0, exerciseSets: 0, restTime: "", details: "", placeDocumentID: "", postingUserID: "")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            detailsTextView.resignFirstResponder()
            saveBarButtonItem.isEnabled = true
            return false
        }
        return true
    }
    
    func updateUserInterface() {
        exerciseTextField.text = exercises!.exerciseTitle
        groupTextLabel.text = exercises!.exerciseGroup
        repsTextLabel.text = String(exercises!.exerciseReps)
        setsTextLabel.text = String(exercises!.exerciseSets)
        restTimeTextLabel.text = exercises!.restTime
        detailsTextView.text = exercises!.details
        creatorLabel.text = "Creator: \(exercises!.postingUserID)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        exercises?.exerciseReps = Int(repsTextLabel.text!) ?? 0
        exercises?.exerciseSets = Int(setsTextLabel.text!) ?? 0
        exercises?.exerciseTitle = exerciseTextField.text!
        exercises?.exerciseGroup = groupTextLabel.text!
        exercises?.restTime = restTimeTextLabel.text!
        exercises?.details = detailsTextView.text!


    }
    
    @IBAction func cancelBarButtonItemPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func exerciseDoneButtonPressed(_ sender: UITextField) {
        exerciseTextField.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func groupDoneButtonPressed(_ sender: UITextField) {
        groupTextLabel.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func repsDoneButtonPressed(_ sender: UITextField) {
        repsTextLabel.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func restTimeDoneButtonPressed(_ sender: UITextField) {
        restTimeTextLabel.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func setsDoneButtonPressed(_ sender: UITextField) {
        setsTextLabel.resignFirstResponder()
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func exerciseDidChange(_ sender: UITextField) {
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func groupDidChange(_ sender: UITextField) {
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func repsDidChange(_ sender: UITextField) {
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func setsDidChange(_ sender: UITextField) {
        saveBarButtonItem.isEnabled = true
    }
    
    @IBAction func restDidChange(_ sender: UITextField) {
        saveBarButtonItem.isEnabled = true
    }
    
    
    
}
