//
//  SolutionStep.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 28/10/24.
//

import Vapor

struct SolutionStep: Content, Equatable {
    let disk: Int
    let sourceRod: String
    let destinationRod: String
    
    static func == (lhs: SolutionStep, rhs: SolutionStep) -> Bool {
        lhs.disk == rhs.disk && lhs.sourceRod == rhs.sourceRod && lhs.destinationRod == rhs.destinationRod
    }
}
