# Copyright 2016 Red Hat, Inc, and individual contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

KUBE_ROOT = $(word 1, $(subst :, ,$(GOPATH)))/src/k8s.io/kubernetes
KUBESH_ROOT = $(KUBE_ROOT)/cmd/kubesh

$(KUBE_ROOT):
	@mkdir -p $(KUBE_ROOT)
	git clone https://github.com/kubernetes/kubernetes.git $(KUBE_ROOT)

$(KUBESH_ROOT): $(KUBE_ROOT)
	cd $(KUBESH_ROOT) || (mkdir -p $(KUBESH_ROOT) && cp *.go $(KUBESH_ROOT)/ && cd $(KUBESH_ROOT) && go install -v)

.PHONY: setup
setup: $(KUBESH_ROOT)

.PHONY: clean
clean:
	rm -rf $(KUBE_ROOT)

.PHONY: run
run: setup
	diff -q -x '.git*' -x '[A-Z]*' . $(KUBESH_ROOT) || cp *.go $(KUBESH_ROOT)/
	cd $(KUBESH_ROOT) && go run `ls *.go | grep -v _test`

.PHONY: test
test: setup
	diff -q -x '.git*' -x '[A-Z]*' . $(KUBESH_ROOT) || cp *.go $(KUBESH_ROOT)/
	cd $(KUBESH_ROOT) && go test
