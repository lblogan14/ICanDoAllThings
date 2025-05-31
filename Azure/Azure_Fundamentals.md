# Azure Fundamentals

## Azure Architecture
### Azure Resources and Resource Groups
A *resource* is the basic block of Azure. It can be a virtual machine (VM), virtual network, database, cognitive service, etc.

A *resource group* is agroup of resources. When we create a resource, we must specify a resource group When we apply an action to a resource group, it applies to all resources in that group.

### Azure Subscriptions
*Subscription* is a unit of management, billing, and scale. Similar to resource groups organizing resources, subscriptions allow us to logically organize our resource groups and facilitate billing.

### Azure Management Groups
Resources are gathered into resource groups, and resource groups are gathered into subscriptions. Management groups allow us to organize our subscriptions into a hierarchy for governance and policy application.

For example,

<img src="./imgs/management-groups-subscriptions.png" />

## Azure Virtual Machines
With Azure Virtual Machines (VMs), we can 
- gain total control over the operating system (OS),
- run custom software,
- use custom hosting configurations.

We can even create or use an already created image to rapidly provision VMs. An image is a template used to create a VM and may already include an OS and other software, like development tools or web hosting environments.

### Scale VMs
Running single VMs for testing or development is fine, but for production workloads, we need to scale our VMs.
- *VM scale sets* let us create and manage a group of identical, load-balanced VMs.
- *VM availability sets* ensure that VMs stagger updates and have varied power and network connectivity, preventing us from losing all our VMs with a single network or power failure.

When provisioning VMs, we need to consider the following:
- Size (purpose, number of processor cores, and amount of RAM)
- Storage disks (hard disk drives, solid state drives, etc.)
- Networking (virtual network, public IP address, and port configuration)

## Azure Virtual Desktops
Azure Virtual Desktop is a desktop and application virtualization service that runs on the cloud., which enables us to use a cloud-hosted version of Windows from any location.

## Azure Containers
While virtual machines are excellent way to reduce costs versus on-premises hardware, they are still limited to a single OS per virtual machine. If we want to run multiple instances of an application on a single host machine, containers are a better option.

*Containers* are a virtualization environment. Similar to running multiple VMs on a single physical host, we can run multiple containers on a single physical or virtual host. Unlike VMs, we do not manage the OS for each container. Virtual machines appear to be an instance of an OS that we an connect to and manage.

Containers are *lightweight* and designed to be created, scaled out, and stopped dynamically. It is possible to create and deploy VMs as application demand increases, but containers are a lighter weight, more agile method.

Containers are designed to allow us to respond to changes on demand.
- *Azure Container Instances* offer the fastest and simplest way to run a container in Azure; without having to manage any virtual machines or adopt any additional services. Azure Container Instances are a platform as a service (PaaS) offering. Azure Container Instances allow us to upload our containers and then the service runs the containers for us.
- *Azure Container Apps* allow us to get up and running right away, and remove the container management piece. Container Apps have extra benefits such as the ability to incorporate load balancing and scaling.
- *Azure Kubernetes Service (AKS)* is a container orchestration service that manages the lifecycle of containers. When we are deploying a fleet of containers, AKS can make fleet management simpler and more efficient.


Containers are often used to create solutions by using a microservice architecture. This architecture is where we break solutions into smaller, independent pieces. For example, we may split a website into a container hosting our frontend, another hosting our backend, and a third for storage. This split allows us to separate portions of our app into logical sections that can be maintained, scaled, or updated independently.

## Azure Functions
*Azure Functions* is an event-driven, serverless compute option that does not requrie maintaining virtual machines or containers.

If we build an app using VMs or containers, those resources have to be "running" in order for our app to function. With Azure Functions, an event wakes the function, alleviating the need to keep resources provisioned when there are no events to process.

Using Azure Functions is ideal when we are only concerned about the code running our service and not about the underlying platform or infrastructure.

Functions are commonly used when we need to perform work in response to an event (often via a REST request), timer, or message from another Azure service, and when that work can be completed quickly, within seconds or less.

Functions scale automatically based on demand. Azure Functions runs our code when it triggers and automatically deallocates resources when the function is finished.

Functions can be either stateless or stateful. 
- When they are stateless (the default), they behave as if they restart every time they respond to an event. 
- When they are stateful (called *Durable Functions*), a context is passed through the function to track prior activity.



## Appliction Hosting
Virtual machines give us maximum control of the hosting environment and allow us to configure it exactly how we want.

Containers, with the ability to isolate and individually manage different aspects of the hosting solution, can also be a robust and compelling option.

### Azure App Service

*App Service* enables us to build and host web apps, background jobs, mobile beckends, and RESTful APIs in the programming language of our choice without managing infrastructure. It also offers automatic scaling and high availability. It enables automated deployments from GitHub, Azure DevOps, or any Git repository to support a continuous deployment model.

With App Service, we can host
- Web apps - full support for hosting web apps
- API apps - building REST-based web APIs. Full Swagger support and the ability to package and publish APIs in Azure Marketplace.
- WebJobs - running programs or scripts in the same context as a web app, API app, or mobile app. They can be scheduled or run by a trigger. WebJobs are often used to run background tasks as part of our app logic.
- Mobile apps - building backends for iOS and Android apps

## Azure Virtual Networking

