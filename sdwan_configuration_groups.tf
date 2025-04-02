resource "sdwan_configuration_group" "configuration_group" {
    for_each              = { for c in try(local.configuration_groups, {}) : c.name => c }
    name                  = each.value.name
    description           = try(each.value.description, "")
    solution              = try(each.value.solution, "sdwan")
    topology_site_devices = try(each.value.topology_site_devices, null)
    feature_profile_ids   = try(length(each.value.feature_profiles) == 0, true) ? null : concat([
        for f in each.value.feature_profiles : (
            f.type == "cli"       ? sdwan_cli_feature_profile.cli_feature_profile[f.name].id :
            f.type == "other"     ? sdwan_other_feature_profile.other_feature_profile[f.name].id :
            f.type == "transport" ? sdwan_transport_feature_profile.transport_feature_profile[f.name].id :
            f.type == "service"   ? sdwan_service_feature_profile.service_feature_profile[f.name].id :
            f.type == "system"    ? sdwan_system_feature_profile.system_feature_profile[f.name].id :
            null
        )
    ], [sdwan_policy_object_feature_profile.policy_object_feature_profile[0].id])
    topology_devices = try(length(each.value.topology_devices) == 0, true) ? null : [for t in each.value.topology_devices : {
        criteria_attribute   = try(t.criteria_attribute, null)
        criteria_value       = try(t.criteria_value, null)
        unsupported_features = try(length(t.unsupported_features) == 0, true) ? null : [for u in t.unsupported_features : (
            u.parcel_type == "wan/vpn/interface/ethernet" ? ({
                parcel_type = try(u.parcel_type)
                parcel_id = try(sdwan_transport_wan_vpn_interface_ethernet_feature.transport_wan_vpn_interface_ethernet_feature["${u.parcel_profile}-wan_vpn-${u.parcel_name}"].id, null)
            }) :
            u.parcel_type == "lan/vpn/interface/ethernet" ? ({
                parcel_type = try(u.parcel_type)
                parcel_id = try(sdwan_service_lan_vpn_interface_ethernet_feature.service_lan_vpn_interface_ethernet_feature["${u.parcel_profile}-lan_vpn-${u.parcel_name}"].id, null)
            }) :
            u.parcel_type == "lan/vpn" ? ({
                parcel_type = try(u.parcel_type)
                parcel_id = try(sdwan_service_lan_vpn_feature.service_lan_vpn_feature["${u.parcel_profile}-${u.parcel_name}"].id, null)
            }) :
            u.parcel_type == "routing/bgp" ? ({
                parcel_type = try(u.parcel_type)
                parcel_id = try(sdwan_service_routing_bgp_feature.service_routing_bgp_feature["${u.parcel_profile}-${u.parcel_name}"].id, null)
            }) :
            null
        )]
    }]
}