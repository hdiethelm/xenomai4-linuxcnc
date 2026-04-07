The following two drivers where found by `grep _OOB linux-evl/drivers/net/ethernet/*/Kconfig`

Note: FEC_OOB is for an embedded chip!

```
config FEC 
        tristate "FEC ethernet controller (of ColdFire and some i.MX CPUs)"

config FEC_OOB
        bool "Out-of-band support for FEC"
        depends on NET_OOB
        help
          Enable out-of-band I/O. Say Y if a companion kernel may divert
          the network traffic going through FEC devices for real-time delivery.
          Enabling this option makes sense only in a dual kernel configuration.
          If unsure, disable it.

config E1000E_OOB
       bool "Out-of-band support for Intel(R) e1000e Gigabit Ethernet"
       depends on E1000E && NET_OOB
       help
         Enable out-of-band I/O. Say Y if a companion kernel may divert
         the network traffic going through e1000e devices for real-time delivery.
         Enabling this option makes sense only in a dual kernel configuration.
         If unsure, disable it.


config IGB_OOB
       bool "Out-of-band support for Intel(R) 82575/82576 Gigabit Ethernet"
       depends on IGB && NET_OOB
       help
         Enable out-of-band I/O. Say Y if a companion kernel may divert
         the network traffic going through IGB devices for real-time delivery.
         Enabling this option makes sense only in a dual kernel configuration.
         If unsure, disable it.
```
