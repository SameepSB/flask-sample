# ==================================Kubernetes=========================================

# On all nodes as ubuntu user:

swapoff -a
sudo apt update -y
sudo apt install docker.io -y
sudo service docker status
sudo systemctl enable docker
sudo docker version
ufw allow 6443/udp && ufw allow 6443/tcp


sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt update



#### To get current kubeadm available version 
apt list -a kubeadm

sudo apt-get install -y kubelet=1.19.16-00 kubeadm=1.19.16-00 kubectl=1.19.16-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo -i

sudo apt-get upgrade -y kubelet=1.24.3-00 kubeadm=1.24.3-00 kubectl=1.24.3-00
sudo apt-mark hold kubelet kubeadm kubectl
sudo -i

==================================================
# Only On Master: 

kubeadm init --apiserver-advertise-address= <private_ip_address_of-master_node> --pod-network-cidr=192.168.0.0/16  --ignore-preflight-errors=NumCPU
# example
kubeadm init --apiserver-advertise-address=10.0.1.93  --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU

Your Kubernetes control-plane has initialized successfully!

# To start using your cluster, you need to run the following as a regular user:
  exit
  or su ubuntu
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


  kubectl get nodes

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
# https://kubernetes.io/docs/concepts/cluster-administration/addons/

curl https://docs.projectcalico.org/v3.20/manifests/calico.yaml -O
kubectl apply -f calico.yaml

OR

kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

-----------------------------------------------------------------------------------
# Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.1.7:6443 --token h534bq.in58srm2t2rznzkx \
    --discovery-token-ca-cert-hash sha256:bb3e83b82898f37ffc09b5c25f95ec5fa287ff4dfc936a400bd2b9426bfcf6a9

# To reprint the join command from kube Master execute below command :
kubeadm token create --print-join-command
--------------------
# On Master:
kubectl get nodes

# Jenkins 
Go to Manage Jenkins. Click on Configure Global Security.
TCP port for inbound agents ==> Random

# Kubernetics dashboard 
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.3/aio/deploy/recommended.yaml

kubectl get svc -n kubernetes-dashboard

kubectl edit svc kubernetes-dashboard -n kubernetes-dashboard

# updated nodeport
ports:
  - nodePort: 32000
    port: 443
    protocol: TCP
    targetPort: 8443
  selector:
    k8s-app: kubernetes-dashboard
  sessionAffinity: None
  type: NodePort


kubectl get svc -n kubernetes-dashboard

cat >kub-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

kubectl apply -f kub-service-account.yaml

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

https://<public_ip_address_master>:node_port