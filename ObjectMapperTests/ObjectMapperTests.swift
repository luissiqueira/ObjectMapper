//
//  ObjectMapperTests.swift
//  ObjectMapperTests
//
//  Created by Tristan Himmelman on 2014-10-16.
//  Copyright (c) 2014 hearst. All rights reserved.
//

import Foundation
import XCTest
import ObjectMapper
import Nimble

class ObjectMapperTests: XCTestCase {

    let userMapper = Mapper<User>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicParsing() {
        let username = "John Doe"
        let identifier = "user8723"
        let photoCount = 13
        let age = 1227
        let weight = 123.23
        let float: Float = 123.231
        let drinker = true
        let smoker = false
  			let sex: Sex = .Female
        let arr = [ "bla", true, 42 ]
        let directory = [
            "key1" : "value1",
            "key2" : false,
            "key3" : 142
        ]
        
        let subUserJSON = "{\"identifier\" : \"user8723\", \"drinker\" : true, \"age\": 17, \"username\" : \"sub user\" }"
        
        let userJSONString = "{\"username\":\"\(username)\",\"identifier\":\"\(identifier)\",\"photoCount\":\(photoCount),\"age\":\(age),\"drinker\":\(drinker),\"smoker\":\(smoker), \"sex\":\"\(sex.rawValue)\", \"arr\":[ \"bla\", true, 42 ], \"dict\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"arrOpt\":[ \"bla\", true, 42 ], \"dictOpt\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"weight\": \(weight), \"float\": \(float), \"friend\": \(subUserJSON), \"friendDictionary\":{ \"bestFriend\": \(subUserJSON)}}"

		let user = userMapper.map(userJSONString)!
		
		expect(user).notTo(beNil())
		expect(username).to(equal(user.username))
		expect(identifier).to(equal(user.identifier))
		expect(photoCount).to(equal(user.photoCount))
		expect(age).to(equal(user.age))
		expect(weight).to(equal(user.weight))
		expect(float).to(equal(user.float))
		expect(drinker).to(equal(user.drinker))
		expect(smoker).to(equal(user.smoker))
		expect(sex).to(equal(user.sex))

		//println(Mapper().toJSONString(user, prettyPrint: true))
    }

    func testInstanceParsing() {
        let username = "John Doe"
        let identifier = "user8723"
        let photoCount = 13
        let age = 1227
        let weight = 123.23
        let float: Float = 123.231
        let drinker = true
        let smoker = false
			  let sex: Sex = .Female
        let arr = [ "bla", true, 42 ]
        let directory = [
            "key1" : "value1",
            "key2" : false,
            "key3" : 142
        ]
        
        let subUserJSON = "{\"identifier\" : \"user8723\", \"drinker\" : true, \"age\": 17, \"username\" : \"sub user\" }"
        
        let userJSONString = "{\"username\":\"\(username)\",\"identifier\":\"\(identifier)\",\"photoCount\":\(photoCount),\"age\":\(age),\"drinker\":\(drinker),\"smoker\":\(smoker), \"sex\":\"\(sex.rawValue)\", \"arr\":[ \"bla\", true, 42 ], \"dict\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 }, \"arrOpt\":[ \"bla\", true, 42 ], \"dictOpt\":{ \"key1\" : \"value1\", \"key2\" : false, \"key3\" : 142 },\"weight\": \(weight), \"float\": \(float), \"friend\": \(subUserJSON), \"friendDictionary\":{ \"bestFriend\": \(subUserJSON)}}"
        
        let user = Mapper().map(userJSONString, toObject: User())

		expect(username).to(equal(user.username))
		expect(identifier).to(equal(user.identifier))
		expect(photoCount).to(equal(user.photoCount))
		expect(age).to(equal(user.age))
		expect(weight).to(equal(user.weight))
		expect(float).to(equal(user.float))
		expect(drinker).to(equal(user.drinker))
		expect(smoker).to(equal(user.smoker))
		expect(sex).to(equal(user.sex))
        //println(Mapper().toJSONString(user, prettyPrint: true))
    }
    
