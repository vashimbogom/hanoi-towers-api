//
//  HanoiTowersController.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 28/10/24.
//

protocol HanoiTowersController: AnyObject {
    func solve(disks: Int) -> [SolutionStep]
}
