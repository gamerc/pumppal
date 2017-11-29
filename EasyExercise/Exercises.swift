//
//  Exercises.swift
//  EasyExercise
//
//  Created by Charlie Gamer on 11/28/17.
//  Copyright © 2017 Charlie Gamer. All rights reserved.
//

import Foundation

class Exercises {
    
    var exerciseTitle: String
    var exerciseGroup: String
    var exerciseReps: Int
    var exerciseSets: Int
    var restTime: String
    var details: String
    var placeDocumentID: String
    var postingUserID: String
    
    init(exerciseTitle: String, exerciseGroup: String, exerciseReps: Int, exerciseSets: Int, restTime: String, details: String, placeDocumentID: String, postingUserID: String) {
        self.exerciseTitle = exerciseTitle
        self.exerciseGroup = exerciseGroup
        self.exerciseReps = exerciseReps
        self.exerciseSets = exerciseSets
        self.restTime = restTime
        self.details = details
        self.placeDocumentID = placeDocumentID
        self.postingUserID = postingUserID
    }
}
