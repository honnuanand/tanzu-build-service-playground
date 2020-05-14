1. ### Install Azure CLI - [Instructions Here ](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)

1. ### Login to the az cli
    ```bash
          anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
          $ az login -u arao@pivotal.io
          Password:
          [
            {
              "cloudName": "AzureCloud",
              "homeTenantId": "29248f74-371f-4db2-9a50-c62a6877a0c1",
              "id": "1da11b37-d598-4c13-8523-690756fd00ab",     # <-- This is the SubscriptionID
              "isDefault": true,
              "managedByTenants": [],
              "name": "FE-arao",
              "state": "Enabled",
              "tenantId": "29248f74-371f-4db2-9a50-c62a6877a0c1",
              "user": {
                "name": "arao@pivotal.io",
                "type": "user"
              }
            },
            {
              "cloudName": "AzureCloud",
              "homeTenantId": "29248f74-371f-4db2-9a50-c62a6877a0c1",
              "id": "9036e83e-2238-42a4-9b2a-ecd80d4cc38d",
              "isDefault": false,
              "managedByTenants": [],
              "name": "FE-SCS-Azure",
              "state": "Enabled",
              "tenantId": "29248f74-371f-4db2-9a50-c62a6877a0c1",
              "user": {
                "name": "arao@pivotal.io",
                "type": "user"
              }
            }
          ]

          anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
          $
      ```


1. ### Create the AKS  Cluster with 3 nodes 
      
      ```bash
      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ az aks create --resource-group tbs-on-aks --name tbs-on-aks --node-count 3 --enable-addons monitoring --generate-ssh-keys
      SSH key files '/Users/anandrao/.ssh/id_rsa' and '/Users/anandrao/.ssh/id_rsa.pub' have been generated under ~/.ssh to allow SSH access to the VM. If using machines without permanent storage like Azure Cloud Shell without an attached file share, back up your keys to a safe location
      AAD role propagation done[############################################]  100.0000%

      {
        "aadProfile": null,
        "addonProfiles": {
          "omsagent": {
            "config": {
              "logAnalyticsWorkspaceResourceID": "/subscriptions/1da11b37-d598-4c13-8523-690756fd00ab/resourcegroups/defaultresourcegroup-wus2/providers/microsoft.operationalinsights/workspaces/defaultworkspace-1da11b37-d598-4c13-8523-690756fd00ab-wus2"
            },
            "enabled": true,
            "identity": null
          }
        },
        "agentPoolProfiles": [
          {
            "availabilityZones": null,
            "count": 3,
            "enableAutoScaling": null,
            "enableNodePublicIp": false,
            "maxCount": null,
            "maxPods": 110,
            "minCount": null,
            "mode": "System",
            "name": "nodepool1",
            "nodeLabels": {},
            "nodeTaints": null,
            "orchestratorVersion": "1.15.10",
            "osDiskSizeGb": 100,
            "osType": "Linux",
            "provisioningState": "Succeeded",
            "scaleSetEvictionPolicy": null,
            "scaleSetPriority": null,
            "spotMaxPrice": null,
            "tags": null,
            "type": "VirtualMachineScaleSets",
            "vmSize": "Standard_DS2_v2",
            "vnetSubnetId": null
          }
        ],
        "apiServerAccessProfile": null,
        "autoScalerProfile": null,
        "diskEncryptionSetId": null,
        "dnsPrefix": "tbs-on-aks-tbs-on-aks-1da11b",
        "enablePodSecurityPolicy": null,
        "enableRbac": true,
        "fqdn": "tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io",
        "id": "/subscriptions/1da11b37-d598-4c13-8523-690756fd00ab/resourcegroups/tbs-on-aks/providers/Microsoft.ContainerService/managedClusters/tbs-on-aks",
        "identity": null,
        "identityProfile": null,
        "kubernetesVersion": "1.15.10",
        "linuxProfile": {
          "adminUsername": "azureuser",
          "ssh": {
            "publicKeys": [
              {
                "keyData": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHkQXZtYfMhiIKvwnrqg0hYkWI9H+UKRdU+kU5NvxpmHUbyGSX/lbGUBaFahWpSBdUdJr4bbjI83FB9v7xdTcPBbIpQy3O2dN96TZ8rzmcebfSuKHKqb5GIz+pv7sCx/DrHU9IrzHiE9BG8EadMjnf66aAPovKNiz+/ljQsgPSaiSjzSnRVyI1MKnECgehSsgdJxpAmfH5qiU8HO4iUPj2e4Zg8Ut/8OEWQ0erozvaCgDTFb2hhNtDrUOLv3Hz5jYrWS/iyuXtrtEP7BiqeQ5bVjBYKPIvX9Ax/dzVrSzveR6rAKYCpjHgCJUxPQGNWhjUy+7SlXJQi0Q6+QGTUGkL"
              }
            ]
          }
        },
        "location": "westus2",
        "maxAgentPools": 10,
        "name": "tbs-on-aks",
        "networkProfile": {
          "dnsServiceIp": "10.0.0.10",
          "dockerBridgeCidr": "172.17.0.1/16",
          "loadBalancerProfile": {
            "allocatedOutboundPorts": null,
            "effectiveOutboundIps": [
              {
                "id": "/subscriptions/1da11b37-d598-4c13-8523-690756fd00ab/resourceGroups/MC_tbs-on-aks_tbs-on-aks_westus2/providers/Microsoft.Network/publicIPAddresses/c4b3ba80-3f61-4fc9-8664-58d8dc0e5624",
                "resourceGroup": "MC_tbs-on-aks_tbs-on-aks_westus2"
              }
            ],
            "idleTimeoutInMinutes": null,
            "managedOutboundIps": {
              "count": 1
            },
            "outboundIpPrefixes": null,
            "outboundIps": null
          },
          "loadBalancerSku": "Standard",
          "networkMode": null,
          "networkPlugin": "kubenet",
          "networkPolicy": null,
          "outboundType": "loadBalancer",
          "podCidr": "10.244.0.0/16",
          "serviceCidr": "10.0.0.0/16"
        },
        "nodeResourceGroup": "MC_tbs-on-aks_tbs-on-aks_westus2",
        "privateFqdn": null,
        "provisioningState": "Succeeded",
        "resourceGroup": "tbs-on-aks",
        "servicePrincipalProfile": {
          "clientId": "c7b85f2d-853f-44c0-a00b-350ce95be6b8",
          "secret": null
        },
        "sku": {
          "name": "Basic",
          "tier": "Free"
        },
        "tags": null,
        "type": "Microsoft.ContainerService/ManagedClusters",
        "windowsProfile": null
      }
      ```

