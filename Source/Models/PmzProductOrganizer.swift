//
//  PmzProductOrganizer.swift
//  Alamofire
//
//  Created by Fennoma on 11/12/2020.
//

import Foundation

class PmzProductOrganizer {
    
    var groups: [PmzProductConfigurationGroup]?
    
    func setProduct(product: PmzProduct?) {
        if let configurations = product?.configurations {
            for config in configurations {
                let group = getLasGroup()
                if group.shouldAddConfiguration(config: config) {
                    group.addConfig(config: config)
                } else {
                    let newGroup = PmzProductConfigurationGroup()
                    groups?.append(newGroup)
                    newGroup.addConfig(config: config)
                }
            }
        }
    }
    
    func canUnselect(position: Int) -> Bool {
        var result = true
        if let group = getGroupByItem(position: position), group.configurations?.configurations?.count ?? 0 > 0, let sample = group.configurations?.configurations?[0] {
            if group.selections.count <= sample.minConfiguration ?? 0 {
                result = false
            }
        }
        return result
    }
    
    func addSelection(config: PmzProductConfiguration, position: Int) {
        if let group = getGroupByItem(position: position) {
            group.addOrRemoveConfig(config)
        }
    }

    func getLasGroup() -> PmzProductConfigurationGroup {
        if groups != nil {
            return groups![groups!.count - 1]
        } else {
            groups = [PmzProductConfigurationGroup]()
            let group = PmzProductConfigurationGroup()
            groups?.append(group)
            return group
        }
    }
    
    func size() -> Int {
        if groups == nil {
            return 0
        } else {
            var result = 0
            for group in groups! {
                result += group.size()
            }
            return result
        }
    }
    
    func onItemClicked(position: Int) -> [Int] {
        var results = [Int]()
        if let group = getGroupByItem(position: position), let configs = group.configurations?.configurations, configs.count > 0 {
            let sample = configs[0]
            let selections = getAmountOfSelections(group: group)
            if let maxSelections = sample.maxConfiguration, selections > maxSelections {
                let selectionsToRemove = selections - maxSelections
                for i in 0 ... selectionsToRemove - 1 {
                    let selection = group.selections[i]
                    results.append(getPositionByItem(item: selection))
                    selection.checked = false
                    group.selections.remove(at: i)
                }
            }
        }
        return results
    }
    
    func getPositionByItem(item: PmzProductConfiguration) -> Int {
        var result = 0
        if let groups = self.groups, let reference = item.id {
            for group in groups {
                if group.title != nil {
                    result += 1
                }
                if let configs = group.configurations?.configurations {
                    for config in configs {
                        if let index = config.id {
                            if index == reference {
                                return result
                            } else {
                                result += 1
                            }
                        }
                    }
                }
            }
        }
        return result
    }
    
    func getSelections(group: PmzProductConfigurationGroup) -> [PmzProductConfiguration] {
        var selections = [PmzProductConfiguration]()
        if let configs = group.configurations?.configurations {
           for config in configs {
               if config.isChecked() {
                    selections.append(config)
               }
           }
       }
        return selections
    }
    
    func getAmountOfSelections(group: PmzProductConfigurationGroup) -> Int {
        var result = 0
        if let configs = group.configurations?.configurations {
            for config in configs {
                if config.isChecked() {
                    result += 1
                }
            }
        }
        return result
    }
    
    func getGroupByItem(position: Int) -> PmzProductConfigurationGroup? {
        if groups != nil {
            var reference = position
            for group in groups! {
                if group.size() <= reference {
                    reference -= group.size()
                } else {
                    return group
                }
            }
        }
        return nil
    }
    
    func getItem(position: Int) -> PmzProductDisplayProtocol? {
        if groups != nil {
            var reference = position
            for group in groups! {
                if group.size() <= reference {
                    reference -= group.size()
                } else {
                    return group.getItem(position: reference)
                }
            }
        }
        return nil
    }
    
    func measureExtras() -> Double {
        var result: Double = 0
        if groups != nil {
            for group in groups! {
                result += group.measureExtras()
            }
        }
        return result
    }
    
    
    func getConfigurations() -> [PmzConfiguration] {
        var configs = [PmzConfiguration]()
        if let groups = groups {
            for group in groups {
                configs.append(contentsOf: group.getConfigurationsForJSON())
            }
        }
        return configs
    }
}
