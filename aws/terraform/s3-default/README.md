# Default S3 bucket

A default S3 bucket is a very bad thing, and has the following issues:

1. Is not encrypted
2. Does not have Access logs
3. Is not versioned
4. Isn't tagged or inventoried in any way.

Additionally, if the defaults are used then the bucket is set to allow public access.

You can check the `../s3-exemplar` test case for what an ideal S3 bucket looks like.
