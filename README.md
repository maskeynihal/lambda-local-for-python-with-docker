## Run lambda function locally with docker image.

---

### For Python

---

### Steps

- Build the docker image
  - `docker build --rm -t py_test .`
- Run docker image
  - `docker run -p 9000:8080 --rm -it py_test:latest`
- Run curl to test
  - `curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"body": "Enter something that you want to get in return"}' 16:54:35`
  ```
  // Response
  {"statusCode": 200, "body": {"input": "Enter something that you want to get in return", "randomNumber": "{\"0\":6,\"1\":1,\"2\":5,\"3\":1,\"4\":1,\"5\":0,\"6\":1,\"7\":2,\"8\":4,\"9\":6}"}}
  ```
