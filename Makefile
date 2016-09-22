KUBE_ROOT = $(word 1, $(subst :, ,$(GOPATH)))/src/k8s.io/kubernetes
KUBESH_ROOT = $(KUBE_ROOT)/cmd/kubesh
$(KUBE_ROOT):
	mkdir -p $(KUBE_ROOT)
	git clone https://github.com/kubernetes/kubernetes.git $(KUBE_ROOT)

# this runs everytime, even when the kubesh.go link exists, so we clean up first
$(KUBESH_ROOT)/kubesh.go: $(KUBE_ROOT)
	rm -f $(KUBESH_ROOT)/kubesh.go
	mkdir -p $(KUBESH_ROOT); ln -s $(PWD)/kubesh.go $(KUBESH_ROOT)/kubesh.go

.PHONY: setup
setup: $(KUBE_ROOT) $(KUBESH_ROOT)/kubesh.go

.PHONY: clean
clean:
	rm -rf $(KUBE_ROOT)

run: setup
	cd $(KUBE_ROOT)
	go run $(KUBESH_ROOT)/kubesh.go
