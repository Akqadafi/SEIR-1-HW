# Q & A

## 1. What is the difference between high availability and fault tolerance? Which is the best to strive for?

High availability basically emans it's alwasy online or least most of the time. This is accomplished by removing any single point of failue. An example of this is authohealing, where is a VM stops or crahses the VM is automatially recreated based on the original configuration(Templates). Fault tolerance means the system can continue operaing even when parts of it fail. For example, using load balancers to autoscale an instance group provides fault tolerance because if any of one of the intances goes down, the others can still continue. Fault tolerace is preferred.

## 2. Explain the difference between autoscaling and elasticity. What is vertical and horizontal autoscaling? Is one better? Are they feasible on prem?

Autoscalling automatically adds and removes instances based on workload demands. THese are usually set before through the configurtion of autoscaling parameters. Elasticity is when resources adjust based on the needs of the system. Horizonal autoscaling add and/or removes instances while vertical autoscaling changes the actual size  of the instance(CPU, Memory, etc).  Horizontal autoscaling is preferred becuase it increases availability without depending on one larger machine.  On Prem autoscaling is possible but harder. You must own and provision the extra capacity but cloud platforms aloow one to request these resources through API.

## 3. Explain the difference between managed and unmanaged instance groups.

Managed instance groups use instance template to manage multiple identifical VM's. THis allow for autoscaling, autohealing and multi-zone deployment ensuring better availablity than unmanaged instances. THe latter can be diffeferent from each other but you lose the benefit of autoscaling, authohealing, etc. 

## 4. Explain the different use cases for health checks used by applications in instance groups and health checks used by load balancers. Can they be the same? Are they different API calls? Should they be the same?

Load balancer health checks are used to decide whether a backend should keep getting traffic. Autohealing health checks are used to decide whether a VM in a managed instance group needs to be fixed or recreated. They can check the same endpoint, but they should usually be separate because autohealing should be more conservative. Google’s documentationrecommends using separate health checks for load balancing and autohealing.

## 5. Explain in a few sentences what the 3-tier architecture is and how it relates to what you are learning.

The 3 tier architecture refers to set up of load balancers meant to increase availability. The three tiers are Web, Application and Database. Web tier is the frontend seved by external Application load balancers. This tier handles internet traffic which sent to the instance groups in the backend which then serve the Application Load balancers(Tier 2) which deploys and scale according to demand. These load balancers then distribute trrafic to the Database tier, where Network load balancers distribute traffic to data storage backends which may be in different regions. 

# RUNBOOK

## Goal: a fully configured managed instance group created via Clickops 

The goal is to create a regional managed instance group using the Google Cloud Console. The group will be created using a instance template. The group will be distributed across multiple zones, support autoscaling and autohealing. 

## Requirements

In order to accomplish this goal you will need the following: 

- Google Cloud project with billing enabled.
- Compute Engine API enabled.
- IAM access to create instance templates, instance groups, firewall rules, and health checks.
- A VPC network and subnet..
- Startup script ready and tested.

## Create the instance template

1. Go to Compute Engine > Instance templates.
2. Click Create nstance template.
3. Give the template a name(Lower case only)
4. Select your region(Suggest us-central1(Iowa))
5. Under machine type select n2-standard-2.
6. Click Boot disk 
7. In the Operating system dropdown Select the CentOS 
8. In the Version dropdown select CentOS Stream 10.
9. Set the boot disk size to 100 GB.
10. Click select
11. Click Advanced options 
12. Click Networking 
13. In the Network Tags square type in the following: http-server
14. Click Management
15. Under Automation you can Add the startup script(Can be found in the SEIR-1 Github).
16. Click Create

## Create the managed instance group

1. Go to Compute Engine > Instance groups.
2. Click Create instance group.
3. Select New managed instance group.
4. Create a name
5. In the Instance template dropdown choose the instance template created above.
6. Set the location type to Multiple zones.
7. Select the target region.
8. Select at least two zones, preferably three if available.
9. Set the initial number of instances.

## Enable autoscaling

1. Click in the managed instance group Autoscaling configuration.
2. Select mode to On
3. Set a minimum number of instances, such as 2.
4. Set a maximum number of instances(Usually based on cost limits) such as 3 or 5.
5. Choose the autoscaling signal, such as CPU utilization.
6. Set a target CPU utilization, such as 60%.
7. Set an initialization period, 60 seconds would probably suffice.

## Enable  autohealing

1. Under Autohealing click the Health Check box and select create a health check.
2. Give it a name
3. Use the application port 80.
4. Turn logs on
5. Choose an interval and click save
6. Select Create

## Verify multi-zone management

1. Open the managed instance group.
2. Open Details and check if Location features a Region and more than one Zone. 
3. Confirm instances are distributed across multiple zones.
4. Confirm the target distribution shape is appropriate; EVEN is recommended for highly available serving workloads.

## Explain any other critical config explicitly 

# terraform

## 1. THe mandatory arguments for a VM in terraform are the followign 

The required arguments are the VM name, machine type, Boot disk  and network interface.

## Explain how to output the internal and external IP addresses of the provisioned VM and how you figured this out 

The internal IP comes from the VM’s first network interfac.

The external IP comes from the first access_config block on the first network interface:

I figured this out by looking at the structure of the VM resource: the IP addresses live under network_interface and the public NAT IP exists only when access_config {} is present.

## Choose 2 non-required arguments and give an explanation for both (do not copy and paste the reference material) 

### tags

The tags argument adds network tags to the VM. In this lab, tags = ["http-server"] matters because the firewall rule can target only VMs with that tag. 

### metadata_startup_script

This argument runs a startup script when the VM boots. It is not required to create a VM but it is useful because it turns a plain VM into a configured server automatically.

## Explain how you would figure out the correct format for creating a VM with the “centOS stream 10” image (the specific image is up to you). 

I would start with Google’s official Compute Engine OS image documentation and look for the OS row for CentOS Stream 10. That tells me the image project is:

```text
centos-cloud
```

And the x86 image family is:

```text
centos-stream-10
```

Then I can write the Terraform data source like this:

```hcl
data "google_compute_image" "centos_stream_10" {
  family  = "centos-stream-10"
  project = "centos-cloud"
}
```

## Explain the difference between the “name” argument and the computed “id” and “self_link” attributes 

"name" is what I choose, while id and self_link are values returned after Google Cloud creates the VM. The "id" is an identifier for the resource whilte the "self_link" is the URI for the created resource, in this case the image for the centosOS distro.


