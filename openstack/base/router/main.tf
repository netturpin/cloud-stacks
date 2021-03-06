data "openstack_networking_network_v2" "network" {
  network_id = "${element(var.network_ids, count.index)}"
  count      = "${var.nb_network}"
}

resource "openstack_networking_router_v2" "router" {
  name = "${var.router_name}"
}

resource "openstack_networking_port_v2" "port" {
  name               = "${var.router_name}_${element(data.openstack_networking_network_v2.network.*.name, count.index)}"
  network_id         = "${element(var.network_ids, count.index)}"
  security_group_ids = "${var.secgroup_ids}"
  admin_state_up     = "true"
  count              = "${var.nb_network}"
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  port_id   = "${element(openstack_networking_port_v2.port.*.id, count.index)}"
  count     = "${var.nb_network}"
}
