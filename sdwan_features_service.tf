resource "sdwan_service_dhcp_server_feature" "service_dhcp_server_feature" {
  for_each = {
    for dhcp_server_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for dhcp_server in try(profile.dhcp_servers, []) : {
          profile     = profile
          dhcp_server = dhcp_server
        }
      ]
    ])
    : "${dhcp_server_item.profile.name}-${dhcp_server_item.dhcp_server.name}" => dhcp_server_item
  }
  name                     = each.value.dhcp_server.name
  description              = try(each.value.dhcp_server.description, null)
  feature_profile_id       = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  network_address          = try(each.value.dhcp_server.pool_network_address, null)
  network_address_variable = try("{{${each.value.dhcp_server.pool_network_address_variable}}}", null)
  subnet_mask              = try(each.value.dhcp_server.pool_subnet_mask, null)
  subnet_mask_variable     = try("{{${each.value.dhcp_server.pool_subnet_mask_variable}}}", null)
  default_gateway          = try(each.value.dhcp_server.default_gateway, null)
  default_gateway_variable = try("{{${each.value.dhcp_server.default_gateway_variable}}}", null)
  dns_servers              = try(each.value.dhcp_server.dns_servers, null)
  dns_servers_variable     = try("{{${each.value.dhcp_server.dns_servers_variable}}}", null)
  domain_name              = try(each.value.dhcp_server.domain_name, null)
  domain_name_variable     = try("{{${each.value.dhcp_server.domain_name_variable}}}", null)
  exclude                  = try(each.value.dhcp_server.exclude_addresses, null)
  exclude_variable         = try("{{${each.value.dhcp_server.exclude_addresses_variable}}}", null)
  interface_mtu            = try(each.value.dhcp_server.interface_mtu, null)
  interface_mtu_variable   = try("{{${each.value.dhcp_server.interface_mtu_variable}}}", null)
  lease_time               = try(each.value.dhcp_server.lease_time, null)
  lease_time_variable      = try("{{${each.value.dhcp_server.lease_time_variable}}}", null)
  tftp_servers             = try(each.value.dhcp_server.tftp_servers, null)
  tftp_servers_variable    = try("{{${each.value.dhcp_server.tftp_servers_variable}}}", null)
  option_codes = try(length(each.value.dhcp_server.options) == 0, true) ? null : [for option in each.value.dhcp_server.options : {
    ascii          = try(option.ascii, null)
    ascii_variable = try("{{${option.ascii_variable}}}", null)
    hex            = try(option.hex, null)
    hex_variable   = try("{{${option.hex_variable}}}", null)
    ip             = try(option.ip_addresses, null)
    ip_variable    = try("{{${option.ip_addresses_variable}}}", null)
    code           = try(option.code, null)
    code_variable  = try("{{${option.code_variable}}}", null)
  }]
  static_leases = try(length(each.value.dhcp_server.static_leases) == 0, true) ? null : [for lease in each.value.dhcp_server.static_leases : {
    ip_address           = try(lease.ip_address, null)
    ip_address_variable  = try("{{${lease.ip_address_variable}}}", null)
    mac_address          = try(lease.mac_address, null)
    mac_address_variable = try("{{${lease.mac_address_variable}}}", null)
  }]
}

resource "sdwan_service_tracker_group_feature" "service_tracker_group_feature" {
  for_each = {
    for tracker_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for tracker in try(profile.ipv4_tracker_groups, []) : {
          profile = profile
          tracker = tracker
        }
      ]
    ])
    : "${tracker_item.profile.name}-${tracker_item.tracker.name}" => tracker_item
  }
  name                     = each.value.tracker.name
  description              = try(each.value.tracker.description, null)
  feature_profile_id       = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  tracker_boolean          = try(each.value.tracker.tracker_boolean, null)
  tracker_boolean_variable = try("{{${each.value.tracker.tracker_boolean_variable}}}", null)
  tracker_elements = try(length(each.value.tracker.trackers) == 0, true) ? null : [for t in each.value.tracker.trackers : {
    tracker_id = sdwan_service_tracker_feature.service_tracker_feature["${each.value.profile.name}-${t}"].id
  }]
}

resource "sdwan_service_tracker_feature" "service_tracker_feature" {
  for_each = {
    for tracker_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for tracker in try(profile.ipv4_trackers, []) : {
          profile = profile
          tracker = tracker
        }
      ]
    ])
    : "${tracker_item.profile.name}-${tracker_item.tracker.name}" => tracker_item
  }
  name                      = each.value.tracker.name
  description               = try(each.value.tracker.description, null)
  feature_profile_id        = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  endpoint_api_url          = try(each.value.tracker.endpoint_url, null)
  endpoint_api_url_variable = try("{{${each.value.tracker.endpoint_url_variable}}}", null)
  endpoint_ip               = try(each.value.tracker.endpoint_ip, null)
  endpoint_ip_variable      = try("{{${each.value.tracker.endpoint_ip_variable}}}", null)
  endpoint_tracker_type     = "static-route"
  interval                  = try(each.value.tracker.interval, null)
  interval_variable         = try("{{${each.value.tracker.interval_variable}}}", null)
  multiplier                = try(each.value.tracker.multiplier, null)
  multiplier_variable       = try("{{${each.value.tracker.multiplier_variable}}}", null)
  port                      = try(each.value.tracker.endpoint_port, null)
  port_variable             = try("{{${each.value.tracker.endpoint_port_variable}}}", null)
  protocol                  = try(each.value.tracker.endpoint_protocol, null)
  protocol_variable         = try("{{${each.value.tracker.endpoint_protocol_variable}}}", null)
  threshold                 = try(each.value.tracker.threshold, null)
  threshold_variable        = try("{{${each.value.tracker.threshold_variable}}}", null)
  tracker_name              = try(each.value.tracker.tracker_name, null)
  tracker_name_variable     = try("{{${each.value.tracker.tracker_name_variable}}}", null)
  tracker_type              = "endpoint"
}