1. ### Update the local KUBECONFIG with the  credentials of the cluster

      ```bash
      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ az aks get-credentials -n tbs-on-aks -g tbs-on-aks
      Merged "tbs-on-aks" as current context in /Users/anandrao/.kube/config

      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ k config current-context
      tbs-on-aks

      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ k cluster-info
      Kubernetes master is running at https://tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io:443
      healthmodel-replicaset-service is running at https://tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io:443/api/v1/namespaces/kube-system/services/healthmodel-replicaset-service/proxy
      CoreDNS is running at https://tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
      kubernetes-dashboard is running at https://tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io:443/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
      Metrics-server is running at https://tbs-on-aks-tbs-on-aks-1da11b-cbf15bbb.hcp.westus2.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

      To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

      ```

1. ### Create a Persistent Volume Claim
      Azure has Dynamic Persistent Volume management. This allows you to directly create a Persistent Volume Claim without explicitly creating a Volume

      ```bash
      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ bat azure-managed-disk.yaml
      ──────┬──────────────────────────────────────────────────────────────────────────────
      ──────┼──────────────────────────────────────────────────────────────────────────────
        2   │ kind: PersistentVolumeClaim
        3   │ metadata:
        4   │   name: azure-managed-disk
        5   │ spec:
        6   │   accessModes:
        7   │   - ReadWriteOnce
        8   │   storageClassName: managed-premium
        9   │   resources:
        10  │     requests:
        11  │       storage: 5Gi
      ──────┴──────────────────────────────────────────────────────────────────────────────

      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ kubectl apply -f ./azure-managed-disk.yaml
      persistentvolumeclaim/azure-managed-disk created

      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ k get pv
      No resources found in default namespace.

      anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
      $ k get pvc
      NAME                 STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
      azure-managed-disk   Bound    pvc-91018c68-0055-4506-a9a1-46d22a8cf424   5Gi        RWO            managed-premium   16s
      ```


1. ### Now that we have  the aks cluster ready ,  lets intall [Tanzu Build Service](https://docs.pivotal.io/build-service/0-1-0/installing.html)

    1.  Download duffle ,  pb cli from [pivnet](http://network.pivotal.io)
        ```bash
        $ mv ~/Downloads/duffle-0.1.0-darwin /usr/local/bin/duffle
        $ chmod +x /usr/local/bin/duffle

        $ mv ~/Downloads/pb-0.1.0-darwin /usr/local/bin/pb
        $ chmod +x /usr/local/bin/pb

        ```
    2.  Confirm that you are on the correct kubernetis cluster

        ```bash
        anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
        $ kubectl config use-context tbs-on-aks

        Switched to context "tbs-on-aks".
        ```

    3. ### Create a [Credentials File](configs/azure-manager-disk.yaml) for duffle
        (Creating this file in the /tmp folder is important for the 0.1 version of tbs)

        ```anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
          $ bat /tmp/credentials.yml
          ──────┬───────────────────────────────────────────────────────────────
                │ File: /tmp/credentials.yml
          ──────┼───────────────────────────────────────────────────────────────
            1   │ name: build-service-credentials
            2   │ credentials:
            3   │  - name: kube_config
            4   │    source:
            5   │      path: "/Users/anandrao/.kube/config"
            6   │    destination:
            7   │      path: "/root/.kube/config"
            8   │    destination:
            9   │      path: "/cnab/app/cert/ca.crt"
          ──────┴────────────────────────────────────────────────────────────────

        ```










```bash
anandrao at Anands-MBP-3 in ~/pivotal/repos/k8s-playground/tanzu/tbs/azure (master●)
$ duffle install tbs-uno -c /tmp/credentials.yml  \
    --set kubernetes_env=gke_pa-arao_us-west1-a_uno-gke \
    --set docker_registry=docker.io \
    --set docker_repository=honnuanand \
    --set registry_username="honnuanand" \
    --set registry_password="2ae5fd42-4b12-466b-bcc5-3d494ef06165" \
    --set custom_builder_image="docker.io/honnuanand/build-service/default-builder" \
    -f /tmp/build-service-0.1.0.tgz \
    -m /tmp/relocated.json
```




