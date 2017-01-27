//
//  MyTodo.swift
//  MyTodoList
//
//  Created by otukutun on 1/27/17.
//  Copyright © 2017 otukutun. All rights reserved.
//

import Foundation

class MyTodo: NSObject, NSCoding {
    var todoTitle:String?
    var todoDone: Bool = false
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    func encode(with aCoder:NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}
