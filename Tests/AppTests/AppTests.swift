@testable import App
import XCTVapor
import Testing

@Suite("App Tests")
struct AppTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await test(app)
        }
        catch {
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    @Test("Test default Route - Success")
    func sdefaultRoute_Success() async throws {
        try await withApp { app in
            try await app.test(.GET, "/", afterResponse: { res async in
                
                let expMessage = "The Hanoi Towers Problem Solver API. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
                
                #expect(res.status == .ok)
                #expect(res.body.string == expMessage)
            })
        }
    }
    
    @Test("Test solve bad Route - Algorithm Failure")
    func solve_badRoute_AlgParam_failure() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/X/3", afterResponse: { res async in
                
                let receivedResponse = try? decodeToDictionary(text: res.body.string)
                let expReason = "Missing solution algorithm query parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
                
                #expect(res.status == .badRequest)
                if let givenReason = receivedResponse?["reason"] as? String {
                    #expect(givenReason == expReason)
                }
            })
        }
    }
    
    @Test("Test solve Bad Route - Disks Param Failure")
    func solve_badRoute_DisksParam_failure() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/rec/d0", afterResponse: { res async in
                
                let receivedResponse = try? decodeToDictionary(text: res.body.string)
                let expReason = "Missing number of discs parameter. Usage: /solve/{ rec | iter | seq }/{ number_of_discs }"
                
                #expect(res.status == .badRequest)
                if let givenReason = receivedResponse?["reason"] as? String {
                    #expect(givenReason == expReason)
                }
            })
        }
    }
    
    @Test("Test solve Route - Disks Failure")
    func solve_recursive_failure() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/rec/33", afterResponse: { res async in
                
                let receivedResponse = try? decodeToDictionary(text: res.body.string)
                let expReason = "Wo wo wo!!! Don't be too greedy! 13 is the max number of Disks."
                
                #expect(res.status == .payloadTooLarge)
                if let givenReason = receivedResponse?["reason"] as? String {
                    #expect(givenReason == expReason)
                }
            })
        }
    }
    
    @Test("Test solve Route - Recursive Success")
    func solve_recursive_success() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/rec/3", afterResponse: { res async in
                
                let steps = try? decode(strData: res.body.string)
                #expect(res.status == .ok)
                if let step = steps?.first {
                    #expect(step.disk == 1)
                    #expect(step.sourceRod == "A")
                    #expect(step.destinationRod.description == "C")
                }
            })
        }
    }
    
    @Test("Test solve Route - Iterative Success")
    func solve_itertive_success() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/iter/3", afterResponse: { res async in
                
                let steps = try? decode(strData: res.body.string)
                #expect(res.status == .ok)
                if let step = steps?.first {
                    #expect(step.disk == 1)
                    #expect(step.sourceRod == "A")
                    #expect(step.destinationRod.description == "C")
                }
            })
        }
    }
    
    @Test("Test solve Route - Sequence Success")
    func solve_sequence_success() async throws {
        try await withApp { app in
            try await app.test(.GET, "solve/seq/3", afterResponse: { res async in
                
                let steps = try? decode(strData: res.body.string)
                #expect(res.status == .ok)
                if let step = steps?.first {
                    #expect(step.disk == 1)
                    #expect(step.sourceRod == "A")
                    #expect(step.destinationRod.description == "C")
                }
            })
        }
    }
    
    @Test("Test Solve Same Result - Success")
    func solve_success() async throws {
        try await withApp { app in
            
            var stepsRecursive: [SolutionStep] = []
            var stepsIterative: [SolutionStep] = []
            var stepsSequence:  [SolutionStep] = []
            try await app.test(.GET, "solve/rec/7" , afterResponse:{ res async in
                if let steps = try? decode(strData: res.body.string) {
                    stepsRecursive = steps
                }
            })
            try await app.test(.GET, "solve/iter/7" , afterResponse:{ res async in
                if let steps = try? decode(strData: res.body.string) {
                    stepsIterative = steps
                }
            })
            try await app.test(.GET, "solve/seq/7" , afterResponse:{ res async in
                if let steps = try? decode(strData: res.body.string) {
                    stepsSequence = steps
                }
            })
            
            #expect(stepsRecursive.first == stepsIterative.first)
            #expect(stepsRecursive.first == stepsSequence.first)
            
            #expect(stepsRecursive[3] == stepsIterative[3])
            #expect(stepsRecursive[3] == stepsSequence[3])
            
            #expect(stepsRecursive.last == stepsIterative.last)
            #expect(stepsRecursive.last == stepsSequence.last)

               
        }
    }
    
    @Test("Test Decode JSON - Success")
    func decode_success() throws {
        
        let str = """
[{"sourceRod":"A","disk":1,"destinationRod":"C"},{"sourceRod":"A","disk":2,"destinationRod":"B"},{"disk":1,"destinationRod":"B","sourceRod":"C"},{"destinationRod":"C","disk":3,"sourceRod":"A"},{"disk":1,"sourceRod":"B","destinationRod":"A"},{"sourceRod":"B","destinationRod":"C","disk":2},{"sourceRod":"A","destinationRod":"C","disk":1}]
"""
        let steps = try decode(strData: str)
        #expect(steps?.first?.disk == 1)
        #expect(steps?.first?.destinationRod == "C")
        #expect(steps?.last?.sourceRod == "A")
    }
    
    @Test("Test Decode Dictionary - Success")
    func decodeDictionary_success() throws {
        
        let str = """
{"reason":"something", "error": true}
"""
        let dict = try decodeToDictionary(text: str)
        if let reason = dict?["reason"] as? String {
            #expect(reason == "something")
        }
        if let error = dict?["error"] as? Bool {
            #expect(error == true)
        }
    }
    
    @Test("Test Decode JSON - Failure")
    func decode_failure() throws {
        
        let str = "[{\"fail\":13,\"x\":1}]"
        do {
            let _ = try decode(strData: str)
        } catch {
            #expect(error != nil)
        }
    }
    
    @Test("Test Decode Dictionary - Success")
    func decodeDictionary_failure() throws {
        
        let str = "[{\"fail\":13,\"x\":1}]"
        let dict = try decodeToDictionary(text: str)
        #expect(dict == nil)
    }
    
    private func decode(strData: String) throws -> [SolutionStep]? {
        if let json = strData.data(using: .utf8) {
            return try JSONDecoder().decode([SolutionStep].self, from: json)
        }
        return nil
    }
    
    private func decodeToDictionary(text: String) throws -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
        }
        return nil
    }
}
