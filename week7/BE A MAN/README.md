# GCP Static Website Lab with Terraform

## Website URL

My static website is live here:

https://storage.googleapis.com/gcplab-site/index.html

## What This Lab Was

This lab was a proof-of-concept static website hosted from a Google Cloud Storage bucket and automated with Terraform.

The goal was not to build a full production web application. The goal was to prove that I could use Terraform to create the infrastructure, upload static assets, make the bucket publicly readable, configure the bucket for static website hosting, and output a clickable URL.

In plain English, this lab creates a small public website using GCP storage instead of a traditional web server.

## What This Lab Accomplishes

This project uses Terraform to:

- Create a Google Cloud Storage bucket
- Configure the bucket for static website hosting
- Upload static website files into the bucket
- Make the objects publicly readable
- Output the public URL for the `index.html` page

The site is made from static files only. That means HTML, CSS, and images. There is no backend server, no database, no login system, and no dynamic application logic.

For this lab, that is the point. It is simple, cheap, and easy to verify.

## Terraform Resources Used

The main Terraform resources used in this lab were:

```hcl
google_storage_bucket
google_storage_bucket_object
```

### `google_storage_bucket`

This creates the actual GCS bucket.

Additional settings include:

```hcl
storage_class = STANDARD
```

This setting stores the website files in normal, frequently accessed storage

```hcl
location = US-CENTRAL1
```

This setting tells GCP wher the bucket lives geographically.

```hcl
force_destroy = true
```

This allows Terraform to destroy the bucket even if objects are still inside it.

```hcl
uniform_bucket_level_access = true
```

This keeps access control at the bucket IAM level instead of trying to manage object ACLs one by one.


The website block tells GCS which file should act as the homepage and which file should be used as the error page:

```hcl
website {
  main_page_suffix = "index.html"
  not_found_page   = "404.html"
}
```

### `google_storage_bucket_object`

This uploads the website files into the bucket.

The required files for this lab were:

- `index.html`
- `404.html`
- `style.css`
- An image file

Each file is uploaded as its own Terraform object resource. I kept this simple on purpose. The assignment wanted the resources written clearly and copy/paste is fine as long as I understand what each part does.

### `google_storage_bucket_iam_member`(I did this portiong in the console)

This makes the bucket objects publicly readable.

The key role was:

```hcl
roles/storage.objectViewer
```

The member was:

```hcl
allUsers
```

This matters because `allUsers` means anonymous users on the internet can read the objects.

One thing I learned the hard way is that `roles/storage.bucketViewer` is not enough. That role lets people view bucket information, but it does not let them read the actual files. For a public website, the important permission is object access, so the correct role is `roles/storage.objectViewer`.

## What I Learned

The biggest thing I learned is that GCS static website hosting is different from AWS S3 static website hosting.

In AWS, you often get a special static website endpoint. In GCP, for this lab, the working public URL is the object URL:

```text
https://storage.googleapis.com/gcplab-site/index.html
```

I also learned that the `gs://` path is not a browser URL. This:

```text
gs://gcplab-site/index.html
```

is useful for `gcloud` commands, but it is not something I can open directly in a browser.

The browser URL needs to be:

```text
https://storage.googleapis.com/gcplab-site/index.html
```

Another issue I ran into was public access. At first, I made the bucket public in the wrong way. The bucket showed `allUsers`, but it had the wrong role. The site still returned a `403 Forbidden` error because anonymous users did not have `storage.objects.get`.

The fix was to use:

```hcl
role   = "roles/storage.objectViewer"
member = "allUsers"
```

That gave public users permission to read the actual website files.

I also had to be careful with Terraform resource names. Terraform does not reference the cloud bucket name directly. It references the Terraform resource name. For example:

```hcl
google_storage_bucket.gcplab.name
```

That is different from the actual bucket name:

```text
gcplab-site
```


This is not a full production application architecture. It is a simple static website hosting pattern.

## How to Run This Project

From the project folder, run:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

After apply is completed, Terraform should output the website URL.

Run the following to see the output:

```bash
terraform output
```

to print only the index page URL:

```bash
terraform output -raw index_url
```

To test the site from the terminal:

```bash
curl -I https://storage.googleapis.com/gcplab-site/index.html
```

A successful public response should return something like:

```text
HTTP/1.1 200 OK
```

## Documentation Used

### General Documentation

These were used to understand the overall lab and how GCS static website hosting works:

- Google Cloud Storage static website hosting documentation:  
  https://docs.cloud.google.com/storage/docs/hosting-static-website


### Terraform Resource Documentation

These were used for specific Terraform resources in the code:

- `google_storage_bucket`:  
  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

- `google_storage_bucket_object`:  
  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object

- `google_storage_bucket_iam_member`:  
  https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam

### Public Access Documentation

These were used to understand how to make the bucket objects publicly readable:

- Making Cloud Storage data public:  
  https://docs.cloud.google.com/storage/docs/access-control/making-data-public

- Cloud Storage IAM roles:  
  https://docs.cloud.google.com/storage/docs/access-control/iam-roles

## Final Notes

This lab looked simple at first, but there were a few real lessons inside it.

The main lesson was that creating a bucket is only one part of the job. The objects have to be uploaded, the bucket has to be configured correctly, the IAM role has to allow public object reads, and the final URL has to point to the correct object.

The final result is a small static website hosted from a GCP bucket and managed through Terraform.
