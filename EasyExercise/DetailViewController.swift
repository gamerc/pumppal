//
//  DetailViewController.swift
//  EasyExercise
//
//  Created by Charlie Gamer on 11/28/17.
//  Copyright © 2017 Charlie Gamer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var groupTextLabel: UITextField!
    @IBOutlet weak var repsTextLabel: UITextField!
    @IBOutlet weak var setsTextLabel: UITextField!
    @IBOutlet weak var restTimeTextLabel: UITextField!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    var exercises: Exercises?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if let exercises = exercises {
            self.updateUserInterface()
        } else {
            exercises = Exercises(exerciseTitle: "", exerciseGroup: "", exerciseReps: 0, exerciseSets: 0, restTime: "", details: "", placeDocumentID: "", postingUserID: "")
        }
        
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



//        do {
//            try exercises?.exerciseReps = Int(repsTextLabel.text!)!
//        } catch {
//            exercises?.exerciseReps = 0
//        }
//
//        switch setsTextLabel.text {
//        case nil:
//            exercises?.exerciseSets = 0
//        default:
//            exercises?.exerciseSets = Int(setsTextLabel.text!)!
//        }
        exercises?.exerciseReps = Int(repsTextLabel.text!)!
        exercises?.exerciseSets = Int(setsTextLabel.text!)!
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
    }
    
    @IBAction func groupDoneButtonPressed(_ sender: UITextField) {
        groupTextLabel.resignFirstResponder()
    }
    
    @IBAction func repsDoneButtonPressed(_ sender: UITextField) {
        repsTextLabel.resignFirstResponder()
    }
    
    @IBAction func restTimeDoneButtonPressed(_ sender: UITextField) {
        restTimeTextLabel.resignFirstResponder()
    }
    
    @IBAction func setsDoneButtonPressed(_ sender: UITextField) {
        setsTextLabel.resignFirstResponder()
    }
    
}