    func testDictionaryParsing() {
        var name: String = "Genghis khan"
        var UUID: String = "12345"
        var major: Int = 99
        var minor: Int = 1
        let json: [String: AnyObject] = ["name": name, "UUID": UUID, "major": major]
        
        //Test that mapping a reference type works as expected while not relying on the return value
        var username: String = "Barack Obama"
        var identifier: String = "Political"
        var photoCount: Int = 1000000000
        
        let json2: [String: AnyObject] = ["username": username, "identifier": identifier, "photoCount": photoCount]
        let user = User()
        Mapper().map(json2, toObject: user)
		expect(user.username).to(equal(username))
		expect(user.identifier).to(equal(identifier))
		expect(user.photoCount).to(equal(photoCount))
    }
    
	func testNullObject() {
		let JSONString = "{\"username\":\"bob\"}"

		let user = userMapper.map(JSONString)
		expect(user).notTo(beNil())
		expect(user?.age).to(beNil())
	}
	
	func testToObjectFromString() {
		let username = "bob"
		let JSONString = "{\"username\":\"\(username)\"}"
		
		var user = User()
		user.username = "Tristan"
		
		Mapper().map(JSONString, toObject: user)

		expect(user.username).to(equal(username))
	}
	
	func testToObjectFromJSON() {
		let username = "bob"
		let JSON = ["username": username]
		
		var user = User()
		user.username = "Tristan"
		
		Mapper().map(JSON, toObject: user)

		expect(user.username).to(equal(username))
	}
	
	func testToObjectFromAnyObject() {
		let username = "bob"
		let userJSON = ["username": username]
		
		var user = User()
		user.username = "Tristan"
		
		Mapper().map(userJSON as AnyObject?, toObject: user)

		expect(user.username).to(equal(username))
	}
	
    func testToJSONAndBack(){
        var user = User()
        user.username = "tristan_him"
        user.identifier = "tristan_him_identifier"
        user.photoCount = 0
        user.age = 28
        user.weight = 150
        user.drinker = true
        user.smoker = false
			  user.sex = .Female
        user.arr = ["cheese", 11234]
        
        let JSONString = Mapper().toJSONString(user, prettyPrint: true)
        //println(JSONString)

		let parsedUser = userMapper.map(JSONString!)!
		expect(parsedUser).notTo(beNil())
		expect(user.identifier).to(equal(parsedUser.identifier))
		expect(user.photoCount).to(equal(parsedUser.photoCount))
		expect(user.age).to(equal(parsedUser.age))
		expect(user.weight).to(equal(parsedUser.weight))
		expect(user.drinker).to(equal(parsedUser.drinker))
		expect(user.smoker).to(equal(parsedUser.smoker))
		expect(user.sex).to(equal(parsedUser.sex))
    }

    func testUnknownPropertiesIgnored() {
        let JSONString = "{\"username\":\"bob\",\"identifier\":\"bob1987\", \"foo\" : \"bar\", \"fooArr\" : [ 1, 2, 3], \"fooObj\" : { \"baz\" : \"qux\" } }"

		let user = userMapper.map(JSONString)

		expect(user).notTo(beNil())
    }
    
    func testInvalidJsonResultsInNilObject() {
        let JSONString = "{\"username\":\"bob\",\"identifier\":\"bob1987\"" // missing ending brace

        let user = userMapper.map(JSONString)

		expect(user).to(beNil())
    }
	
	func testArrayOfCustomObjects(){
		let percentage1: Double = 0.1
		let percentage2: Double = 1792.41
		
		let JSONString = "{ \"tasks\": [{\"taskId\":103,\"percentage\":\(percentage1)},{\"taskId\":108,\"percentage\":\(percentage2)}] }"
		
		let plan = Mapper<Plan>().map(JSONString)

		let tasks = plan?.tasks
		expect(tasks).notTo(beNil())
		expect(tasks?[0].percentage).to(equal(percentage1))
		expect(tasks?[1].percentage).to(equal(percentage2))
	}

