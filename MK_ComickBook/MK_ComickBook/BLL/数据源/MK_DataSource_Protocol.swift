//
//  MK_DataSource_Protocol.swift
//  MK_ComickBook
//
//  Created by 杨尚达 on 2019/6/19.
//  Copyright © 2019 杨尚达. All rights reserved.
//

import Foundation

/*
 数据源协议
*/


/// 漫画详情数据协议
protocol MK_DataSource_ComickBookInfo_Protocol {
    
    ///作者
    var bookAuthor:String {get}
    
    ///漫画名称
    var bookName:String {get}
    
    ///漫画描述
    var bookDes:String {get}
    
    ///封面图URL
    var bookCoverImageURLStr:String {get}
    
    ///集数组
    var bookPartArray:[MK_DataSource_ComickPartInfo_Protocol] {get}
    
}


/// 漫画<话>数据协议
protocol MK_DataSource_ComickPartInfo_Protocol {
    
    ///话 标题
    var partTitle:String {get}
    
}
