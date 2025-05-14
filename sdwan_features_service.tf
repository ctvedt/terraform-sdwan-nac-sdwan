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
  vpn                        = try(each.value.lan_vpn.vpn, null)
  config_description         = try(each.value.lan_vpn.config_description, null)
  omp_admin_distance_ipv4    = try(each.value.lan_vpn.omp_admin_distance_ipv4, null)
  omp_admin_distance_ipv6    = try(each.value.lan_vpn.omp_admin_distance_ipv6, null)
  # enable_sdwan_remote_access = false
  primary_dns_address_ipv4   = try(each.value.lan_vpn.primary_dns_address_ipv4, null)
  secondary_dns_address_ipv4 = try(each.value.lan_vpn.secondary_dns_address_ipv4, null)
  primary_dns_address_ipv6   = try(each.value.lan_vpn.primary_dns_address_ipv6, null)
  secondary_dns_address_ipv6 = try(each.value.lan_vpn.secondary_dns_address_ipv6, null)
  # host_mappings = [
  #   {
  #     host_name   = "HOSTMAPPING1"
  #     list_of_ips = ["1.2.3.4"]
  #   }
  # ]
  ipv4_static_routes = try(length(each.value.lan_vpn.ipv4_static_routes) == 0, true) ? null : [for route in each.value.lan_vpn.ipv4_static_routes : {
    administrative_distance          = try(route.administrative_distance, null)
    administrative_distance_variable = try("{{${route.administrative_distance_variable}}}", null)
    gateway                          = try(route.gateway, local.defaults.sdwan.feature_profiles.transport_profiles.wan_vpn.ipv4_static_routes.gateway)
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
  # ipv6_static_routes = [
  #   {
  #     prefix = "2001:0:0:1::0/12"
  #     next_hops = [
  #       {
  #         address                 = "2001:0:0:1::0"
  #         administrative_distance = 1
  #       }
  #     ]
  #   }
  # ]
  # services = [
  #   {
  #     service_type   = "FW"
  #     ipv4_addresses = ["1.2.3.4"]
  #     tracking       = true
  #   }
  # ]
  # service_routes = [
  #   {
  #     network_address = "1.2.3.4"
  #     subnet_mask     = "0.0.0.0"
  #     service         = "SIG"
  #     vpn             = 0
  #   }
  # ]
  # gre_routes = [
  #   {
  #     network_address = "1.2.3.4"
  #     subnet_mask     = "0.0.0.0"
  #     interface       = ["gre01"]
  #     vpn             = 0
  #   }
  # ]
  # ipsec_routes = [
  #   {
  #     network_address = "1.2.3.4"
  #     subnet_mask     = "0.0.0.0"
  #     interface       = ["ipsec01"]
  #   }
  # ]
  # nat_pools = [
  #   {
  #     nat_pool_name = 1
  #     prefix_length = 3
  #     range_start   = "1.2.3.4"
  #     range_end     = "2.3.4.5"
  #     overload      = true
  #     direction     = "inside"
  #   }
  # ]
  # nat_port_forwards = [
  #   {
  #     nat_pool_name        = 2
  #     source_port          = 122
  #     translate_port       = 330
  #     source_ip            = "1.2.3.4"
  #     translated_source_ip = "2.3.4.5"
  #     protocol             = "TCP"
  #   }
  # ]
  # static_nats = [
  #   {
  #     nat_pool_name        = 3
  #     source_ip            = "1.2.3.4"
  #     translated_source_ip = "2.3.4.5"
  #     static_nat_direction = "inside"
  #   }
  # ]
  # nat_64_v4_pools = [
  #   {
  #     name        = "NATPOOL1"
  #     range_start = "1.2.3.4"
  #     range_end   = "2.3.4.5"
  #     overload    = false
  #   }
  # ]
  # ipv4_import_route_targets = [
  #   {
  #     route_target = "1.1.1.3:200"
  #   }
  # ]
  # ipv4_export_route_targets = [
  #   {
  #     route_target = "1.1.1.3:200"
  #   }
  # ]
  # ipv6_import_route_targets = [
  #   {
  #     route_target = "1.1.1.3:200"
  #   }
  # ]
  # ipv6_export_route_targets = [
  #   {
  #     route_target = "1.1.1.3:200"
  #   }
  # ]
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
  name                            = each.value.interface.name
  description                     = try(each.value.interface.description, null)
  feature_profile_id              = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  service_lan_vpn_feature_id      = sdwan_service_lan_vpn_feature.service_lan_vpn_feature["${each.value.profile.name}-${each.value.lan_vpn.name}"].id
  shutdown                        = try(each.value.interface.shutdown, null)
  shutdown_variable               = try("{{${each.value.interface.shutdown_variable}}}", null)
  interface_name                  = try(each.value.interface.interface_name, null)
  interface_name_variable         = try("{{${each.value.interface.interface_name_variable}}}", null)
  interface_description           = try(each.value.interface.interface_description, null)
  interface_description_variable  = try("{{${each.value.interface.interface_description_variable}}}", null)
  ipv4_address                    = try(each.value.interface.ipv4_address, null)
  ipv4_address_variable           = try("{{${each.value.interface.ipv4_address_variable}}}", null)
  ipv4_subnet_mask                = try(each.value.interface.ipv4_subnet_mask, null)
  ipv4_subnet_mask_variable       = try("{{${each.value.interface.ipv4_subnet_mask_variable}}}", null)
  ipv4_dhcp_helper = try(length(each.value.interface.ipv4_dhcp_helper) == 0, true) ? null : [for helper in each.value.interface.ipv4_dhcp_helper : (
    helper.ip
  )]
  # ipv4_secondary_addresses = [
  #   {
  #     address     = "1.2.3.5"
  #     subnet_mask = "0.0.0.0"
  #   }
  # ]
  # ipv4_dhcp_helper = ["1.2.3.4"]
  # ipv6_dhcp_helpers = [
  #   {
  #     address           = "2001:0:0:1::0"
  #     dhcpv6_helper_vpn = 1
  #   }
  # ]
  # ipv4_nat               = false
  ipv4_nat_type          = try(each.value.interface.ipv4_nat_type, "pool")
  # ipv4_nat_range_start   = "1.2.3.4"
  # ipv4_nat_range_end     = "4.5.6.7"
  # ipv4_nat_prefix_length = 1
  # ipv4_nat_overload      = true
  # ipv4_nat_loopback      = "123"
  # ipv4_nat_udp_timeout   = 123
  # ipv4_nat_tcp_timeout   = 123
  # static_nats = [
  #   {
  #     source_ip    = "1.2.3.4"
  #     translate_ip = "2.3.4.5"
  #     direction    = "inside"
  #     source_vpn   = 0
  #   }
  # ]
  # ipv6_nat         = true
  # nat64            = false
  # acl_shaping_rate = 12
  # ipv6_vrrps = [
  #   {
  #     group_id  = 1
  #     priority  = 100
  #     timer     = 1000
  #     track_omp = false
  #     ipv6_addresses = [
  #       {
  #         link_local_address = "1::1"
  #         global_address     = "1::1/24"
  #       }
  #     ]
  #   }
  # ]
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
      # TODO: fix tracker_id as a lookup value
      # tracker_id               = try(sdwan_service_object_tracker_feature.service_object_tracker_feature["${each.value.profile.name}-${obj.name}"].id, null)
      tracker_id               = try(obj.id, null)
      tracker_action           = try(obj.action, null)
      tracker_action_variable  = try("{{${obj.tracker_action_variable}}}", null)
      decrement_value          = try(obj.decrement_value, null)
      decrement_value_variable = try("{{${obj.decrement_value_variable}}}", null)
    }]
  }]
  # arps = [
  #   {
  #     ip_address  = "1.2.3.4"
  #     mac_address = "00-B0-D0-63-C2-26"
  #   }
  # ]
  # trustsec_enable_sgt_propogation      = false
  # trustsec_propogate                   = true
  # trustsec_security_group_tag          = 123
  # trustsec_enable_enforced_propogation = false
  # trustsec_enforced_security_group_tag = 1234
  # duplex                               = "full"
  # mac_address                          = "00-B0-D0-63-C2-26"
  ip_mtu                 = try(each.value.interface.ip_mtu, null)
  interface_mtu          = try(each.value.interface.interface_mtu, null)
  tcp_mss                = try(each.value.interface.tcp_mss, null)
  # speed                                = "1000"
  # arp_timeout                          = 1200
  # autonegotiate                        = false
  # media_type                           = "auto-select"
  load_interval          = try(each.value.interface.load_interval, null)
  # tracker                              = "TRACKER1"
  # icmp_redirect_disable                = true
  # xconnect                             = "1"
  # ip_directed_broadcast                = false
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
  as_number_variable                = try("{{${each.value.bgp.as_number_vaiable}}}", null)
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
      in_route_policy_id                = try(sdwan_service_route_policy_feature.route_policy_feature["${each.value.profile.name}-${ipv4_neighbor_af.in_route_policy}"].id, null)
      max_number_of_prefixes            = try(ipv4_neighbor_af.max_number_of_prefixes, null)
      max_number_of_prefixes_variable   = try("{{${ipv4_neighbor_af.max_number_of_prefixes_variable}}}", null)
      out_route_policy_id               = try(sdwan_service_route_policy_feature.route_policy_feature["${each.value.profile.name}-${ipv4_neighbor_af.out_route_policy}"].id, null)
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
    route_policy_id        = try(sdwan_service_route_policy_feature.route_policy_feature["${each.value.profile.name}-${ipv4_redist.route_policy}"].id, null)
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