	func testDictionaryOfArrayOfCustomObjects(){
		let percentage1: Double = 0.1
		let percentage2: Double = 1792.41
		
		let JSONString = "{ \"dictionaryOfTasks\": { \"mondayTasks\" :[{\"taskId\":103,\"percentage\":\(percentage1)},{\"taskId\":108,\"percentage\":\(percentage2)}] } }"
		
		let plan = Mapper<Plan>().map(JSONString)
		
		let dictionaryOfTasks = plan?.dictionaryOfTasks
		expect(dictionaryOfTasks).notTo(beNil())
		expect(dictionaryOfTasks?["mondayTasks"]?[0].percentage).to(equal(percentage1))
		expect(dictionaryOfTasks?["mondayTasks"]?[1].percentage).to(equal(percentage2))
		
		let planToJSON = Mapper().toJSONString(plan!, prettyPrint: false)
		//println(planToJSON)
		let planFromJSON = Mapper<Plan>().map(planToJSON!)

		let dictionaryOfTasks2 = planFromJSON?.dictionaryOfTasks
		expect(dictionaryOfTasks2).notTo(beNil())
		expect(dictionaryOfTasks2?["mondayTasks"]?[0].percentage).to(equal(percentage1))
		expect(dictionaryOfTasks2?["mondayTasks"]?[1].percentage).to(equal(percentage2))
	}
	
	func testArrayOfEnumObjects(){
		let a: ExampleEnum = .A
		let b: ExampleEnum = .B
		let c: ExampleEnum = .C

		let JSONString = "{ \"enums\": [\(a.rawValue), \(b.rawValue), \(c.rawValue)] }"

		let enumArray = Mapper<ExampleEnumArray>().map(JSONString)
		let enums = enumArray?.enums
		expect(enums).notTo(beNil())
		expect(enums?.count).to(equal(3))
		expect(enums?[0]).to(equal(a))
		expect(enums?[1]).to(equal(b))
		expect(enums?[2]).to(equal(c))
	}

	func testDictionaryOfCustomObjects(){
		let percentage1: Double = 0.1
		let percentage2: Double = 1792.41
		
		let JSONString = "{\"tasks\": { \"task1\": {\"taskId\":103,\"percentage\":\(percentage1)}, \"task2\": {\"taskId\":108,\"percentage\":\(percentage2)}}}"
		
		let taskDict = Mapper<TaskDictionary>().map(JSONString)
		
		let task = taskDict?.tasks?["task1"]
		expect(task).notTo(beNil())
		expect(task?.percentage).to(equal(percentage1))
	}

	func testDictionryOfEnumObjects(){
		let a: ExampleEnum = .A
		let b: ExampleEnum = .B
		let c: ExampleEnum = .C

		let JSONString = "{ \"enums\": {\"A\": \(a.rawValue), \"B\": \(b.rawValue), \"C\": \(c.rawValue)} }"

		let enumDict = Mapper<ExampleEnumDictionary>().map(JSONString)
		let enums = enumDict?.enums
		expect(enums).notTo(beNil())
		expect(enums?.count).to(equal(3))
	}

	func testDoubleParsing(){
		let percentage1: Double = 1792.41
		
		let JSONString = "{\"taskId\":103,\"percentage\":\(percentage1)}"
		
		let task = Mapper<Task>().map(JSONString)

		expect(task).notTo(beNil())
		expect(task?.percentage).to(equal(percentage1))
	}

