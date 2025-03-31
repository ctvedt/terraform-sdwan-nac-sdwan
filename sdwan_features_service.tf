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
    next_hops = try(length(route.next_hops) == 0, true) ? null : [for nh in route.next_hops : {
      address                          = try(nh.address, null)
      address_variable                 = try("{{${nh.address_variable}}}", null)
      administrative_distance          = try(nh.administrative_distance, null)
      administrative_distance_variable = try("{{${nh.administrative_distance_variable}}}", null)
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
  name                         = each.value.interface.name
  description                  = try(each.value.interface.description, null)
  feature_profile_id           = sdwan_service_feature_profile.service_feature_profile[each.value.profile.name].id
  service_lan_vpn_feature_id   = sdwan_service_lan_vpn_feature.service_lan_vpn_feature["${each.value.profile.name}-${each.value.lan_vpn.name}"].id
  shutdown                     = try(each.value.interface.shutdown, null)
  interface_name               = try(each.value.interface.interface_name, null)
  interface_description        = try(each.value.interface.interface_description, null)
  ipv4_address                 = try(each.value.interface.ipv4_address, null)
  ipv4_subnet_mask             = try(each.value.interface.ipv4_subnet_mask, null)
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
    priority              = try(group.priority, null)
    timer                 = try(group.timer, null)
    track_omp             = try(group.track_omp, null)
    address               = try(group.address, null)
    secondary_addresses   = try(length(group.secondary_addresses) == 0, true) ? null : [for adr in group.secondary_addresses : {
      address             = try(adr.address, null)
      subnet_mask         = try(adr.subnet_mask, null)
    }]
    tloc_prefix_change       = try(group.tloc_prefix_change, null)
    tloc_pref_change_value   = try(group.tloc_pref_change_value, null)
    tracking_objects = try(length(group.tracking_objects) == 0, true) ? null : [for obj in group.tracking_objects : {
      tracker_id               = try(obj.id, null)
      tracker_action           = try(obj.action, null)
      decrement_value          = try(obj.decrement_value, null)
    }]
  }]
  # ipv4_vrrps = [
  #   {
  #     group_id  = 1
  #     priority  = 100
  #     timer     = 1000
  #     track_omp = false
  #     address   = "1.2.3.4"
  #     secondary_addresses = [
  #       {
  #         address     = "2.3.4.5"
  #         subnet_mask = "0.0.0.0"
  #       }
  #     ]
  #     tloc_prefix_change     = true
  #     tloc_pref_change_value = 100
  #     tracking_objects = [
  #       {
  #         tracker_id      = "1b270f6d-479b-47e3-ab0b-51bc6811a303"
  #         tracker_action  = "Decrement"
  #         decrement_value = 100
  #       }
  #     ]
  #   }
  # ]
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