//
//  SolutionRecursivePerformaceTests.swift
//  hanoi-towers-api
//
//  Created by Lord Jose Lopez on 29/10/24.
//

@testable import App
import XCTest

final class TestIterativePerformanceTests: XCTestCase {
    
    let controller = HanoiTowersIterativeController()
    
    func testPerformance_5_Disks() throws {
        measure {
            _ = controller.solve(disks: 5)
        }
    }
    
    func testPerformance_10_Disks() throws {
        measure {
            _ = controller.solve(disks: 10)
        }
    }
    
    func testPerformance_20_Disks() throws {
        measure {
            _ = controller.solve(disks: 20)
        }
    }
    
    func testPerformance_29_Disks() throws {
        measure {
            _ = controller.solve(disks: 29)
        }
    }
    
}