	func testToJSONArray(){
		var task1 = Task()
		task1.taskId = 1
		task1.percentage = 11.1
		var task2 = Task()
		task2.taskId = 2
		task2.percentage = 22.2
		var task3 = Task()
		task3.taskId = 3
		task3.percentage = 33.3
		
		var taskArray = [task1, task2, task3]
		
		let JSONArray = Mapper().toJSONArray(taskArray)
		
		let taskId1 = JSONArray[0]["taskId"] as? Int
		let percentage1 = JSONArray[0]["percentage"] as? Double

		expect(taskId1).to(equal(task1.taskId))
		expect(percentage1).to(equal(task1.percentage))

		let taskId2 = JSONArray[1]["taskId"] as? Int
		let percentage2 = JSONArray[1]["percentage"] as? Double
		
		expect(taskId2).to(equal(task2.taskId))
		expect(percentage2).to(equal(task2.percentage))

		let taskId3 = JSONArray[2]["taskId"] as? Int
		let percentage3 = JSONArray[2]["percentage"] as? Double
		
		expect(taskId3).to(equal(task3.taskId))
		expect(percentage3).to(equal(task3.percentage))
	}
}

class Status: Mappable {
	var status: Int?
	
	static func fromMap(map: Map) -> Mappable {
		let newObject = Status()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		status <- map["code"]
	}
}

class Plan: Mappable {
	var tasks: [Task]?
	var dictionaryOfTasks: [String: [Task]]?
	
	static func fromMap(map: Map) -> Mappable {
		let newObject = Plan()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		tasks <- map["tasks"]
		dictionaryOfTasks <- map["dictionaryOfTasks"]
	}
}

class Task: Mappable {
	var taskId: Int?
	var percentage: Double?

	init() {}
	
	static func fromMap(map: Map) -> Mappable {
		let newObject = Task()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		taskId <- map["taskId"]
		percentage <- map["percentage"]
	}
}

class TaskDictionary: Mappable {
	var test: String?
	var tasks: [String : Task]?
	
	static func fromMap(map: Map) -> Mappable {
		let newObject = TaskDictionary()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		test <- map["test"]
		tasks <- map["tasks"]
	}
}

enum Sex: String {
	case Male = "Male"
	case Female = "Female"
}

class User: Mappable {
    
    var username: String = ""
    var identifier: String?
    var photoCount: Int = 0
    var age: Int?
    var weight: Double?
    var float: Float?
    var drinker: Bool = false
    var smoker: Bool?
  	var sex: Sex?
    var arr: [AnyObject] = []
    var arrOptional: [AnyObject]?
    var dict: [String : AnyObject] = [:]
    var dictOptional: [String : AnyObject]?
	var dictString: [String : String]?
    var friendDictionary: [String : User]?
    var friend: User?
    var friends: [User]? = []
	

	init() {}

	static func fromMap(map: Map) -> Mappable {
		let newObject = User()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		username         <- map["username"]
		identifier       <- map["identifier"]
		photoCount       <- map["photoCount"]
		age              <- map["age"]
		weight           <- map["weight"]
		float            <- map["float"]
		drinker          <- map["drinker"]
		smoker           <- map["smoker"]
		sex              <- map["sex"]
		arr              <- map["arr"]
		arrOptional      <- map["arrOpt"]
		dict             <- map["dict"]
		dictOptional     <- map["dictOpt"]
		friend           <- map["friend"]
		friends          <- map["friends"]
		friendDictionary <- map["friendDictionary"]
		dictString		 <- map["dictString"]
	}
}

class ConcreteItem: Mappable {
	var value: String?

	static func fromMap(map: Map) -> Mappable {
		let newObject = ConcreteItem()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		value <- map["value"]
	}
}

enum ExampleEnum: Int {
	case A
	case B
	case C
}

class ExampleEnumArray: Mappable {
	var enums: [ExampleEnum] = []

	static func fromMap(map: Map) -> Mappable {
		let newObject = ExampleEnumArray()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		enums <- map["enums"]
	}
}

class ExampleEnumDictionary: Mappable {
	var enums: [String: ExampleEnum] = [:]

	static func fromMap(map: Map) -> Mappable {
		let newObject = ExampleEnumDictionary()
		newObject.mapping(map)
		return newObject
	}

	func mapping(map: Map) {
		enums <- map["enums"]
	}
}
