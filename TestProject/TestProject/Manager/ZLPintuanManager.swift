//
//  ZLPintuanManager.swift
//  TestProject
//
//  Created by DanaLu on 2018/5/2.
//  Copyright © 2018年 gh. All rights reserved.
//

import UIKit

enum PintuanStatus: Int {
    case progressing = 0    //拼团中
    case success        //拼团成功
    case failed         //拼团失败
}

enum PintuanUIStatus: CustomStringConvertible {
    case uiprogressing  //拼团中
    case uisuccess      //拼团成功
    case uifailed       //拼团失败
    
    var description: String {
        switch self {
        case .uiprogressing:
            return "拼团中"
        case .uisuccess:
            return "拼团成功"
        case .uifailed:
            return "拼团失败"
        }
    }
}

enum TuanMemberRole {
    case creater        //团长
    case participator   //成员
    case others         //非参与者
}

enum PintuanType: Int {
    case waittingPay = 0    //拼团中 - 等待付款
    case memberNotFull  //拼团中 - 未满员
    case success        //拼团成功
    case notpayInTime   //拼团失败 - 未在有效时间内付款
    case notFullInTime  //拼团失败 - 未在有效时间内成团
}

enum  OrderStatus: Int {
    case OrderWaitingPaymentStatus = 0      //待付款
    case OrderWaitingShipmentsStatus     //待发货
    case OrderWaitingReceivingStatus     //待收货
    case OrderFinishedStatus             //完成
    case OrderClosedStatus                //关闭
}

struct PintuanParamter {
    var role: TuanMemberRole
    var orderStatus: OrderStatus
    var isPaid: Bool = false
    var pintuanType: PintuanType
    var remainingCount: Int
    var waitingForPayEndTime: String?
    var tuanEndTime: String?
}

extension PintuanParamter {
    init(_ createrUid: String,
         participatorUids: Array<String>,
         orderStatus: OrderStatus,
         pintuanStatus: PintuanStatus,
         remainCount: Int,
         payTime: String?,
         payEndTime: String?,
         tuanEndTime: String?) {
        role = PintuanParamter.getTuanMemberRole(createrUid, participatorUids: participatorUids)
        self.orderStatus = orderStatus
        self.remainingCount = remainCount
        if let isPaid = payTime?.isEmpty {
            self.isPaid = isPaid
        }
        self.pintuanType = PintuanParamter.getPintuanType(role, orderStatus: orderStatus, tuanStatus: pintuanStatus, isPaid: self.isPaid)
        self.remainingCount = remainCount
        self.waitingForPayEndTime = payEndTime
        self.tuanEndTime = tuanEndTime
    }
    
    init(_ createrUid: String,
         participatorUids: Array<String>,
         orderStatus: OrderStatus,
         pintuanStatus: PintuanStatus,
         remainCount: Int,
         payTime: String?) {
        self.init(createrUid, participatorUids: participatorUids, orderStatus: orderStatus, pintuanStatus: pintuanStatus, remainCount: remainCount, payTime: payTime, payEndTime: nil, tuanEndTime: nil)
    }
    
    static func getTuanMemberRole(_ createrUid: String,
                                  participatorUids: Array<String>) -> TuanMemberRole {
        let uid = ""
        if createrUid == uid {
            return .creater
        }
        
        if let _ = participatorUids.index(of: uid) {
            return .participator
        }
        
        return .others
    }
    
    static func getPintuanType(_ role: TuanMemberRole,
                               orderStatus: OrderStatus,
                               tuanStatus: PintuanStatus,
                               isPaid: Bool) -> PintuanType {
        var pintuanType: PintuanType = .memberNotFull
        switch tuanStatus {
        case .progressing:
            if isPaid {
                //拼团中，未满员
                pintuanType = .memberNotFull
            } else if orderStatus == .OrderWaitingPaymentStatus {
                //拼团中 - 待付款
                pintuanType = .waittingPay
            } else {
                //拼团失败 - 成员超时未支付
                pintuanType = .notpayInTime
            }
        case .success:
            if isPaid {
                //拼团成功
                pintuanType = .success
            } else if orderStatus == .OrderWaitingPaymentStatus {
                //拼团中 - 待付款
                pintuanType = .waittingPay
            } else {
                //拼团失败 - 成员超时未支付
                pintuanType = .notpayInTime
            }
        case .failed:
            if (role == .creater && !isPaid) {
                //拼团失败 - 未在有效时间内付款
                return .notpayInTime
            } else {
                //拼团失败 - 未在有效时间内成团
                return .notFullInTime
            }
        }
        
        return pintuanType
    }
}