resource "sdwan_service_object_tracker_group_feature" "service_object_tracker_group_feature" {
  for_each = {
    for tracker_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for tracker in try(profile.object_tracker_groups, []) : {
          profile = profile
          tracker = tracker
        }
      ]
    ])
    : "${tracker_item.profile.name}-${tracker_item.tracker.name}" => tracker_item
  }
  name                       = each.value.tracker.name
  description                = try(each.value.tracker.description, null)
  feature_profile_id         = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  object_tracker_id          = try(each.value.tracker.id, null)
  object_tracker_id_variable = try("{{${each.value.tracker.id_variable}}}", null)
  reachable                  = try(each.value.tracker.tracker_boolean, null)
  reachable_variable         = try("{{${each.value.tracker.tracker_boolean_variable}}}", null)
  tracker_elements = try(length(each.value.tracker.trackers) == 0, true) ? null : [for t in each.value.tracker.trackers : {
    object_tracker_id = sdwan_service_object_tracker_feature.service_object_tracker_feature["${each.value.profile.name}-${t}"].id
  }]
}

resource "sdwan_service_object_tracker_feature" "service_object_tracker_feature" {
  for_each = {
    for tracker_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for tracker in try(profile.object_trackers, []) : {
          profile = profile
          tracker = tracker
        }
      ]
    ])
    : "${tracker_item.profile.name}-${tracker_item.tracker.name}" => tracker_item
  }
  name                       = each.value.tracker.name
  description                = try(each.value.tracker.description, null)
  feature_profile_id         = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  object_tracker_type        = each.value.tracker.type
  interface                  = try(each.value.tracker.interface_name, null)
  interface_variable         = try("{{${each.value.tracker.interface_name_variable}}}", null)
  object_tracker_id          = try(each.value.tracker.id, null)
  object_tracker_id_variable = try("{{${each.value.tracker.id_variable}}}", null)
  route_ip                   = try(each.value.tracker.route_ip, null)
  route_ip_variable          = try("{{${each.value.tracker.route_ip_variable}}}", null)
  route_mask                 = try(each.value.tracker.route_mask, null)
  route_mask_variable        = try("{{${each.value.tracker.route_mask_variable}}}", null)
  vpn                        = try(each.value.tracker.vpn_id, null)
  vpn_variable               = try("{{${each.value.tracker.vpn_id_variable}}}", null)
}

resource "sdwan_service_route_policy_feature" "service_route_policy_feature" {
  for_each = {
    for route_policy_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for route_policy in try(profile.route_policies, []) : {
          profile      = profile
          route_policy = route_policy
        }
      ]
    ])
    : "${route_policy_item.profile.name}-${route_policy_item.route_policy.name}" => route_policy_item
  }
  name               = each.value.route_policy.name
  description        = try(each.value.route_policy.description, null)
  feature_profile_id = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  default_action     = try(each.value.route_policy.default_action, null)
  sequences = try(length(each.value.route_policy.sequences) == 0, true) ? null : [for s in each.value.route_policy.sequences : {
    actions = try(length(s.actions) == 0, true) ? null : [for a in [s.actions] : {
      as_path_prepend    = try(a.prepend_as_paths, null)
      community          = try(a.communities, null)
      community_additive = try(a.communities_additive, null)
      community_variable = try("{{${a.communities_variable}}}", null)
      ipv4_next_hop      = try(a.ipv4_next_hop, null)
      ipv6_next_hop      = try(a.ipv6_next_hop, null)
      local_preference   = try(a.bgp_local_preference, null)
      metric             = try(a.metric, null)
      metric_type        = try(a.metric_type, null)
      omp_tag            = try(a.omp_tag, null)
      origin = try(
        a.origin == "igp" ? "IGP" :
        a.origin == "egp" ? "EGP" :
        a.origin == "incomplete" ? "Incomplete" : null,
        null
      )
      ospf_tag = try(a.ospf_tag, null)
      weight   = try(a.weight, null)
    }]
    base_action = s.base_action
    id          = s.id
    match_entries = try(length(s.match_entries) == 0, true) ? null : [for m in [s.match_entries] : {
      as_path_list_id                  = try(sdwan_policy_object_as_path_list.policy_object_as_path_list[m.as_path_list].id, null)
      bgp_local_preference             = try(m.bgp_local_preference, null)
      expanded_community_list_id       = try(sdwan_policy_object_expanded_community_list.policy_object_expanded_community_list[m.expanded_community_list].id, null)
      extended_community_list_id       = try(sdwan_policy_object_extended_community_list.policy_object_extended_community_list[m.extended_community_list].id, null)
      ipv4_address_prefix_list_id      = try(sdwan_policy_object_ipv4_prefix_list.policy_object_ipv4_prefix_list[m.ipv4_address_prefix_list].id, null)
      ipv4_next_hop_prefix_list_id     = try(sdwan_policy_object_ipv4_prefix_list.policy_object_ipv4_prefix_list[m.ipv4_next_hop_prefix_list].id, null)
      ipv6_address_prefix_list_id      = try(sdwan_policy_object_ipv6_prefix_list.policy_object_ipv6_prefix_list[m.ipv6_address_prefix_list].id, null)
      ipv6_next_hop_prefix_list_id     = try(sdwan_policy_object_ipv6_prefix_list.policy_object_ipv6_prefix_list[m.ipv6_next_hop_prefix_list].id, null)
      metric                           = try(m.metric, null)
      omp_tag                          = try(m.omp_tag, null)
      ospf_tag                         = try(m.ospf_tag, null)
      standard_community_list_criteria = try(upper(m.standard_community_lists_criteria), null)
      standard_community_lists = try(length(m.standard_community_lists) == 0, true) ? null : [for c in m.standard_community_lists : {
        id = try(sdwan_policy_object_standard_community_list.policy_object_standard_community_list[c].id, null)
      }]
    }]
    name     = try(s.name, local.defaults.sdwan.feature_profiles.service_profiles.route_policies.sequences.name)
    protocol = upper(try(s.protocol, local.defaults.sdwan.feature_profiles.service_profiles.route_policies.sequences.protocol))
  }]
}

