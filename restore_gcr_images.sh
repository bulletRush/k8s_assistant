#!/bin/bash
arch="amd64"
origin_prefix="gcr.io/google_containers"
kube_version="v1.4.1"
kube_dns_version="1.7"
dnsmasq_version="1.3"
exechealthz_version="1.1"
pause_version="3.0"
user="barrettwu"

core_images=(
	"etcd 2.2.5"
	"kube-apiserver $kube_version"
	"kube-controller-manager $kube_version"
	"kube-scheduler $kube_version"
	"kube-proxy $kube_version"
	"kubedns $kube_dns_version"
	"kube-dnsmasq $dnsmasq_version"
	"exechealthz $exechealthz_version"
	"pause $pause_version"
)

n_images=${#core_images[*]}
for ((i=0;i<$n_images;i++));
do 
	image=(${core_images[$i]})
	name=${image[0]}
	version=${image[1]}
	image_full_name=${origin_prefix}/${name}-${arch}:${version}
	echo "***** pulling $image_full_name"
	docker pull $image_full_name
	new_full_name=$user/${name}-${arch}:${version}
	echo "***** tag to $new_full_name"
	docker tag $image_full_name $new_full_name
	echo "***** pushing $new_full_name"
	docker push $new_full_name
done


