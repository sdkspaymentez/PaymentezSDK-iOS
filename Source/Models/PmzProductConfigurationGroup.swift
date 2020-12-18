//
//  PmzProductConfigurationGroup.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class PmzProductConfigurationGroup {
    
    var title: PmzTitleItem?
    var configurations: PmzConfigurationHolder?
    var selections: [PmzProductConfiguration]
    
    init() {
        selections = [PmzProductConfiguration]()
    }
    
    func shouldAddConfiguration(config: PmzProductConfiguration) -> Bool {
        if let title = title?.title  {
            return title == config.subtypeName
        }
        return true
    }
    
    func addOrRemoveConfig(_ config: PmzProductConfiguration) {
        let id = getIdIfRepeated(config)
        if id == -1 {
            self.selections.append(config)
        } else {
            self.selections.remove(at: id)
        }
    }
    
    func removeConfigIfPossible(_ config: PmzProductConfiguration) {
        let id = getIdIfRepeated(config)
        if id != -1 {
            self.selections.remove(at: id)
        }
    }
    
    func getIdIfRepeated(_ config: PmzProductConfiguration) -> Int {
        var result = -1
        if let reference = config.id {
            if selections.count > 0 {
                for i in 0 ... selections.count - 1 {
                    let selection = selections[i]
                    if let id = selection.id, id == reference {
                        result = i
                    }
                }
            }
        }
        return result
    }
    
    func addConfig(config: PmzProductConfiguration) {
        if configurations == nil {
            configurations = PmzConfigurationHolder()
        }
        if(config.isDefault != nil && config.isDefault!) {
            config.checked = true
            addOrRemoveConfig(config)
        } else if configurations?.configurations?.count == 0 {
            if config.minConfiguration != nil && config.minConfiguration! > 0 {
                config.checked = true
                addOrRemoveConfig(config)
            } else {
                config.checked = false
                removeConfigIfPossible(config)
            }
        } else {
            config.checked = false
            removeConfigIfPossible(config)
        }
        configurations?.add(config)
        if title == nil, let subtypeName = config.subtypeName {
            title = PmzTitleItem(subtypeName)
        }
    }
    
    func size() -> Int {
        /*if configurations == nil {
            return 0
        } else {
            var result = 0
            if title != nil {
                result += 1
            }
            if configurations != nil {
                result += 1
            }
            return result
        }*/
        if configurations == nil {
            return 0
        } else {
            var result = 0
            if title != nil {
                result += 1
            }
            if let configs = configurations?.configurations {
                result += configs.count
            }
            return result
        }
    }
    
    func getItem(position: Int) -> PmzProductDisplayProtocol? {
        /*if position == 0 {
            return title
        } else if configurations != nil && position == 1 {
            return configurations
        } else {
            return nil
        }*/
        if position == 0 {
            return title
        } else if configurations != nil {
            return configurations?.configurations![position - 1]
        } else {
            return nil
        }
    }
    
    func measureExtras() -> Double {
        var result: Double = 0
        if let configurations = configurations?.configurations {
            for config in configurations {
                if config.isChecked(), let extraPrice = config.extraPrice {
                    result += extraPrice
                }
            }
        }
        return result
    }
    
    func getConfigurationsForJSON() -> [PmzConfiguration] {
        var result = [PmzConfiguration]()
        if let configs = configurations?.configurations {
            for config in configs {
                if config.checked, let id = config.id {
                    result.append(PmzConfiguration(configId: id))
                }
            }
        }
        return result
    }
}
