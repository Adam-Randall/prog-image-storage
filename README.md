## Prog Image Storage Microservice

This is a Ruby Grape Rest API application. It allows consumers to upload images to the cloud and convert the images based on request_url type. See [here](https://github.com/Adam-Randall/prog-image-storage/blob/master/CHALLENGE.md)for related questions

### Run Locally

1. Install ruby 2.5.1 - `rvm install ruby-2.5.1`
2. Install bundler `gem install bundler`
3. Install required libraries for application `bundle install`
4. The following environment variables are required and need to be defined in config/application.yml (see config/application.sample).

* `region: eu-west-1`  - AWS Region
* `aws_access_key_id: XXXXXXXXXXXX` - AWS Access Key id
* `aws_secret_access_key: XXXXXXXXXXXX` - AWS Secret Access Key id
* `bucket_name: prog-images-test` - Unique Bucket Name to store files
* `provider: AWS` - Cloud provider - can be extend to support more

5. Start the ruby server `bin/server`

### Run via Docker 

```
docker build -t prog-image-ms .

docker run -e "region=eu-west-1" \
-e "aws_access_key_id=XXXXXXXXXXXX" \
-e "aws_secret_access_key=XXXXXXXXXXX" \
-e "bucket_name=prog-images-test" \
-e "provider=AWS" \
-it -p 3006:3006 prog-image-ms
```


### API Endpoints

```
# Healthcheck
curl localhost:3006/health

# API / Service Version
curl localhost:3006/version

# Upload Image - /v1.0/images/upload
curl --form image_file=@image localhost:3006/v1.0/images/upload

# Return Image with different format - /v1.0/images/convert
curl --form request_url='https://BUCKETNAME.s3.eu-west-1.amazonaws.com/IMAGE_NAME_WITH_NEW_EXTENSION' \
localhost:3006/v1.0/images/convert
```