protocol CustomTimer {
    var timer: ZLTime? { get set }
}

class ZLPintuanManager: NSObject {
    static func getPayResultTopDesc(_ tuanParamter: PintuanParamter) -> String {
        var statusDesc: String = ""
        
        switch tuanParamter.pintuanType {
        case .notpayInTime:
            statusDesc = "未在有效时间内付款"
        case .waittingPay:
            statusDesc = "已下单成功 待支付"
        case .memberNotFull:
            statusDesc = "还差\(tuanParamter.remainingCount)人，邀请好友参团"
        case .success:
            statusDesc = "已拼团成功"
        case .notFullInTime:
            //目前不存在这种情况.
            statusDesc = ""
        }
        
        return statusDesc
    }
    
    typealias ReturnAttributeStringBlock = (_ hasTimer: Bool,_ isStop: Bool , _ attributeString: NSAttributedString?) ->()
    static let remainTimeDisplayBlock = {(timeDesc: String) -> NSAttributedString in
        let attributedString = NSMutableAttributedString()
        let clockIconString = getIconAndStringAttributedString("grouper_time_gary", font: UIFont.sc(with: .regular, size: 12))
        attributedString.setAttributedString(clockIconString)
        
        let noticeAtt = getBaseAttributedString("剩余时间:", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
        attributedString.setAttributedString(noticeAtt)
        
        let endTimeAtt = getBaseAttributedString(timeDesc, font: UIFont.sc(with: .regular, size: 14), color: UIColor.getCommonColor(with: .ColorMainType))
        attributedString.setAttributedString(endTimeAtt)
        
        return attributedString
    }
    
    static func getPayResultUIStatusDesc(_ tuanParamter: PintuanParamter,
                                         customObj: inout CustomTimer,
                                         updateBlock: @escaping ReturnAttributeStringBlock) {
        var attributedString: NSAttributedString? = nil
        
        if tuanParamter.pintuanType == .notpayInTime {
            attributedString = getBaseAttributedString("未在有效时间内完成付款", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
        } else if tuanParamter.pintuanType == .memberNotFull || tuanParamter.pintuanType == .waittingPay {
            let endtime: String? = tuanParamter.pintuanType == .waittingPay ? tuanParamter.waitingForPayEndTime : tuanParamter.tuanEndTime;
            
            if customObj.timer != nil {
                customObj.timer?.stopTimer()
            }
            
            customObj.timer = ZLTime.startTimer(withTimerInterval: 1, endDateString: endtime, format: nil, responseHandler: { (time, isStoped) in
                let timeDesc = self.getRemainTimeDesc(time!)
                if tuanParamter.pintuanType == .waittingPay {
                    //请在**分内完成支付
                    attributedString = getBaseAttributedString("请在\(timeDesc)分内完成支付", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
                } else {
//                    attributedString = NSMutableAttributedString();
//                    let clockIconString = getIconAndStringAttributedString("grouper_time_gary", font: UIFont.sc(with: .regular, size: 12))
//                    attributedString?.setAttributedString(clockIconString)
//
//                    let noticeAtt = getBaseAttributedString("剩余时间:", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(noticeAtt)
//
//                    let endTimeAtt = getBaseAttributedString(timeDesc, font: UIFont.sc(with: .regular, size: 14), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(endTimeAtt)
                    
                    attributedString = remainTimeDisplayBlock(timeDesc)
                }
                
                updateBlock(true, isStoped, attributedString)
            })
        }
        
        updateBlock(false, true, attributedString)
    }
    
    static func getTuanDetailUIStatusDesc(_ tuanParamter: PintuanParamter,
                                          customObj: inout CustomTimer,
                                          updateBlock: @escaping ReturnAttributeStringBlock) {
        var attributedString: NSMutableAttributedString? = nil
        
        switch tuanParamter.pintuanType {
        case .notpayInTime:
            attributedString = NSMutableAttributedString();
            
            let clockIconString = getIconAndStringAttributedString("pt_warning_icon", font: UIFont.sc(with: .regular, size: 12))
            attributedString?.setAttributedString(clockIconString)
            
            let noticeAtt = getBaseAttributedString("拼团失败 未在有效时间内完成付款", font: UIFont.sc(with: .medium, size: 14), color: UIColor.init(hexString: "#F45050"))
            attributedString?.setAttributedString(noticeAtt)
        case .success:
            attributedString = getBaseAttributedString("拼团成功", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
        case .notFullInTime:
            attributedString = NSMutableAttributedString();
            let clockIconString = getIconAndStringAttributedString("pt_warning_icon", font: UIFont.sc(with: .regular, size: 12))
            attributedString?.setAttributedString(clockIconString)

            let noticeAtt = getBaseAttributedString("超过有限时间，拼团失败", font: UIFont.sc(with: .medium, size: 14), color: UIColor.init(hexString: "#F45050"))
            attributedString?.setAttributedString(noticeAtt)
        default:
            attributedString = nil
        }
        
        if tuanParamter.pintuanType == .memberNotFull || tuanParamter.pintuanType == .waittingPay {
            let endtime: String? = tuanParamter.pintuanType == .waittingPay ? tuanParamter.waitingForPayEndTime : tuanParamter.tuanEndTime;
            
            if customObj.timer != nil {
                customObj.timer?.stopTimer()
            }
            
            customObj.timer = ZLTime.startTimer(withTimerInterval: 1, endDateString: endtime, format: nil, responseHandler: { (time, isStoped) in
                let timeDesc = self.getRemainTimeDesc(time!)
                if tuanParamter.pintuanType == .waittingPay {
                    //请在**分内完成支付
                    attributedString = NSMutableAttributedString();
                    let clockIconString = getIconAndStringAttributedString("pt_warning_icon", font: UIFont.sc(with: .regular, size: 12))
                    attributedString?.setAttributedString(clockIconString)
                    
                    let noticeAtt = getBaseAttributedString("请在\(timeDesc)分内完成支付", font: UIFont.sc(with: .medium, size: 14), color: UIColor.init(hexString: "#F45050"))
                    attributedString?.setAttributedString(noticeAtt)
                } else {
                    let desc = "还差\(tuanParamter.remainingCount)人，\(timeDesc)后结束"
                    attributedString = getBaseAttributedString(desc, font: UIFont.sc(with: .medium, size: 14), color: UIColor.getCommonColor(with: .ColorMainType))
                    attributedString?.yy_setColor(UIColor.getCommonColor(with: .ColorOrderYellowType), range: NSString.init(string: desc).range(of: String(tuanParamter.remainingCount)))
                }
                
                updateBlock(true, isStoped, attributedString)
            })
        }
        
        updateBlock(false, true, attributedString)
    }
    
    static func getTuanDetailButtonTitle(_ tuanParamter: PintuanParamter) -> String {
        var buttonTitle: String
        
        switch tuanParamter.pintuanType {
        case .notpayInTime:
            if tuanParamter.role == .creater {
                buttonTitle = "重新开团"
            } else {
                buttonTitle = "重新参团"
            }
        case .success:
            buttonTitle = "查看订单详情"
        case .waittingPay:
            buttonTitle = "继续支付"
        case .memberNotFull:
            buttonTitle = "还差\(tuanParamter.remainingCount)人，邀请好友参团"
        case .notFullInTime:
            buttonTitle = "查看更多该商品拼团"
        }
        
        return buttonTitle
    }
    
    static func getOrderDetailUIStatusDesc(_ tuanParamter: PintuanParamter,
                                           customObj: inout CustomTimer,
                                           updateBlock: @escaping ReturnAttributeStringBlock) {
        var attributedString: NSAttributedString? = nil
        
        switch tuanParamter.pintuanType {
        case .notpayInTime:
            attributedString = getBaseAttributedString("未在有效时间内完成付款", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
        case .notFullInTime:
            attributedString = getBaseAttributedString("未在有效时间内成团", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
        default:
            attributedString = nil
        }
        
        if tuanParamter.pintuanType == .memberNotFull || tuanParamter.pintuanType == .waittingPay {
            let endtime: String? = tuanParamter.pintuanType == .waittingPay ? tuanParamter.waitingForPayEndTime : tuanParamter.tuanEndTime;
            
            if customObj.timer != nil {
                customObj.timer?.stopTimer()
            }
            
            customObj.timer = ZLTime.startTimer(withTimerInterval: 1, endDateString: endtime, format: nil, responseHandler: { (time, isStoped) in
                let timeDesc = self.getRemainTimeDesc(time!)
                if tuanParamter.pintuanType == .waittingPay {
                    //请在**分内完成支付
                    attributedString = getBaseAttributedString("请在\(timeDesc)分内完成支付", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .Color000000Type))
                } else {
//                    attributedString = NSMutableAttributedString();
//                    let clockIconString = getIconAndStringAttributedString("grouper_time_gary", font: UIFont.sc(with: .regular, size: 12))
//                    attributedString?.setAttributedString(clockIconString)
//
//                    let noticeAtt = getBaseAttributedString("剩余时间:", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(noticeAtt)
//
//                    let endTimeAtt = getBaseAttributedString(timeDesc, font: UIFont.sc(with: .regular, size: 14), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(endTimeAtt)
                    attributedString = remainTimeDisplayBlock(timeDesc)
                }
                
                updateBlock(true, isStoped, attributedString)
            })
        }
        
        updateBlock(false, true, attributedString)
    }
    
    static func getMyTuanListBottomDesc(_ tuanParamter: PintuanParamter) -> NSAttributedString? {
        var statusDesc: String
        
        switch tuanParamter.pintuanType {
        case .notpayInTime:
            statusDesc = "未完成支付，拼团失败"
        case .memberNotFull:
            statusDesc = "还差\(tuanParamter.remainingCount)人成团"
        case .notFullInTime:
            statusDesc = "超过有限时间，拼团失败"
        default:
            statusDesc = ""
        }
        
        if statusDesc.count > 0 {
            return getBaseAttributedString(statusDesc, font: UIFont.sc(with: .regular, size: 14), color: UIColor.getCommonColor(with: .ColorMiddleGrayType))
        }
        
        return nil
    }
    
    static func getMyTuanListTimeDesc(_ tuanParamter: PintuanParamter,
                                      customObj: inout CustomTimer,
                                      updateBlock: @escaping ReturnAttributeStringBlock) {
        var attributedString: NSAttributedString? = nil
        
        if tuanParamter.pintuanType == .memberNotFull || tuanParamter.pintuanType == .waittingPay {
            let endtime: String? = tuanParamter.pintuanType == .waittingPay ? tuanParamter.waitingForPayEndTime : tuanParamter.tuanEndTime;
            
            if customObj.timer != nil {
                customObj.timer?.stopTimer()
            }
            
            customObj.timer = ZLTime.startTimer(withTimerInterval: 1, endDateString: endtime, format: nil, responseHandler: { (time, isStoped) in
                let timeDesc = self.getRemainTimeDesc(time!)
                if tuanParamter.pintuanType == .waittingPay {
                    //请在**分内完成支付
                    attributedString = getBaseAttributedString("请在\(timeDesc)分内完成支付", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
                } else {
//                    attributedString = NSMutableAttributedString();
//                    let clockIconString = getIconAndStringAttributedString("grouper_time_gary", font: UIFont.sc(with: .regular, size: 12))
//                    attributedString?.setAttributedString(clockIconString)
//
//                    let noticeAtt = getBaseAttributedString("剩余时间:", font: UIFont.sc(with: .regular, size: 12), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(noticeAtt)
//
//                    let endTimeAtt = getBaseAttributedString(timeDesc, font: UIFont.sc(with: .regular, size: 14), color: UIColor.getCommonColor(with: .ColorMainType))
//                    attributedString?.setAttributedString(endTimeAtt)
                    
                    attributedString = remainTimeDisplayBlock(timeDesc)
                }
                
                updateBlock(true, isStoped, attributedString)
            })
        }
        
        updateBlock(false, true, nil)
    }
    
    // MARK: tool
    static func getBaseAttributedString(_ string: String,
                                        font: UIFont,
                                        color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedStringKey.font : font], range: NSRange(location: 0, length: string.count))
        attributedString.addAttributes([NSAttributedStringKey.foregroundColor : color], range: NSRange(location: 0, length: string.count))
        return attributedString
    }
    
    static func getIconAndStringAttributedString(_ iconName: String,
                                                 font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let iconImage = UIImage(named: iconName)
        let iconString = NSAttributedString.yy_attachmentString(withContent: iconImage, contentMode: .center, attachmentSize: (iconImage?.size)!, alignTo: font, alignment: .center)
        attributedString.setAttributedString(iconString)
        
        return attributedString
    }
    
    static func getRemainTimeDesc(_ time: ZLTime) -> String {
        var timeDesc: String = ""
        if time.day > 0 {
            timeDesc = String(format: "%02ld:", time.day)
        }
        
        if time.hour > 0 {
            timeDesc += String(format: "%02ld:", time.hour)
        } else {
            timeDesc += "00:"
        }
        
        if time.minute > 0 {
            timeDesc += String(format: "%02ld:", time.minute)
        } else {
            timeDesc += "00:"
        }
        
        if time.second > 0 {
            timeDesc += String(format: "%02ld:", time.second)
        } else {
            timeDesc += "00:"
        }
        
        return timeDesc
    }
}
