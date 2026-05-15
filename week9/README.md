# Q & A

## Load Balancers

### How does load balancing contribute to Fault tolerance? What about high availability?

Load balancing contributes to fault tolerance because traffic is not tied to one single VM. If one instance fails, the load balancer can stop sending traffic to that bad backend and keep sending traffic to the healthy ones.

Google’s load balancing docs describe load balancers as distributing traffic across backend services and using health checks to help send traffic only to healthy instances.

### Do global load balancers decrease latency for end users? Why or why not?

Global load balancers can decrease latency because users connect to a Google edge location close to them through an anycast IP address. From there, Google can route the request across its network to the correct backend. But this does not magically make every application fast. If the backend is still very far away, or the content is not cached, the request still has to reach that backend. So I would say global load balancing helps reduce latency, but the full benefit is stronger when backends are placed in multiple regions or Cloud CDN is used with it.

### What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy?

Load balancer health checks are used to decide if a backend instance is healthy or not. Without a health check, the lb might keep sending user to the broken VM, which defeats the purpose(Fault tolerance) of having multiple backends.

A load balancer can be a reverse proxy, especially with Application Load Balancers, because the client connects to the load balancer and the load balancer forwards the request to the backend

### What are LB routing rules and URL maps for? Give an example or two of them in use.

Routing rules and URL maps tell the load balancer where to send traffic based on the request. For example, traffic to `/api/*` could go to an application backend, while traffic to `/images/*` could go to a Cloud Storage backend bucket.

URL maps let one load balancer act like a traffic director for different parts of the same application. Google’s docs define a URL map as a set of rules for routing HTTP(S) requests to backend services or backend buckets.

### Explain what an anycast IP address is used for in the context of a global load balancer.

An anycast IP is a single IP address that can be announced from many locations. With a global load balancer, it means users can connect to the same public ip from anywhere in the world by accessing Google network from a local edge location. This allows the app to have one frontend IP but still use Googles global backend.

---

## Cloud Armor

### What does cloud armor offer?

It provides protection for applications on the internet. This includes protection from DDoS attacks, WAF, bot protection and security policies that will allow, deny, redirect or rate limit traffic. IT's basically a security checkpoint in from of the application.

### Why is it used in the first place?

It blocks and slows down any unwanted traffic at the edge before it burns into backend rsources which allows real users access but blocks bad actors.

### What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?

Cloud Armor mainly operates at the application layer where it can look at web requests, URLs, headers, and any suspicious. VPC firewall rules are more basic because they mostly allow or block traffic by port, protocol, IP range, or network tag.

### What are rate based rules for?

Rate based rules control how many requests a client can make in a certain amount of time.This provides protection from bots, attackers or an overflow of traffic. As an example, Cloud Armor can slow down or block an IP that keeps hitting a login page.

### What is reCAPTCHA and how does it relate to this service?

reCAPTCHA is a tool for detecting bots. It is used by Cloud Armor to provide challenges to any attempts to access a page. This prevents scraping, fake signups, attacks, etc.

---

## Cloud CDN

### What are POPs used for?

POPs are edge locations closer to users. Cloud CDN uses them to serve cached content faster and reduce the work for the origin server.

### What kind of files are served with Cloud CDN?

Cloud CDN is best for cacheable web content. This includes images, videos, downloads, etc. and works best when many users request the same content.

### What services can be used with Cloud CDN for the source of content, the origin?

Cloud CDN can use backend services and backend buckets through an external Application Load Balancer. These include VMs, managed instance groups and Cloud Storage buckets.

### Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain.

Cloud CDN can help during some traffic spikes because cached content is served from the edge which means every request does not have to hit the origin server. However, Cloud CDN is not a full on security tool which is why it is often paired with Cloud Armor

### Should an enterprise always use Cloud CDN? Why or why not?

No, an enterprise should not always use Cloud CDN just because it exists. It is useful for static or cacheable content and global users. On the other hand, it may not be useful for private or sensitive content

