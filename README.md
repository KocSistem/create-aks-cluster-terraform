# Introduction 

 This sample is shows how to bake your docker image, push image to docker hub,create aks cluster with terraform and deploy containers to k8s cluster.

# Prerequisites

* Azure Subscription: If you don’t have an Azure subscription, you can create a free account at https://azure.microsoft.com before start.
* Azure Service Principal: is an identity used to authenticate to Azure. Below are the instructions to create one
* Azure DevOps Account: Create an Azure DevOps account because is a separate service from the Azure Portal
* Terraform extension: Install the Terraform Build & Release Tasks extension from the Marketplace 

# How to

First of all, you have to do two things.
1. Fork this repositroy
2. Create a service connection for uploading Docker images to a Docker Hub private repository

Open the Project, then click Project settings, then click Service connections.Select registry type the Docker Hub and then enter the Docker Hub ID, password,email address and give the connection a meaningful.Click save and verify this connection.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/serviceconnection.PNG)

Now we are ready to build our first Azure DevOps Build Pipeline

#### SampleWebApp Pipeline

Click on the build pipeline button and select GitHub yaml

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/new%20pipeline.PNG)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/source%20control.PNG)

Select the k8schallenge repository

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/repository.PNG)

Select an Existing Azure Pipelines Yaml file 

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/pipelineconfig.PNG)

Then select /02-sampleapp/ci/azure-pipelines.yml path

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/sampleapp.PNG)

Click at the Docker@2 task settings in yaml editor and then change containerRegistry and repository name in YAML file.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/changeserviceconnection.PNG)

Then click the Save and run button to launch our pipeline.


#### Infrastructure Pipeline

Follow the steps above.The only difference is the file path (/01-terraform/ci/create-infrastructure.yml)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/infrastructure.PNG)

Change subscriptions for all Azure tasks and click on the authorize button.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/changesubscription.PNG)

Don't forget to change environment variables!!

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/variable.PNG)

Then click the Save and run button to launch our pipeline

#### AKS Pod Pipeline

Follow the steps above.The only difference is the file path (/03-k8sdeployment/ci/azure-pipelines.yml)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/poddeployment.PNG)

You need to change subscription

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/changeazdosubscription.PNG)

# Let's Get Hands Dirty

We run all pipelines in sequence

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/imagepipeline.PNG)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/infrapipeline.PNG)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/podpipeline.PNG)

 You can also see a live feed of the console
 
![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/imagelog.PNG)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/terraformlog.PNG)

As you can see all infrastructure, images, and applications are delivered automatically.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/Portal.PNG)

# Demonstrate of the Cluster and Pod Autoscaler

We will start a container, and send an infinite loop of queries to the sampleappservice

kubectl run -it --rm load-generator --image=busybox /bin/sh

while true; do wget -q -O- http://40.118.127.126:11130; done

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/loadimage.PNG)

You will see the number of pods increases after the load.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/hpa.PNG)

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/nodes.PNG)


End of the day don't forget to remove infrastructure. Keep Your Money in Your Pocket !!

Bonus : You can use delete-infrastructure.yml for this task.

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/destroy.PNG)

Everything's gone

![Image](https://github.com/fthkucuk/k8schallenge/blob/master/04-images/resources.PNG)




