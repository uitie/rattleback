# S3 Exemplar

This should be taken as the gold standard for an S3 bucket.  The bucket:

1. Is Private
2. Is Encrypted
3. Is Versioned
4. Has Access Logging
5. Is Tagged

There are actually 2 sets of buckets created here.  The first uses the older deprecated fields.  The second uses the newer style.

Each of these can be separately disabled via vars.