### What is TTL and how does it control content freshness?

TTL means “time to live.” and it controls how long content stays cached before Cloud CDN checks for a newer version. A longer TTL improves speed, while a shorter TTL keeps content fresher.

---

# RUNBOOK

## Goal: a fully configured external application global load balancer via Clickops

The goal is to create a global external Application Load Balancer using the Google Cloud Console. This load balancer will use a managed instance group as the backend, use a required health check, and expose the application through one public frontend IP address. The MIG should already be serving HTTP traffic on port 80.

## Requirements

In order to accomplish this goal you will need the following:

- Google Cloud project with billing enabled.
- Compute Engine API enabled.
- Permission to create load balancers, backend services, health checks, frontend IPs, URL maps, and firewall rules.
- A working managed instance group already created.
- MIG instances running a web service on port 80.
- MIG has a named port configured to 80.
- A firewall rule that allows load balancer and health check traffic to reach the backend instances.
- Startup script already tested.
- Network tag on the MIG instances for example `http-server`.
- Region and zones selected for the MIG.

## Create the global external Application Load Balancer

1. Navigate to **Network services > Load balancing**. Use search if needed.
2. Click **Create load balancer**.
3. Select **Application Load Balancer**.
4. Choose **Public facing(external)**.
5. Choose **Global("Best for global workloads")**.
6. Choose **Global exteranl applciation load balancer** under load balancer generation.
7. Click **Configure**.

## Configure the frontend

1. Give the frontend a name, such as `frontend-http`. All lower case.
2. Use the same name for the description.
3. Protocol: `HTTP`
4. Port: `80`
5. Click **Done**.

## Configure the backend service

1. Go to **Backend configuration**.
2. Create a new backend service.
3. Name it something clear, such as:

   ```text
   backend-mig-http
   ```

4. MOst of the east you can keep the default.
5. Backend type: `Instance group`
6. Protocol: `HTTP`
7. Named port: `http`

## Create the health check

1. In the backend service section, click **Create a health check**.
2. Give it a name and keep most of the defaults.
3. Protocol: `HTTP`
4. Port: `80`
5. Turn on logs.
6. Check interval can stay at the default.
7. Timeout can stay at the default.
8. Click **Save**.

## Add the backend

1. Click **New backend**.
2. Add your managed instance group as the backend.
3. Port number: `80`
4. Leave balancing mode as the default.
5. Click **Create**.

## Configure routing rules and URL map

1. Go to **Routing rules**.
2. Use the default **simple host and path**.
3. Set the default backend your backend.
4. Confirm all unmatched traffic goes to the MIG backend.

## Review and create

1. Click **Review and finalize**.
2. Confirm the frontend is using HTTP port `80`.
3. Confirm the backend is the correct MIG.
4. Confirm the health check is attached.
5. Confirm the named port is `http`.
6. Confirm there are no warnings about firewall rules.
7. Click **Create**.

The load balancer may take a few minutes to become fully ready.

## Verify the load balancer

1. Go to **Network services > Load balancing**.
2. Open the load balancer.
3. Confirm the backend service shows as healthy.
4. Copy the frontend IP address.
5. Open the IP address in a browser:

   ```text
   http://LOAD_BALANCER_IP
   ```

6. Confirm the webpage loads.
7. Confirm the page shows the VM metadata from one of the MIG instances.
8. Refresh the page a few times.
9. If multiple instances exist, confirm traffic can reach healthy instances in the group.

You can also test from terminal:

```bash
curl http://LOAD_BALANCER_IP
```

## Troubleshooting unhealthy backends

If the backend is unhealthy, check these first:

- Health check path is correct.
- Health check port is `80`.
- Firewall allows health check ranges.
- MIG has the correct named port.
- Backend service points to the correct MIG.
- VM has the correct network tag.

Google’s health check docs explain that load balancers use health checks so that only healthy backends receive traffic.