resource "sdwan_service_route_policy_feature" "route_policy_feature" {
  for_each = {
    for route_policy in flatten([
      for profile in try(local.feature_profiles.service_profiles, []) : [
        for policy in try(profile.route_policies, []) : {
          profile = profile
          policy = policy
        }
      ]
    ])
    : "${route_policy.profile.name}-${route_policy.policy.name}" => route_policy
  }
  name                     = each.value.policy.name
  description              = try(each.value.policy.description, null)
  feature_profile_id       = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  default_action           = try(each.value.policy.default_action, null)
  sequences = try(length(each.value.policy.sequences) == 0, true) ? null : [for s in each.value.policy.sequences : {
    id                     = try(s.id, null)
    name                   = try(s.name, null)
    base_action            = try(s.base_action, null)
    protocol               = try(s.protocol, null)
    match_entries = try(length(s.match_entries) == 0, true) ? null : flatten([
      [{
        bgp_local_preference            = try(s.match_entries.bgp_local_preference, null)
        ipv4_address_prefix_list_id     = try(sdwan_policy_object_ipv4_prefix_list.policy_object_ipv4_prefix_list[s.match_entries.ipv4_address_prefix_list].id, null)
        metric                          = try(s.match_entries.metric, null)
        omp_tag                         = try(s.match_entries.omp_tag, null)
        ospf_tag                        = try(s.match_entries.ospf_tag, null)
      }]
    ])
    actions = try(length(s.actions) == 0, true) ? null : flatten([
      [{
        as_path_prepend      = try(s.actions.as_path_prepend, null)
        community            = try(s.actions.community, null)
        community_additive   = try(s.actions.community_additive, null)
        community_variable   = try("{{${s.actions.community_variable}}}", null)
        ipv4_next_hop        = try(s.actions.ipv4_next_hop, null)
        ipv6_next_hop        = try(s.actions.ipv6_next_hop, null)
        local_preference     = try(s.actions.local_preference, null)
        metric               = try(s.actions.metric, null)
        metric_type          = try(s.actions.metric_type, null)
        omp_tag              = try(s.actions.omp_tag, null)
        origin               = try(s.actions.origin, null)
        ospf_tag             = try(s.actions.ospf_tag, null)
        weight               = try(s.actions.weight, null)
      }]
    ])
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