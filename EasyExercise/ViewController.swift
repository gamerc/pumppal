//
//  ViewController.swift
//  EasyExercise
//
//  Created by Charlie Gamer on 11/28/17.
//  Copyright © 2017 Charlie Gamer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController {

    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutBarButtonItem: UIBarButtonItem!
    
    var exercises = [Exercises]()
    var authUI: FUIAuth!
    var db: Firestore!
    
    let exerciseMuscles = ["Biceps",
                           "Triceps",
                           "Chest",
                           "Shoulders",
                           "Back",
                           "Legs",
                           "Cardio",
                           "Abdominals",
                           "Miscellaneous"]
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        checkForUpdates()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
            ]
        
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
    }
    
    func checkForUpdates() {
        db.collection("exercises").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("Error: adding snapshot listener \(error!.localizedDescription)")
                return
            }
            self.loadData()
        }
    }
    
    func loadData() {
        db.collection("exercises").getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("error in reading documents \(error!.localizedDescription)")
                return
            }
            self.exercises = []
            for document in querySnapshot!.documents {
                let placeDocumentID = document.documentID
                let docData = document.data()
                let exerciseTitle = docData["exerciseTitle"] as! String? ?? ""
                let exerciseGroup = docData["exerciseGroup"] as! String? ?? ""
                let exerciseReps = docData["exerciseReps"] as! Int? ?? 0
                let exerciseSets = docData["exerciseSets"] as! Int? ?? 0
                let restTime = docData["restTime"] as! String? ?? ""
                let details = docData["details"] as! String? ?? ""
                let postingUserID = docData["postingUserID"] as! String? ?? ""
                self.exercises.append(Exercises(exerciseTitle: exerciseTitle, exerciseGroup: exerciseGroup, exerciseReps: exerciseReps, exerciseSets: exerciseSets, restTime: restTime, details: details, placeDocumentID: placeDocumentID, postingUserID: postingUserID))
 
            }
            self.tableView.reloadData()
        }
    }
    
    
    
    func deleteDataFile(index: Int) {
        
        let fileToDelete = db.collection("exercises").document(exercises[index].placeDocumentID)
        fileToDelete.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    
    func saveData(index: Int) {
        if let postingUserID = (authUI.auth?.currentUser?.email) {
            exercises[index].postingUserID = postingUserID
        } else {
            exercises[index].postingUserID = "unknown user"
        }
        
        let exerciseTitle = exercises[index].exerciseTitle
        let exerciseGroup = exercises[index].exerciseGroup
        let exerciseReps = exercises[index].exerciseReps
        let exerciseSets = exercises[index].exerciseSets
        let restTime = exercises[index].restTime
        let details = exercises[index].details
        
        
        let dataToSave: [String: Any] = ["exerciseTitle": exerciseTitle, "exerciseGroup": exerciseGroup, "postingUserID": exercises[index].postingUserID, "exerciseReps": exerciseReps, "exerciseSets": exerciseSets, "restTime": restTime, "details": details]
        
       
        if exercises[index].placeDocumentID != "" {
            let ref = db.collection("exercises").document(exercises[index].placeDocumentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("error - updating document \(error.localizedDescription)")
                } else {
                    print("document updated with reference id \(ref.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("exercises").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("error - adding document \(error.localizedDescription)")
                } else {
                    print("document added with reference id \(ref!.documentID)")
                    self.exercises[index].placeDocumentID = "\(ref!.documentID)"
                }
            }
        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            destination.exercises = exercises[selectedRow]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromLocationDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            exercises[selectedIndexPath.row] = (source.exercises)!
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData(index: selectedIndexPath.row)
        } else {
            let newIndexPath = IndexPath(row: exercises.count, section: 0)
            exercises.append((source.exercises)!)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            saveData(index: newIndexPath.row)
        }
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try authUI!.signOut()
            print("^^^ successfully signed in")
            signIn()
        } catch {
            print("couldn't sign out")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = exercises[indexPath.row].exerciseTitle
        cell.detailTextLabel?.text = exercises[indexPath.row].exerciseGroup
        cell.textLabel?.font = UIFont(name: "Futura", size: 17)
        cell.detailTextLabel?.font = UIFont(name: "Futura", size: 13)
        return cell
    }
    

    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return exerciseMuscles[section]
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return exerciseMuscles.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let height: CGFloat = 1
//        return height
//    }
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = UIColor.white
//        header.textLabel?.font = UIFont(name: "Futura", size: 22)
//        header.tintColor = UIColor.darkGray
//    }
}

extension ViewController: FUIAuthDelegate {
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
           print("*** successfully signed in with user = \(user.email!)")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInset: CGFloat = 16
        let imageY = self.view.center.y - 225
        
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInset, y: imageY, width: self.view.frame.width - (marginInset * 2), height: 225)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "image1")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        
        return loginViewController
    }
    
}

