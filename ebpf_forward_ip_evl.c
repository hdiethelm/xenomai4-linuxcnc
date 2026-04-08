#include <linux/types.h>
#include <linux/bpf.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/if_vlan.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>
#include <evl/net/bpf-abi.h>

#define OOB_UDP_PORT  42042

struct vlan_hdr {
	__be16	h_vlan_TCI;
	__be16	h_vlan_encapsulated_proto;
} __packed;

SEC("socket")
int bpf_netrx(struct __sk_buff *skb)
{
	struct vlan_hdr vhdr;
	struct iphdr iph;
	struct udphdr uh;
	__u16 protocol;
	int offset = 0;

	protocol = bpf_ntohs(skb->protocol);
	if (protocol == ETH_P_8021AD) {
			if (bpf_skb_load_bytes(skb, 0, &vhdr, sizeof(vhdr)))
					return EVL_RX_SKIP;
			offset = sizeof(vhdr);
			protocol = bpf_ntohs(vhdr.h_vlan_encapsulated_proto);
	}

	if (protocol == ETH_P_8021Q) {
			if (bpf_skb_load_bytes(skb, offset, &vhdr, sizeof(vhdr)))
					return EVL_RX_SKIP;
			offset += sizeof(vhdr);
			protocol = bpf_ntohs(vhdr.h_vlan_encapsulated_proto);
	}

	if (protocol != ETH_P_IP)
			return EVL_RX_SKIP;

	if (bpf_skb_load_bytes(skb, offset, &iph, sizeof(iph))) {
		bpf_printk("cannot load IP header");
			return EVL_RX_SKIP;
	}

	if (iph.version != 4)
			return EVL_RX_SKIP;

	return EVL_RX_ACCEPT;
}

char _license[] SEC("license") = "GPL";
