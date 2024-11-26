#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# 描述: 自动构建 OpenWrt 以适用于 Amlogic s9xxx 电视盒
# 功能: 定制脚本 (更新 feeds 后，修改默认 IP、主机名、主题，添加/移除软件包等)
# 源代码仓库: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# 修改默认主题（从 uci-theme-bootstrap 改为 luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# 添加对 armvirt 的 autocore 支持
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile

# 设置 etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# 修改默认 IP（从 192.168.1.1 改为 192.168.31.4）
 sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 替换默认软件源
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# 添加 luci-app-amlogic
#svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic


# 修复 runc 版本错误
# rm -rf ./feeds/packages/utils/runc/Makefile
# svn export https://github.com/openwrt/packages/trunk/utils/runc/Makefile ./feeds/packages/utils/runc/Makefile

# coolsnowwolf 默认软件包替换为 Lienol 相关软件包
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini}
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# 添加第三方软件包（整个仓库）
# git clone https://github.com/libremesh/lime-packages.git package/lime-packages
# 添加第三方软件包（指定的包）
# svn co https://github.com/libremesh/lime-packages/trunk/packages/{shared-state-pirania,pirania-app,pirania} package/lime-packages/packages
# 添加到编译选项中（根据第三方软件包 Makefile 的要求添加相关依赖）
# sed -i "/DEFAULT_PACKAGES/ s/$/ pirania-app pirania ip6tables-mod-nat ipset shared-state-pirania uhttpd-mod-lua/" target/linux/armvirt/Makefile

# 应用补丁
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
