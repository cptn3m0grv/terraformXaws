provider "aws" {
        access_key = "ASIAWORVRMV5IJUM6Y52"
        secret_key = "8U57rkFdgifPqL59dRCGyxgpCz4AY6ZbkDeZTyXw"
        token = "FwoGZXIvYXdzECwaDO5OsXhZEq7e3eOztCLHAUu4oizf7pGXwrB4WHU17K1puv1/ay4e+FTBil0oOsqaT7isvAgE+8lTgw42wD9COzFguX/+prIVrbYBniZsVVf8suQrAtkoq9XmlYlaVD/jJ9B5gFO0A5MnXTswguZwHwDTIdkPIkbanTvd3PLiKJRpUUuFeQY/wigXkHByaeez8+D6+LC0wfko1aj79YJnypjI8DGngoI0vanHzWQy/rCjcRvVhpLEaaAnqdzsihnAaBOzoQb9HMo/SEBUreahtt56JqStxrEowtSZ9wUyLZrnj+6sk7sOxinF+q7PRXtw665CXYUkbq39Gw5QkYN2M9hlIz02MX16eifI5g=="
        region = "us-east-1"
}

resource "aws_s3_bucket" "buck" {
	
	bucket = "grv411"
	acl = "public-read"
	
	tags = {
		Name = "Bucky"
		Environment = "Dev"
	}
}

resource "aws_s3_bucket_object" "image" {
	depends_on = [ aws_s3_bucket.buck ]
	
	acl = "public-read"
	bucket = "${aws_s3_bucket.buck.bucket}"
	key = "im.jpeg"
	source = "image.jpg"
	content_type = "image/jpeg"
}

###################################################

resource "aws_cloudfront_distribution" "distro" {

	depends_on = [ aws_s3_bucket.buck ]

	origin {
 		domain_name = "${aws_s3_bucket.buck.bucket}.s3.amazonaws.com"
		origin_id = "S3.${aws_s3_bucket.buck.bucket}"
	}
	
	enabled = true
	is_ipv6_enabled = true

	restrictions {
		geo_restriction {
			restriction_type = "none"
		}
	}

	viewer_certificate {
		cloudfront_default_certificate = true
	}
	
	default_cache_behavior {
		allowed_methods = [ "HEAD", "GET" ]
		cached_methods = ["HEAD", "GET" ]
		forwarded_values {
			query_string = false
			cookies {
				forward = "none"
			}
		}
		
		default_ttl = 0
		max_ttl = 3600
		target_origin_id = "S3.${aws_s3_bucket.buck.bucket}"
		viewer_protocol_policy = "redirect-to-https"
		compress = true
	}
}
	