resource "sdwan_service_lan_vpn_feature" "service_lan_vpn_feature" {
  for_each = {
    for lan_vpn_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for lan_vpn in try(profile.lan_vpns, []) : {
          profile     = profile
          lan_vpn     = lan_vpn
        }
      ]
    ])
    : "${lan_vpn_item.profile.name}-${lan_vpn_item.lan_vpn.name}" => lan_vpn_item
  }
  name                       = each.value.lan_vpn.name
  description                = try(each.value.lan_vpn.description, null)
  feature_profile_id         = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  config_description         = try(each.value.lan_vpn.config_description, null)
  enable_sdwan_remote_access = try(each.value.lan_vpn.enable_sdwan_remote_access, null)
  gre_routes = try(length(each.value.lan_vpn.gre_routes) == 0, true) ? null : [for route in each.value.lan_vpn.gre_routes : {
    interface                = try([route.interface], null)
    interface_variable       = try("{{${route.interface_variable}}}", null)
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
    vpn                      = try(route.vpn, null)
  }]
  host_mappings = try(length(each.value.lan_vpn.host_mappings) == 0, true) ? null : [for host in each.value.lan_vpn.host_mappings : {
    host_name            = try(host.hostname, null)
    host_name_variable   = try("{{${host.hostname_variable}}}", null)
    list_of_ips          = try(host.ips, null)
    list_of_ips_variable = try("{{${host.ips_variable}}}", null)
  }]
  ipsec_routes = try(length(each.value.lan_vpn.ipsec_routes) == 0, true) ? null : [for route in each.value.lan_vpn.ipsec_routes : {
    interface                = try([route.interface], null)
    interface_variable       = try("{{${route.interface_variable}}}", null)
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
  }]
  ipv4_export_route_targets = try(length(each.value.lan_vpn.ipv4_export_route_targets) == 0, true) ? null : [for rt in each.value.lan_vpn.ipv4_export_route_targets : {
    route_target           = try(rt.route_target, null)
    route_target_variable  = try("{{${rt.route_target_variable}}}", null)
  }]
  ipv4_import_route_targets = try(length(each.value.lan_vpn.ipv4_import_route_targets) == 0, true) ? null : [for rt in each.value.lan_vpn.ipv4_import_route_targets : {
    route_target           = try(rt.route_target, null)
    route_target_variable  = try("{{${rt.route_target_variable}}}", null)
  }]
  ipv4_static_routes = try(length(each.value.lan_vpn.ipv4_static_routes) == 0, true) ? null : [for route in each.value.lan_vpn.ipv4_static_routes : {
    administrative_distance          = try(route.administrative_distance, null)
    administrative_distance_variable = try("{{${route.administrative_distance_variable}}}", null)
    gateway                          = try(route.gateway, local.defaults.sdwan.feature_profiles.service_profiles.lan_vpn.ipv4_static_routes.gateway)
    null0                            = try(route.null0, null)
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    next_hop_with_trackers = try(length(route.next_hop_with_trackers) == 0, true) ? null : [for nht in route.next_hop_with_trackers : {
      address                          = try(nht.address, null)
      address_variable                 = try("{{${nht.address_variable}}}", null)
      administrative_distance          = try(nht.administrative_distance, null)
      administrative_distance_variable = try("{{${nht.administrative_distance_variable}}}", null)
      tracker_id                       = try(sdwan_service_tracker_feature.service_tracker_feature["${each.value.profile.name}-${nht.tracker}"].id, null)
    }]
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
  }]
  ipv6_export_route_targets = try(length(each.value.lan_vpn.ipv6_export_route_targets) == 0, true) ? null : [for rt in each.value.lan_vpn.ipv6_export_route_targets : {
    route_target           = try(rt.route_target, null)
    route_target_variable  = try("{{${rt.route_target_variable}}}", null)
  }]
  ipv6_import_route_targets = try(length(each.value.lan_vpn.ipv6_import_route_targets) == 0, true) ? null : [for rt in each.value.lan_vpn.ipv6_import_route_targets : {
    route_target           = try(rt.route_target, null)
    route_target_variable  = try("{{${rt.route_target_variable}}}", null)
  }]
  ipv6_static_routes = try(length(each.value.lan_vpn.ipv6_static_routes) == 0, true) ? null : [for route in each.value.lan_vpn.ipv6_static_routes : {
    nat = try(route.nat, null)
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
    }]
    gateway         = try(route.gateway, local.defaults.sdwan.feature_profiles.service_profiles.lan_vpn.ipv6_static_routes.gateway)
    null0           = try(route.null0, null)
    prefix          = try(route.prefix, null)
    prefix_variable = try("{{${route.prefix_variable}}}", null)
  }]
  nat_pools = try(length(each.value.lan_vpn.nat_pools) == 0, true) ? null : [for nat in each.value.lan_vpn.nat_pools : {
    direction              = try(nat.direction, null)
    direction_variable     = try("{{${nat.direction_variable}}}", null)
    nat_pool_name          = try(nat.nat_pool_name, null)
    nat_pool_name_variable = try("{{${nat.nat_pool_name_variable}}}", null)
    overload               = try(nat.overload, null)
    overload_variable      = try("{{${nat.overload_variable}}}", null)
    prefix_length          = try(nat.prefix_length, null)
    prefix_length_variable = try("{{${nat.prefix_length_variable}}}", null)
    range_end              = try(nat.range_end, null)
    range_end_variable     = try("{{${nat.range_end_variable}}}", null)
    range_start            = try(nat.range_start, null)
    range_start_variable   = try("{{${nat.range_start_variable}}}", null)
    tracker_object_id = try(
        sdwan_service_object_tracker_feature.service_object_tracker_feature["${each.value.profile.name}-${nat.tracker_object_id}"].id,
        sdwan_service_object_tracker_group_feature.service_object_tracker_group_feature["${each.value.profile.name}-${nat.tracker_object_id}"].id,
        null
      )
  }]
  nat_port_forwards = try(length(each.value.lan_vpn.nat_port_forwards) == 0, true) ? null : [for nat in each.value.lan_vpn.nat_port_forwards : {
    nat_pool_name                 = try(nat.nat_pool_name, null)
    nat_pool_name_variable        = try("{{${nat.nat_pool_name_variable}}}", null)
    protocol                      = try(nat.protocol, null)
    protocol_variable             = try("{{${nat.protocol_variable}}}", null)
    source_ip                     = try(nat.source_ip, null)
    source_ip_variable            = try("{{${nat.source_ip_variable}}}", null)
    source_port                   = try(nat.source_port, null)
    source_port_variable          = try("{{${nat.source_port_variable}}}", null)
    translate_port                = try(nat.translate_port, null)
    translate_port_variable       = try("{{${nat.translate_port_variable}}}", null)
    translated_source_ip          = try(nat.translated_source_ip, null)
    translated_source_ip_variable = try("{{${nat.translated_source_ip_variable}}}", null)
  }]
  omp_admin_distance_ipv4    = try(each.value.lan_vpn.omp_admin_distance_ipv4, null)
  omp_admin_distance_ipv6    = try(each.value.lan_vpn.omp_admin_distance_ipv6, null)
  primary_dns_address_ipv4   = try(each.value.lan_vpn.primary_dns_address_ipv4, null)
  primary_dns_address_ipv6   = try(each.value.lan_vpn.primary_dns_address_ipv6, null)
  secondary_dns_address_ipv4 = try(each.value.lan_vpn.secondary_dns_address_ipv4, null)
  secondary_dns_address_ipv6 = try(each.value.lan_vpn.secondary_dns_address_ipv6, null)
  service_routes = try(length(each.value.lan_vpn.service_routes) == 0, true) ? null : [for route in each.value.lan_vpn.service_routes : {
    network_address          = try(route.network_address, null)
    network_address_variable = try("{{${route.network_address_variable}}}", null)
    service                  = try(route.service, null)
    service_variable         = try("{{${route.service_variable}}}", null)
    subnet_mask              = try(route.subnet_mask, null)
    subnet_mask_variable     = try("{{${route.subnet_mask_variable}}}", null)
    vpn                      = try(route.vpn, null)
  }]
  services = try(length(each.value.lan_vpn.services) == 0, true) ? null : [for service in each.value.lan_vpn.services : {
    ipv4_addresses          = try(service.ipv4_addresses, null)
    ipv4_addresses_variable = try("{{${service.ipv4_addresses_variable}}}", null)
    service_type            = try(service.service_type, null)
    service_type_variable   = try("{{${service.service_type_variable}}}", null)
    tracking                = try(service.tracking, null)
    tracking_variable       = try("{{${service.tracking_variable}}}", null)
  }]
  static_nats = try(length(each.value.lan_vpn.static_nats) == 0, true) ? null : [for nat in each.value.lan_vpn.static_nats : {
    nat_pool_name                 = try(nat.nat_pool_name, null)
    nat_pool_name_variable        = try("{{${nat.nat_pool_name_variable}}}", null)
    source_ip                     = try(nat.source_ip, null)
    source_ip_variable            = try("{{${nat.source_ip_variable}}}", null)
    static_nat_direction          = try(nat.static_nat_direction, null)
    static_nat_direction_variable = try("{{${nat.static_nat_direction_variable}}}", null)
    tracker_object_id = try(
        sdwan_service_object_tracker_feature.service_object_tracker_feature["${each.value.profile.name}-${nat.tracker_object_id}"].id,
        sdwan_service_object_tracker_group_feature.service_object_tracker_group_feature["${each.value.profile.name}-${nat.tracker_object_id}"].id,
        null
      )
    translated_source_ip          = try(nat.translated_source_ip, null)
    translated_source_ip_variable = try("{{${nat.translated_source_ip_variable}}}", null)
  }]
  vpn = try(each.value.lan_vpn.vpn, null)
}

