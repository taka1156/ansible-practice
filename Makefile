
.PHONY: genkey ssh ping

ssh:
	ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ansible@ansible-target

ping:
	ansible -i ansible/inventory.ini ubuntu_servers -m ping