*Azure virtual networks* and *virtual subnets* enable Azure resources, such as VMs, web apps, and databases, to communicate with each other, with users on the internet, and with our on-premises client computers.

Azure virtual networks provide
- isolation and segmentation - creating multiple isolated virtual networks.
- internet communication - enabling incoming and outgoing communication with the internet.
- communication between Azure resources
- communication with on-premises resources
- routing network traffic
- filtering network traffic
- connecting virtual networks

Azure virtual networking supports both public and private endpoints to enable communication between external or internal resources with other internal resources.

## Azure Virtual Private Networks
*Virtual private networks (VPNs)* are typically deployed to connect two or more trusted private networks to one another over an untrusted network (typically the public internet). Traffic is encrypted while traveling over the untrusted network to prevent eavesdropping or other attacks. VPNs can enable networks to safely and securely share sensitive information.

## Azure ExpressRoute
*Azure ExpressRoute* lets us extend our on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider.

With ExpressRoute, we can establish connections to Microsoft cloud services such as Azure and Microsoft 365. ExpressRoute connections do not go over the public internet. Connectivity can be from an any-to-any (IP VPN) network, a point-to-point Ethernet network, or a virtual cross-connection through a connectivity provider at a co-location facility.

We can enable ExpressRoute Global Reach to exchange data across our on-premises sites by connecting our ExpressRoute circuits. For example, say we had an office in Asia and a datacenter in Europe, both with ExpressRoute circuits connecting them to the Microsoft network. We could use ExpressRoute Global Reach to connect those two facilities, allowing them to communicate without transferring data over the public internet.


## Azure DNS
*Azure DNS* is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. We can manage our DNS records using the same credentials, APIs, tools, and billing as our other Azure services.


## Azure Storage
A storage account provides a unique namespace for the Azure Storage data that's accessible from anywhere in the world over HTTP or HTTPS. Data in this account is secure, highly available, durable, and massively scalable.

The type of storage account we create determines the storage services and redundancy options:
- Locally redundant storage (LRS)
- Geo-redundant storage (GRS)
- Read-access geo-redundant storage (RA-GRS)
- Zone-redundant storage (ZRS)
- Geo-zone-redundant storage (GZRS)
- Read-access geo-zone-redundant storage (RA-GZRS)

| Type | Supported services | Redundancy Options | Usage |
|------|--------------------|--------------------|-------|
| Standard general-purpose v2 | Blob Storage (including Data Lake Storage), Queue Storage, Table Storage, and Azure Files | LRS, GRS, RA-GRS, ZRS, GZRS, RA-GZRS | Standard storage account type for blobs, file shares, queues, and tables. Recommended for most scenarios using Azure Storage. If you want support for network file system (NFS) in Azure Files, use the premium file shares account type. |
| Premium block blobs | Blob Storage (including Data Lake Storage) | LRS, ZRS | Premium storage account type for block blobs and append blobs. Recommended for scenarios with high transaction rates or that use smaller objects or require consistently low storage latency.|
| Premium file shares | Azure Files | LRS, ZRS | Premium storage account type for file shares only. Recommended for enterprise or high-performance scale applications. Use this account type if you want a storage account that supports both Server Message Block (SMB) and NFS file shares.|
| Premium page blobs | Page blobs only | LRS | Premium storage account type for page blobs only.|

Every storage account in Azure has a unique-in-Azure account name. The combination of the account name and the Azure Storage service endpoint forms the endpoints for our storage account.

| Storage service | Endpoint |
|----------------|----------|
| Blob Storage | https://\<storage-account-name\>.blob.core.windows.net |
| Data Lake Storage Gen2 | https://\<storage-account-name\>.dfs.core.windows.net |
| Azure Files | https://\<storage-account-name\>.file.core.windows.net |
| Queue Storage | https://\<storage-account-name\>.queue.core.windows.net |
| Table Storage | https://\<storage-account-name\>.table.core.windows.net |


### Azure Storage Redundancy
Azure Storage always stores multiple copies of our data so that it's protected from planned and unplanned events such as transient hardware failures, network or power outages, and natural disasters. Redundancy ensures that our storage account meets its availability and durability targets even in the face of failures.

Data in an Azure Storage account is always replicated three times in the primary region:
- locally redundant storage (LRS) - replicates data three times within a single data center in the primary region.
- zone-redundant storage (ZRS) - replicates data synchronously across three Azure availability zones in the primary region.


For applications requiring higher durability, we can choose to additionally copy the data to a secondary region:
- geo-redundant storage (GRS) - copies data synchronously three times in the primary region and then copies it asynchronously to a secondary region using LRS.
- geo-zone-redundant storage (GZRS) - copies data across three Azure availability zones in the primary region (similar to ZRS) and then replicates it asynchronously to a secondary region using LRS.

By default, data in the secondary region is not available for read or write access unless there is a failover event. Because data is replicated to the secondary region asynchronously, a failure that affects the primary region may result in data loss if the primary region can't be recovered.

### Azure Storage Services
Azure Storage platform provides
- **Azure Blobs** - a massively scalable object store for text and binary data. Also including support for big data analytics through Data Lake Storage Gen2.
- **Azure Files** - managed file shares for cloud or on-premises deployments.
- **Azure Queues** - a messaging store for reliable messaging between application components.
- **Azure Disks** - block-level storage volumes for Azure VMs.
- **Azure Tables** - NoSQL table option for structured, non-relational data.