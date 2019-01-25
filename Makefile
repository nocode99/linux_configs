.PHONY: install
install:
	ansible-playbook playbook.yml -l localhost
