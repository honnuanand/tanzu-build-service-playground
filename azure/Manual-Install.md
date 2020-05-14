1. ### Install Azure CLI - [Instructions Here ](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest)

1. ### Login to the az cli
    ```bash
          $ az login -u arao@pivotal.io
      ```

1. ### Create a new ResourceGroup on Azure ( unless  you want to install it on an existing group)
      ```bash
      $ az group create --name tbs-on-aks --location westus2
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

1. ### Create an instance of Azure Container Registry - [ACR](https://azure.microsoft.com/en-us/services/container-registry/)
    1. We will install the acr instance in the same Resource Group as  the AKS cluster. 
        ```bash
        $ az acr create --resource-group tbs-on-aks --name araotbs --sku Basic # name cannot have special characters 

        $ az acr show-endpoints --name araotbs
        This command is in preview. It may be changed/removed in a future release.
        {
          "dataEndpoints": [
            {
              "endpoint": "*.blob.core.windows.net",
              "region": "westus2"
            }
          ],
          "loginServer": "araotbs.azurecr.io"
        }

        $ az acr login --name araotbs
        Login Succeeded
        ```
    2. ### Enable admin user on the acr instance 
       ```bash
       $ az acr update -n araotbs  --admin-enabled true
       $ az acr credential show --name araotbs # the name is representing the acr instance name 
        {
          "passwords": [
            {
              "name": "password",
              "value": "SNIP"
            },
            {
              "name": "password2",
              "value": "SNIP"
            }
          ],
          "username": "araotbs" # docker login admin username 
        }
       ```
    3. ### Using ACR from local machine 
       You will be able to use  the acr instance  using the docker command by substituting the docker.io with the login URL above. Example : 
       ```bash
       $ docker tag hello-world araotbs.azurecr.io/hello-world:v1
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

    4. ### Relocate ( inflate ) the contents of the build service bundle into your acr instance
       Make sure the zip file and the relocate.yml are in the `tmp` folder. The Current tbs / duffle version expects the files to be in there. 

       ```bash
       $ duffle relocate -f /tmp/build-service-0.1.0.tgz -m /tmp/relocated.json -p araotbs.azurecr.io/build-service
       ```
       Need to Ident a way to confirm all the images are relocated into the registry . Currently the best way is to  check the contents of the relocate.json 
       ```bash
       $ cat  /tmp/relocated.json | jq
       ```
    5. ### Install TBS  using Duffle 
       ```bash
        $ duffle install tbs-on-aks -c /tmp/credentials.yml  \
            --set kubernetes_env=tbs-on-aks \
            --set docker_registry=araotbs.azurecr.io \
            --set registry_username="araotbs" \
            --set registry_password="6jv=BDK55Cn1Nxr6XsbIOiIAnHBJpsau" \
            --set custom_builder_image="araotbs.azurecr.io/build-service/default-builder" \
            -f /tmp/build-service-0.1.0.tgz \
            -m /tmp/relocated.json
        ...
        ...
        ...
        Succeeded
        Action install complete for tbs-on-aks
        ```
    6. ### Time to start using the `pb` cli 
    7. ### Create a TBS Project 
        ```bash
        $ pb project create tbs-uno
        ```
    8. ### Target the project
        ```bash
        $ pb project target tbs-uno
        ```
    9. ### setup the image registry credentials for the project 
        Create a credentials.yml file as below and apply the same using the pb cli 
        ```bash
        $ bat tbs-registry-secrets.yaml
          ───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
                │ File: tbs-registry-secrets.yaml
          ───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
            1   │ registry: https://araotbs.azurecr.io # make sure to add the https://
            2   │ username: registry-username #
            3   │ password: registry-password
          ───────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

        $ pb secrets registry apply -f  tbs-registry-secrets.yaml
        ```
    10. ### Create a image build config file and use the pb cli to apply it into the project
        ```bash
        $ bat sample-build-image-config.yaml
        ───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
              │ File: sample-build-image-config.yaml
        ───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
          1   │ source:
          2   │   git:
          3   │     url: https://github.com/honnuanand/spring-k8s
          4   │     revision: master
          5   │ build:
          6   │   env:
          7   │   - name: name
          8   │     value: dev
          9   │ image:
          10   │   tag: araotbs.azurecr.io/spring-k8s
        ───────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
        
        $ pb image apply -f ./sample-build-image-config.yaml
        ```
        This should trigger the initial build. You can always re-trigger the build using the below example 
        ```bash
        $ pb image trigger araotbs.azurecr.io/spring-k8s
        ```
    11. ### you will be able to monitor the build and watch the logs using commands like below 
        ```bash
        $ pb image builds araotbs.azurecr.io/spring-k8s
        $ pb image logs araotbs.azurecr.io/spring-k8s -b 2 -f
        ```    
      



source:
  git:
    url: https://github.com/honnuanand/spring-k8s
    revision: master
build:
  env:
  - name: name
    value: dev
image:
  tag: araotbs.azurecr.io/spring-k8s



registry: https://araotbs.azurecr.io # make sure to add the https://
username: araotbs
password: 6jv=BDK55Cn1Nxr6XsbIOiIAnHBJpsau












