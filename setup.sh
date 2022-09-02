apt-get update

apt-get install -y apt-transport-https docker.io

systemctl start docker
systemctl enable docker

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubelet kubeadm kubernetes-cni

kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

kubectl create namespace argocd
kubectl apply -k argocd
kubectl apply -k master-app