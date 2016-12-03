//
//  PerfectNoteOperator.swift
//  PerfectTemplate
//
//  Created by Mr.LuDashi on 2016/12/2.
//
//

import Foundation
import MySQL
import PerfectLogger
class BaseOperator {
     let dataBaseName = "perfect_note"
    var mysql: MySQL {
        get {
            return MySQLConnect.shareInstance(dataBaseName: dataBaseName)
        }
    }
    
}
class UserOperator: BaseOperator {
   
    let userTableName = "user"
    
    //MARK: - Insert User Info
    
    func queryUserInfo(userName: String) -> String? {
        let statement = "select userId from user where userName = '\(userName)'"
        LogFile.info("执行SQL:\(statement)")
        
        guard mysql.query(statement: statement) else {
            LogFile.error("\(statement)查询失败")
            return nil
        }
        
        LogFile.info("SQL:\(statement)查询成功")
        
        // 在当前会话过程中保存查询结果
        let results = mysql.storeResults()! //因为上一步已经验证查询是成功的，因此这里我们认为结果记录集可以强制转换为期望的数据结果。当然您如果需要也可以用if-let来调整这一段代码。
        
        var ary = [[String:String]]() //创建一个字典数组用于存储结果
        
        results.forEachRow { row in
            guard let userId = row.first! else {//保存选项表的Name名称字段，应该是所在行的第一列，所以是row[0].
                return
            }
            ary.append(["userId":"\(userId)"]) //保存到字典内
        }
        
        guard let josn = try? ary.jsonEncodedString() else {
            return nil
        }
        
        return josn
    }
    
    
    
    /// insert user info
    ///
    /// - Parameters:
    ///   - userName: 用户名
    ///   - password: 密码
    func insertUserInfo(userName: String, password: String) {
        let values = "('\(userName)', '\(password)')"
        let statement = "insert into \(userTableName) (username, password) values \(values)"
        LogFile.info("执行SQL:\(statement)")
        
        guard mysql.query(statement: statement) else {
            LogFile.error("\(statement)插入失败")
            return
        }
        
        LogFile.info("插入成功")
    }
}
