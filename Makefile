KUBE_ROOT = $(word 1, $(subst :, ,$(GOPATH)))/src/k8s.io/kubernetes
KUBESH_ROOT = $(KUBE_ROOT)/cmd/kubesh

$(KUBE_ROOT):
	mkdir -p $(KUBE_ROOT)
	git clone https://github.com/kubernetes/kubernetes.git $(KUBE_ROOT)

$(KUBESH_ROOT): $(KUBE_ROOT)
	mkdir -p $(KUBESH_ROOT)

.PHONY: setup
setup: $(KUBESH_ROOT)

.PHONY: clean
clean:
	rm -rf $(KUBE_ROOT)

.PHONY: run
run: setup
	cp kubesh.go $(KUBESH_ROOT)/kubesh.go	
	cd $(KUBE_ROOT)
	go run $(KUBESH_ROOT)/kubesh.go
