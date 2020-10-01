//
//  FBSpec.swift
//  FBModelTests
//
//  Created by Felipe Correia Brito on 16/09/20.
//  Copyright © 2020 Felipe Correia Brito. All rights reserved.
//

import Quick
import Nimble

@testable import FBModel

class FBSpec: QuickSpec {
    override func spec() {
        it("can be generated from JSON string") {
            let someModel = Intern.from("""
            {
                "test": 3.0
            }
            """)
            
            
            let genModel = Model.from("""
            {
                "text": "um texto",
                "number": 10,
                "another": {
                    "test": 2.0
                }
            }
            """)
            
            expect(someModel?.test).to(equal(3.0))
            
            expect(genModel).toNot(beNil())
            expect(genModel).to(equal(Model(text: "um texto", number: 10, another: .init(test: 2))))
        }
        
        it("can be compared") {
            let firstModel = Model(text: "um texto", number: 10, another: Intern(test: 2.0))
            let secondModel = Model(text: "um texto", number: 10, another: Intern(test: 2.0))
            let differentModel = Model(text: "diferente", number: 12, another: Intern(test: 1.0))
            
            expect(firstModel).to(equal(secondModel))
            expect(firstModel).toNot(equal(differentModel))
            
            print(firstModel.JSON)
            print(secondModel.JSON)
            print(differentModel.JSON)
        }
        
        it("generates a dictionary from model") {
            let someModel = Model(text: "algum texto", number: 12, another: Intern(test: 2))
            
            expect(someModel.dictionary["text"] as? String).to(equal(someModel.text))
            expect(someModel.dictionary["number"] as? Int).to(equal(someModel.number))
            expect(someModel.dictionary["another"] as? [String: AnyObject]).toNot(beNil())
            expect(someModel.dictionary["another"]?["test"]! as? Double).to(equal(2))
        }
        
        it("can decode with FBType") {
            let json = """
            {
                "someInt": "2",
                "someDouble": "2.0",
                "someString": "HUE",
                "someBool": "true"
            }
            """
            let model = StrangeModel.from(json)
            
            expect(model).toNot(beNil())
            expect(model?.someInt.int).to(equal(2))
            expect(model?.someDouble.double).to(equal(2.0))
            expect(model?.someString.string).to(equal("HUE"))
            expect(model?.someBool.bool).to(beTrue())
            /// Nesse caso queremos que seja nulo mesmo
            expect(model?.someOptional).to(beNil())
            /// E tbm consegue transformar os tipos
            expect(model?.someInt.string).to(equal("2"))
        }
        
        it("can encode with FBType and be compared to a version without FBType") {
            let strangeModel = StrangeModel(someInt: .int(2), someDouble: .double(1.2), someString: .string("huehue"), someBool: .bool(false), someOptional: nil)
            let notStrangeModel = NotStrangeModel(someInt: 2, someDouble: 1.2, someString: "huehue", someBool: false, someOptional: nil)
            /// devem gerar o mesmo json
            expect(strangeModel.JSON).to(equal(notStrangeModel.JSON))
            /// os structs com FBType devem ser capazes de gerar jsons validos para structs comuns
            expect(notStrangeModel).to(equal(NotStrangeModel.from(strangeModel.JSON)))
        }
    }
}

fileprivate struct Intern: FBModel {
    let test: Double
}

fileprivate struct Model: FBModel {
    let text: String
    let number: Int
    let another: Intern
}

fileprivate struct StrangeModel: FBModel {
    let someInt: FBType
    let someDouble: FBType
    let someString: FBType
    let someBool: FBType
    
    let someOptional: FBType?
}

fileprivate struct NotStrangeModel: FBModel {
    let someInt: Int
    let someDouble: Double
    let someString: String
    let someBool: Bool
    
    let someOptional: String?
}
