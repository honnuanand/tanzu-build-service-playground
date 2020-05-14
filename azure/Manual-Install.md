1. ### Install Azure CLI - [Instructions Here ](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)

1. ### Login to the az cli
    ```bash
          $ az login -u arao@pivotal.io
      ```


1. ### Create the AKS  Cluster with 3 nodes 
      
      ```bash
      $ az aks create --resource-group tbs-on-aks --name tbs-on-aks --node-count 3 --enable-addons monitoring --generate-ssh-keys
      ```

1. ### Update the local KUBECONFIG with the  credentials of the cluster

      ```bash
      $ az aks get-credentials -n tbs-on-aks -g tbs-on-aks

      $ k config current-context
      tbs-on-aks

      $ k cluster-info

      ```

1. ### Create a Persistent Volume Claim
      Azure has Dynamic Persistent Volume management. This allows you to directly create a Persistent Volume Claim without explicitly creating a Volume

      ```bash
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

    3. ### Create a [Credentials File](configs/azure-managed-disk.yaml) for duffle
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
    --set registry_password="xxxxxx" \
    --set custom_builder_image="docker.io/honnuanand/build-service/default-builder" \
    -f /tmp/build-service-0.1.0.tgz \
    -m /tmp/relocated.json
```




