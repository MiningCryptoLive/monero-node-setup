(cat <<EOF
set -x
mkdir ~/wallets
cd ~/wallets
sudo nano wallet_pass

echo 1 | /usr/local/src/monero/build/release/bin/monero-wallet-cli --offline --create-address-file --generate-new-wallet ~/wallets/wallet --password-file ~/wallets/wallet_pass --command address
echo 1 | /usr/local/src/monero/build/release/bin/monero-wallet-cli --offline --create-address-file --generate-new-wallet ~/wallets/wallet_fee --password-file ~/wallets/wallet_pass --command address
EOF
) | su user -l
echo; echo; echo
read -p "*** Write down your seeds for wallet and wallet_fee listed above and press ENTER to continue ***"

cat >/lib/systemd/system/monero.service <<'EOF'
[Unit]
Description=Monero Daemon
After=network.target

[Service]
ExecStart=/usr/local/src/monero/build/release/bin/monerod --hide-my-port --prune-blockchain --enable-dns-blocklist --no-zmq --out-peers 64 --non-interactive --restricted-rpc --block-notify '/bin/bash /home/user/nodejs-pool/block_notify.sh'
Restart=always
User=monerodaemon
Nice=10
CPUQuota=400%

[Install]
WantedBy=multi-user.target
EOF

useradd -m monerodaemon -d /home/monerodaemon
systemctl daemon-reload
systemctl enable monero
systemctl start monero

sleep 30
echo "Please wait until Monero daemon is fully synced"
tail -f /home/monerodaemon/.bitmonero/bitmonero.log 2>/dev/null | grep Synced &
( tail -F -n0 /home/monerodaemon/.bitmonero/bitmonero.log & ) | egrep -q "You are now synchronized with the network"
killall tail 2>/dev/null
echo "Monero daemon is synced"
