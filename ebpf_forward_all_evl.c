#include <linux/types.h>
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <evl/net/bpf-abi.h>

SEC("socket")
int bpf_netrx(struct __sk_buff *skb)
{
	return EVL_RX_ACCEPT;
}

char _license[] SEC("license") = "GPL";
