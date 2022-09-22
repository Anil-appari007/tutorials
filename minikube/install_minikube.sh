curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker ubuntu
newgrp docker


###     After installing docker & loading newgrp
###     You can save the below commands in shell_script and execute it.
###     $ bash install_minikube.sh

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/bin/
sudo apt install conntrack -y



###     https://github.com/Mirantis/cri-dockerd#build-and-install

git clone https://github.com/Mirantis/cri-dockerd.git
wget https://storage.googleapis.com/golang/getgo/installer_linux
chmod +x ./installer_linux
./installer_linux
source ~/.bash_profile

cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
sudo mkdir -p /usr/local/bin
sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
sudo cp -a packaging/systemd/* /etc/systemd/system
sudo sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
sudo systemctl daemon-reload
sudo systemctl enable cri-docker.service
sudo systemctl enable --now cri-docker.socket


###     https://github.com/kubernetes-sigs/cri-tools
cd
mkdir cri-tools && cd cri-tools && \
VERSION="v1.25.0" && \
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz && \
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin && \
rm -f crictl-$VERSION-linux-amd64.tar.gz

minikube start --vm-driver=none

####    https://devopstoolsinfo.blogspot.com/2022/09/minikube-setup-commands.html
cd
mkdir calico && cd calico && \
curl https://docs.projectcalico.org/manifests/calico-typha.yaml -o calico.yaml && \
kubectl apply -f calico.yaml

cd

kubectl get nodes


###     https://minikube.sigs.k8s.io/docs/start/
kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
kubectl expose deployment hello-minikube --type=NodePort --port=8080


###     https://kubernetes.io/docs/tutorials/hello-minikube/

#   kubectl create deployment hello-node --image=registry.k8s.io/echoserver:1.4
#   kubectl expose deployment hello-node --type=LoadBalancer --port=8080
#   minikube service hello-node


###     https://github.com/kubernetes/kubernetes/issues/112135