resource "sdwan_service_lan_vpn_interface_ethernet_feature" "service_lan_vpn_interface_ethernet_feature" {
  for_each = {
    for interface_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, {}) : [
        for lan_vpn in try(profile.lan_vpns, {}) : [
          for interface in try(lan_vpn.ethernet_interfaces, []) : {
            profile   = profile
            lan_vpn   = lan_vpn
            interface = interface
          }
        ]
      ]
    ])
    : "${interface_item.profile.name}-lan_vpn-${interface_item.interface.name}" => interface_item
  }
  name                       = each.value.interface.name
  description                = try(each.value.interface.description, null)
  feature_profile_id         = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  service_lan_vpn_feature_id = sdwan_service_lan_vpn_feature.service_lan_vpn_feature["${each.value.profile.name}-${each.value.lan_vpn.name}"].id
  acl_ipv4_egress_policy_id  =  null  # to be added when ACL is supported
  acl_ipv4_ingress_policy_id =  null  # to be added when ACL is supported
  acl_ipv6_egress_policy_id  =  null  # to be added when ACL is supported
  acl_ipv6_ingress_policy_id =  null  # to be added when ACL is supported
  acl_shaping_rate           = try(each.value.interface.shaping_rate, null)
  acl_shaping_rate_variable  = try("{{${each.value.interface.shaping_rate_variable}}}", null)
  arp_timeout                = try(each.value.interface.arp_timeout, null)
  arp_timeout_variable       = try("{{${each.value.interface.arp_timeout_variable}}}", null)
  arps = try(length(each.value.interface.arp_entries) == 0, true) ? null : [for arp in each.value.interface.arp_entries : {
    ip_address           = try(arp.ip_address, null)
    ip_address_variable  = try("{{${arp.ip_address_variable}}}", null)
    mac_address          = try(arp.mac_address, null)
    mac_address_variable = try("{{${arp.mac_address_variable}}}", null)
  }]
  autonegotiate                  = try(each.value.interface.autonegotiate, null)
  autonegotiate_variable         = try("{{${each.value.interface.autonegotiate_variable}}}", null)
  duplex                         = try(each.value.interface.duplex, null)
  duplex_variable                = try("{{${each.value.interface.duplex_variable}}}", null)
  enable_dhcpv6                  = try(each.value.interface.ipv6_configuration_type, local.defaults.sdwan.feature_profiles.service_profiles.lan_vpn.ethernet_interfaces.ipv6_configuration_type) == "dynamic" ? true : null
  icmp_redirect_disable          = try(each.value.interface.icmp_redirect_disable, null)
  icmp_redirect_disable_variable = try("{{${each.value.interface.icmp_redirect_disable_variable}}}", null)
  interface_description          = try(each.value.interface.interface_description, null)
  interface_description_variable = try("{{${each.value.interface.interface_description_variable}}}", null)
  interface_mtu                  = try(each.value.interface.interface_mtu, null)
  interface_mtu_variable         = try("{{${each.value.interface.interface_mtu_variable}}}", null)
  interface_name                 = try(each.value.interface.interface_name, null)
  interface_name_variable        = try("{{${each.value.interface.interface_name_variable}}}", null)
  ip_directed_broadcast          = try(each.value.interface.ip_directed_broadcast, null)
  ip_directed_broadcast_variable = try("{{${each.value.interface.ip_directed_broadcast_variable}}}", null)
  ip_mtu                         = try(each.value.interface.ip_mtu, null)
  ip_mtu_variable                = try("{{${each.value.interface.ip_mtu_variable}}}", null)
  ipv4_address                   = try(each.value.interface.ipv4_address, null)
  ipv4_address_variable          = try("{{${each.value.interface.ipv4_address_variable}}}", null)
  ipv4_dhcp_distance             = try(each.value.interface.ipv4_dhcp_distance, null)
  ipv4_dhcp_distance_variable    = try("{{${each.value.interface.ipv4_dhcp_distance_variable}}}", null)
  ipv4_dhcp_helper = try(length(each.value.interface.ipv4_dhcp_helper) == 0, true) ? null : [for helper in each.value.interface.ipv4_dhcp_helper : (
    helper.ip
  )]
  ipv4_dhcp_helper_variable       = try("{{${each.value.interface.ipv4_dhcp_helpers_variable}}}", null)
  ipv4_nat                        = try(each.value.interface.ipv4_nat, null)
  ipv4_nat_loopback               = try(each.value.interface.ipv4_nat_loopback_interface, null)
  ipv4_nat_loopback_variable      = try("{{${each.value.interface.ipv4_nat_loopback_interface_variable}}}", null)
  ipv4_nat_overload               = try(each.value.interface.ipv4_nat_pool_overload, null)
  ipv4_nat_overload_variable      = try("{{${each.value.interface.ipv4_nat_pool_overload_variable}}}", null)
  ipv4_nat_prefix_length          = try(each.value.interface.ipv4_nat_pool_prefix_length, null)
  ipv4_nat_prefix_length_variable = try("{{${each.value.interface.ipv4_nat_pool_prefix_length_variable}}}", null)
  ipv4_nat_range_end              = try(each.value.interface.ipv4_nat_pool_range_end, null)
  ipv4_nat_range_end_variable     = try("{{${each.value.interface.ipv4_nat_pool_range_end_variable}}}", null)
  ipv4_nat_range_start            = try(each.value.interface.ipv4_nat_pool_range_start, null)
  ipv4_nat_range_start_variable   = try("{{${each.value.interface.ipv4_nat_pool_range_start_variable}}}", null)
  ipv4_nat_tcp_timeout            = try(each.value.interface.ipv4_nat_tcp_timeout, null)
  ipv4_nat_tcp_timeout_variable   = try("{{${each.value.interface.ipv4_nat_tcp_timeout_variable}}}", null)
  ipv4_nat_type                   = try(each.value.interface.ipv4_nat_type, "pool")
  ipv4_nat_type_variable          = try("{{${each.value.interface.ipv4_nat_type_variable}}}", null)
  ipv4_nat_udp_timeout            = try(each.value.interface.ipv4_nat_udp_timeout, null)
  ipv4_nat_udp_timeout_variable   = try("{{${each.value.interface.ipv4_nat_udp_timeout_variable}}}", null)
  ipv4_secondary_addresses = try(length(each.value.interface.ipv4_secondary_addresses) == 0, true) ? null : [for a in each.value.interface.ipv4_secondary_addresses : {
    address              = try(a.address, null)
    address_variable     = try("{{${a.address_variable}}}", null)
    subnet_mask          = try(a.subnet_mask, null)
    subnet_mask_variable = try("{{${a.subnet_mask_variable}}}", null)
  }]
  ipv4_subnet_mask                               = try(each.value.interface.ipv4_subnet_mask, null)
  ipv4_subnet_mask_variable                      = try("{{${each.value.interface.ipv4_subnet_mask_variable}}}", null)
  ipv4_vrrps = try(length(each.value.interface.ipv4_vrrp_groups) == 0, true) ? null : [for group in each.value.interface.ipv4_vrrp_groups : {
    group_id              = try(group.id, null)
    group_id_variable     = try("{{${group.group_id_variable}}}", null)
    priority              = try(group.priority, null)
    priority_variable     = try("{{${group.priority_variable}}}", null)
    timer                 = try(group.timer, null)
    timer_variable        = try("{{${group.timer_variable}}}", null)
    track_omp             = try(group.track_omp, null)
    address               = try(group.address, null)
    address_variable      = try("{{${group.address_variable}}}", null)
    secondary_addresses   = try(length(group.secondary_addresses) == 0, true) ? null : [for adr in group.secondary_addresses : {
      address               = try(adr.address, null)
      address_variable      = try("{{${adr.address_variable}}}", null)
      subnet_mask           = try(adr.subnet_mask, null)
      subnet_mask_variable  = try("{{${adr.subnet_mask_variable}}}", null)
    }]
    tloc_prefix_change       = try(group.tloc_prefix_change, null)
    tloc_pref_change_value   = try(group.tloc_pref_change_value, null)
    tracking_objects = try(length(group.tracking_objects) == 0, true) ? null : [for obj in group.tracking_objects : {
      tracker_id = try(
        sdwan_service_object_tracker_feature.service_object_tracker_feature["${each.value.profile.name}-${obj.name}"].id,
        sdwan_service_object_tracker_group_feature.service_object_tracker_group_feature["${each.value.profile.name}-${obj.name}"].id,
        null
      )
      tracker_action           = try(obj.action, null)
      tracker_action_variable  = try("{{${obj.tracker_action_variable}}}", null)
      decrement_value          = try(obj.decrement_value, null)
      decrement_value_variable = try("{{${obj.decrement_value_variable}}}", null)
    }]
  }]
  ipv6_address          = try(each.value.interface.ipv6_address, null)
  ipv6_address_variable = try("{{${each.value.interface.ipv6_address_variable}}}", null)
  ipv6_secondary_addresses = try(try(each.value.interface.ipv6_configuration_type, local.defaults.sdwan.feature_profiles.service_profiles.lan_vpn.ethernet_interfaces.ipv6_configuration_type) == "static" && length(each.value.interface.ipv6_secondary_addresses) > 0, false) ? [for a in each.value.interface.ipv6_secondary_addresses : {
    address          = try(a.address, null)
    address_variable = try("{{${a.address_variable}}}", null)
  }] : null
  ipv6_dhcp_helpers = try(length(each.value.interface.ipv6_dhcp_helpers) == 0, true) ? null : [for helper in each.value.interface.ipv6_dhcp_helpers : {
    address              = try(helper.address, null)
    address_variable     = try("{{${helper.address_variable}}}", null)
    dhcpv6_helper_vpn             = try(helper.vpn_id, null)
    dhcpv6_helper_variable    = try("{{${helper.vpn_id_variable}}}", null)
  }]
  ipv6_nat = try(each.value.interface.ipv6_nat, null)
    ipv6_vrrps = try(length(each.value.interface.ipv6_vrrp_groups) == 0, true) ? null : [for group in each.value.interface.ipv6_vrrp_groups : {
    group_id              = try(group.id, null)
    group_id_variable     = try("{{${group.group_id_variable}}}", null)
    priority              = try(group.priority, null)
    priority_variable     = try("{{${group.priority_variable}}}", null)
    timer                 = try(group.timer, null)
    timer_variable        = try("{{${group.timer_variable}}}", null)
    track_omp             = try(group.track_omp, null)
    ipv6_addresses   = try(length(group.ipv6_addresses) == 0, true) ? null : [for adr in group.ipv6_addresses : {
      link_local_address               = try(adr.link_local_address, null)
      link_local_address_variable      = try("{{${adr.link_local_address_variable}}}", null)
      global_address           = try(adr.global_address, null)
      global_address_variable  = try("{{${adr.global_address_variable}}}", null)
    }]
  }]
  load_interval          = try(each.value.interface.load_interval, null)
  load_interval_variable = try("{{${each.value.interface.load_interval_variable}}}", null)
  mac_address            = try(each.value.interface.mac_address, null)
  mac_address_variable   = try("{{${each.value.interface.mac_address_variable}}}", null)
  media_type             = try(each.value.interface.media_type, null)
  media_type_variable    = try("{{${each.value.interface.media_type_variable}}}", null)
  nat64                  = try(each.value.interface.ipv6_nat64, null)
  shutdown               = try(each.value.interface.shutdown, null)
  shutdown_variable      = try("{{${each.value.interface.shutdown_variable}}}", null)
  speed                  = try(each.value.interface.speed, null)
  speed_variable         = try("{{${each.value.interface.speed_variable}}}", null)
  static_nats = try(length(each.value.interface.ipv4_nat_static_entries) == 0, true) ? null : [for nat in each.value.interface.ipv4_nat_static_entries : {
    direction              = try(nat.direction, null)
    source_ip              = try(nat.source_ip, null)
    source_ip_variable     = try("{{${nat.source_ip_variable}}}", null)
    source_vpn             = try(nat.source_vpn_id, null)
    source_vpn_variable    = try("{{${nat.source_vpn_id_variable}}}", null)
    translated_ip          = try(nat.translate_ip, null)
    translated_ip_variable = try("{{${nat.translate_ip_variable}}}", null)
  }]
  tcp_mss                                        = try(each.value.interface.tcp_mss, null)
  tcp_mss_variable                               = try("{{${each.value.interface.tcp_mss_variable}}}", null)
  tracker                                        = try(each.value.interface.tracker, null)
  tracker_variable                               = try("{{${each.value.interface.tracker_variable}}}", null)
  trustsec_enable_enforced_propogation           = try(each.value.interface.trustsec_enable_enforced_propogation, null)
  trustsec_enable_sgt_propogation                = try(each.value.interface.trustsec_enable_sgt_propogation, null)
  trustsec_enforced_security_group_tag           = try(each.value.interface.trustsec_enforced_security_group_tag, null)
  trustsec_enforced_security_group_tag_variable  = try("{{${each.value.interface.trustsec_enforced_security_group_tag_variable}}}", null)
  trustsec_propogate                             = try(each.value.interface.trustsec_propogate, null)
  trustsec_security_group_tag                    = try(each.value.interface.trustsec_security_group_tag, null)
  trustsec_security_group_tag_variable           = try("{{${each.value.interface.trustsec_security_group_tag_variable}}}", null)
  xconnect                                       = try(each.value.interface.gre_tloc_extension_xconnect, null)
  xconnect_variable                              = try("{{${each.value.interface.gre_tloc_extension_xconnect_variable}}}", null)
}

