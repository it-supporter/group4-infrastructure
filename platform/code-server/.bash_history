which ssh
ssh henrik@automation01
ls -lah ~/.ssh
cat ~/.ssh/*.pub
cat ~/.ssh/id_ed25519.pub
ls -lah ~/.ssh
for f in ~/.ssh/*.pub; do     echo "===== $f =====";     cat "$f";     echo; done
ssh henrik@automation01
clear
ls -lah /config/.ssh
ssh -v henrik@automation01
mkdir -p /workspace/k3s01/.vscode
nano /workspace/k3s01/.vscode/sftp.json
[200~pwd
echo "===================="
find /workspace -type f -name "sftp.json"~
clear
pwd
echo "===================="
find /workspace -type f -name "sftp.json"
tree /workspace -L 3
sudo apt install tree
ssh henrik@10.4.10.60
cat /config/.ssh/id_ed25519.pub
mkdir -p ~/.ssh
nano ~/.ssh/config
whoami
echo "===================="
pwd
echo "===================="
echo $HOME
echo "===================="
mount | grep config
clear
echo $HOME
find /config -type d -name "*extensions*" 2>/dev/null
ls -la /config/extensions
find /config -type d | grep extension
clear
cd /config/extensions/natizyskunk.sftp-1.16.3-universal
find . -iname "*.json" | grep schema
cat schema/sftp.schema.json
find . -iname "*.json" | grep -i sftp
cat /config/extensions/natizyskunk.sftp-1.16.3-universal/package.json | grep -A20 -B20 sftp.json
grep -Ri "defaultProfile" /config/extensions/natizyskunk.sftp-1.16.3-universal
grep -Ri "profiles" /config/extensions/natizyskunk.sftp-1.16.3-universal
grep -Ri "Set Profile" /config/extensions/natizyskunk.sftp-1.16.3-universal
cd ..
cd ls
cd..
exit
apt update
apt install -y mc
which mc
mc
exit
mkdir -p ~/.local/share/mc/skins
exit
chown -R abc:abc /config/.local/share/mc
ls -ld /config/.local/share/mc
exit
