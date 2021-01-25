(DEPRECATED): please visit [pysecrets](https://github.com/nckslvrmn/pysecrets)
=======

Ephemeral Secrets
=======

A light-weight, ephemeral secret sharing service. Secrets uses the latest AES and KDF encryption standards to ensure the confidentiality, integrity, and authenticity of data sent through the service (via the [simple_crypt](https://github.com/nckslvrmn/simple_crypt) gem).

## Getting Started

Secrets requires openssl version 1.1.0 or greater to support the mode of encryption used by the service. For instructions on installation of the latest version, plese refer to OpenSSL's [readme](https://github.com/openssl/openssl/blob/master/INSTALL), or check your OS'es package manager.
Secrets is also intended to run as AWS Lambda functions, with a static UI hosted in a place of your choosing.

## Dependencies

Secrets uses an AWS Dynamo DB table for storing all of its string secrets and an S3 bucket for encrypted files. Secrets requires that the role the Lambda executes with has the proper permissions to the Dynamo Table and S3 Bucket.
The Dynamo table and S3 Bucket need to exist beforehand.

## Installation

Once the dependencies have been set up, begin by running `./make all`.
This will build the Lambda layer and function zip files that will be uploaded to AWS.

## Configuration

To ensure the best security practices, the methods used for KDF and encryption/decryption have been baked into the code itself.
There are a few options that can be configured. All of these should be passed in to the functions.

Within the environments hash, the options are:

VARIABLE     | DEFAULT | DESCRIPTION
-------------|---------|---------------------------------------------------------
TTL_DAYS     | 5       | Configures the TTL that the secret records will have in Dynamo.
S3_BUCKET    | nil     | Tells the server in which S3 bucket to store encrypted files.

## Notes

Ephemeral Secret service utilizes the best in business algorithms and functions for proper encryption at rest that guarantees information security. More on that can be read about [here](https://github.com/nckslvrmn/simple_crypt#security-features). There is another domain of security however not covered by the service itself. That is encryption in transit. As previously mentioned, an nginx configuration file is provided that can serve as the web server proxy. It is highly reccomended to follow or use this configuration as it contains all the options required for modern best practices on encryption in transit. When configuring these best practice options, there is a somewhat significant reduction in comptibility for older devices but considering the security gains this is a worthwhile sacrifice.

## Licensing

This project is licensed under the terms of the MIT License.