resource "sdwan_service_routing_bgp_feature" "service_routing_bgp_feature" {
  for_each = {
    for bgp_item in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for bgp in try(profile.bgp_features, []) : {
          profile = profile
          bgp = bgp
        }
      ]
    ])
    : "${bgp_item.profile.name}-${bgp_item.bgp.name}" => bgp_item
  }
  name                              = each.value.bgp.name
  always_compare_med                = try(each.value.bgp.always_compare_med, null)
  always_compare_med_variable       = try("{{${each.value.bgp.always_compare_med}}}", null)
  as_number                         = try(each.value.bgp.as_number, null)
  as_number_variable                = try("{{${each.value.bgp.as_number_variable}}}", null)
  compare_router_id                 = try(each.value.bgp.compare_router_id, null)
  compare_router_id_variable        = try("{{${each.value.bgp.compare_router_id_variable}}}", null)
  description                       = try(each.value.bgp.description, null)
  deterministic_med                 = try(each.value.bgp.deterministic_med, null)
  deterministic_med_variable        = try("{{${each.value.bgp.deterministic_med_variable}}}", null)
  external_routes_distance          = try(each.value.bgp.external_routes_distance, null)
  external_routes_distance_variable = try("{{${each.value.bgp.external_routes_distance_variable}}}", null)
  feature_profile_id                = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  hold_time                         = try(each.value.bgp.hold_time, null)
  hold_time_variable                = try("{{${each.value.bgp.hold_time_variable}}}", null)
  internal_routes_distance          = try(each.value.bgp.internal_routes_distance, null)
  internal_routes_distance_variable = try("{{${each.value.bgp.internal_routes_distance_variable}}}", null)
  ipv4_eibgp_maximum_paths          = try(each.value.bgp.ipv4_eibgp_maximum_paths, null)
  ipv4_eibgp_maximum_paths_variable = try("{{${each.value.bgp.ipv4_eibgp_maximum_paths_variable}}}", null)
  ipv4_originate                    = try(each.value.bgp.ipv4_originate, null)
  ipv4_originate_variable           = try("{{${each.value.bgp.ipv4_originate_variable}}}", null)
  keepalive_time                    = try(each.value.bgp.keepalive_time, null)
  keepalive_time_variable           = try("{{${each.value.bgp.keepalive_time_variable}}}", null)
  local_routes_distance             = try(each.value.bgp.local_routes_distance, null)
  local_routes_distance_variable    = try("{{${each.value.bgp.local_routes_distance_variable}}}", null)
  missing_med_as_worst              = try(each.value.bgp.missing_med_as_worst, null)
  missing_med_as_worst_variable     = try("{{${each.value.bgp.missing_med_as_worst_variable}}}", null)
  multipath_relax                   = try(each.value.bgp.multipath_relax, null)
  multipath_relax_variable          = try("{{${each.value.bgp.multipath_relax_variable}}}", null)
  propagate_as_path                 = try(each.value.bgp.propagate_as_path, null)
  propagate_as_path_variable        = try("{{${each.value.bgp.propagate_as_path_variable}}}", null)
  propagate_community               = try(each.value.bgp.propagate_community, null)
  propagate_community_variable      = try("{{${each.value.bgp.propagate_community_variable}}}", null)
  router_id                         = try(each.value.bgp.router_id, null)
  router_id_variable                = try("{{${each.value.bgp.router_id_variable}}}", null)
  ipv4_neighbors           = try(length(each.value.bgp.ipv4_neighbors) == 0, true) ? null : [for ipv4_neighbor in each.value.bgp.ipv4_neighbors : {
    address                           = try(ipv4_neighbor.address, null)
    address_variable                  = try("{{${ipv4_neighbor.address_variable}}}", null)
    allowas_in_number                 = try(ipv4_neighbor.allowas_in_number, null)
    allowas_in_number_variable        = try("{{${ipv4_neighbor.allowas_in_number_variable}}}", null)
    as_override                       = try(ipv4_neighbor.as_override, null)
    description                       = try(ipv4_neighbor.description, null)
    description_variable              = try("{{${ipv4_neighbor.description_variable}}}", null)
    ebgp_multihop                     = try(ipv4_neighbor.ebgp_multihop, null)
    ebgp_multihop_variable            = try("{{${ipv4_neighbor.ebgp_multihop_variable}}}", null)
    hold_time                         = try(ipv4_neighbor.hold_time, null)
    hold_time_variable                = try("{{${ipv4_neighbor.hold_time_variable}}}", null)
    keepalive_time                    = try(ipv4_neighbor.keepalive_time, null)
    keepalive_time_variable           = try("{{${ipv4_neighbor.keepalive_time_variable}}}", null)
    local_as                          = try(ipv4_neighbor.local_as, null)
    local_as_variable                 = try("{{${ipv4_neighbor.local_as_variable}}}", null)
    next_hop_self                     = try(ipv4_neighbor.next_hop_self, null)
    next_hop_self_variable            = try("{{${ipv4_neighbor.next_hop_self_variable}}}", null)
    password                          = try(ipv4_neighbor.password, null)
    password_variable                 = try("{{${ipv4_neighbor.password_variable}}}", null)
    remote_as                         = try(ipv4_neighbor.remote_as, null)
    remote_as_variable                = try("{{${ipv4_neighbor.remote_as_variable}}}", null)
    send_community                    = try(ipv4_neighbor.send_community, null)
    send_community_variable           = try("{{${ipv4_neighbor.send_community_variable}}}", null)
    send_extended_community           = try(ipv4_neighbor.send_extended_community, null)
    send_extended_community_variable  = try("{{${ipv4_neighbor.send_extended_community_variable}}}", null)
    send_label                        = try(ipv4_neighbor.send_label, null)
    send_label_variable               = try("{{${ipv4_neighbor.send_label_variable}}}", null)
    shutdown                          = try(ipv4_neighbor.shutdown, null)
    shutdown_variable                 = try("{{${ipv4_neighbor.shutdown_variable}}}", null)
    update_source_interface           = try(ipv4_neighbor.update_source_interface, null)
    update_source_interface_variable  = try("{{${ipv4_neighbor.update_source_interface_variable}}}", null)
    address_families = try(length(ipv4_neighbor.address_families) == 0, true) ? null : [for ipv4_neighbor_af in ipv4_neighbor.address_families : {
      family_type                       = try(ipv4_neighbor_af.family_type, null)
      in_route_policy_id                = try(sdwan_service_route_policy_feature.service_route_policy_feature["${each.value.profile.name}-${ipv4_neighbor_af.in_route_policy}"].id, null)
      max_number_of_prefixes            = try(ipv4_neighbor_af.max_number_of_prefixes, null)
      max_number_of_prefixes_variable   = try("{{${ipv4_neighbor_af.max_number_of_prefixes_variable}}}", null)
      out_route_policy_id               = try(sdwan_service_route_policy_feature.service_route_policy_feature["${each.value.profile.name}-${ipv4_neighbor_af.out_route_policy}"].id, null)
      policy_type                       = try(ipv4_neighbor_af.policy_type, null)
      restart_interval                  = try(ipv4_neighbor_af.restart_interval, null)
      restart_interval_variable         = try("{{${ipv4_neighbor_af.restart_interval_variable}}}", null)
      threshold                         = try(ipv4_neighbor_af.threshold, null)
      threshold_variable                = try("{{${ipv4_neighbor_af.threshold_variable}}}", null)
    }]
  }]
  ipv4_networks = try(length(each.value.bgp.ipv4_networks) == 0, true) ? null : [for ipv4_net in each.value.bgp.ipv4_networks : {
    network_address           = try(ipv4_net.network_address, null)
    network_address_variable  = try("{{${ipv4_net.network_address_variable}}}", null)
    subnet_mask               = try(ipv4_net.subnet_mask, null)
    subnet_mask_variable      = try("{{${ipv4_net.subnet_mask_variable}}}", null)
  }]
  ipv4_redistributes = try(length(each.value.bgp.ipv4_redistributes) == 0, true) ? null : [for ipv4_redist in each.value.bgp.ipv4_redistributes : {
    protocol               = try(ipv4_redist.protocol, null)
    protocol_variable      = try("{{${ipv4_redist.protocol_variable}}}", null)
    route_policy_id        = try(sdwan_service_route_policy_feature.service_route_policy_feature["${each.value.profile.name}-${ipv4_redist.route_policy}"].id, null)
  }]
  ipv4_aggregate_addresses = try(length(each.value.bgp.ipv4_aggregate_addresses) == 0, true) ? null : [for ipv4_aggregate in each.value.bgp.ipv4_aggregate_addresses : {
    as_set_path              = try(ipv4_aggregate.as_set_path, null)
    as_set_path_variable     = try("{{${ipv4_aggregate.as_set_path_variable}}}", null)
    network_address          = try(ipv4_aggregate.network_address, null)
    network_address_variable = try("{{${ipv4_aggregate.network_address_variable}}}", null)
    subnet_mask              = try(ipv4_aggregate.subnet_mask, null)
    subnet_mask_variable     = try("{{${ipv4_aggregate.subnet_mask_variable}}}", null)
    summary_only             = try(ipv4_aggregate.summary_only, null)
    summary_only_variable    = try("{{${ipv4_aggregate.summary_only_variable}}}", null)
  }]
}

resource "sdwan_service_lan_vpn_feature_associate_routing_bgp_feature" "lan_vpn_feature_associate_routing_bgp_feature" {
  for_each = {
    for bgp_association in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for association in try(profile.bgp_associations, []) : {
          profile = profile
          association = association
        }
      ]
    ])
    : "${bgp_association.profile.name}-${bgp_association.association.service_lan_vpn_feature}-${bgp_association.association.service_routing_bgp_feature}" => bgp_association
  }
  feature_profile_id             = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  service_lan_vpn_feature_id     = try(sdwan_service_lan_vpn_feature.service_lan_vpn_feature["${each.value.profile.name}-${each.value.association.service_lan_vpn_feature}"].id, null)
  service_routing_bgp_feature_id = try(sdwan_service_routing_bgp_feature.service_routing_bgp_feature["${each.value.profile.name}-${each.value.association.service_routing_bgp_feature}"].id, null)
}