# DevSecOps Workshops: Docker Hub & Github Actions

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 1.7.4.

In this workshop, we're going to optimize the current CI pipeline in Github Actions. The current pipeline runs one job, with three steps:

<li>Build a container image based on `node` version 8 (alpine), and adding to it all required application dependencies from the `package.json` file. You can check `base.Dockerfile`.</li>
<li>Run a multi-stage docker build in which we use the previous image to build our application and generate the frontend files (stage 1), then we move these files to an Nginx container so they can be served from there (stage2). The resulting container will be the on based on Nginx (last stage). You can check `Dockerfile`.</li>
<li>We test our web app from the last container image we built by running it on port `80` and using `curl localhost`.</li>

## Tasks:

The problem here is that these job steps always run and take some time. A viable solution will be to skip the first step if we already have a `node` image with all required dependencies from the previous build. Dependencies are written in the `package.json` file. So only changes to that file should cause us to build a new `node` image.

We can detect changes to a file by running `sha1sum /path/to/file` to generate a hash, and compare it with an older hash. The hash string is a bit long and generally speaking we can just use the 15 first characters ro so from each hash.

Before proceeding to build a `node` image in the first step, we can first check if we have an image named `<username>/base-front:<hash>` in our Docker Hub. We'll have to set up a `token` in our Docker Hub account, save it as a `secret` in our repository settings and move it to an `environment variable` in our workflow file. Assuming we've set up `DOCKER_TOKEN` as environment variable, `DOCKER_USER` as a variable with our Docker Hub user, `FRONT_IMG_TAG` is the first 15 characters of our current `package.json` file `sha1sum` hash, and our `node` image is named `base-front`, the following command can help us retrieve our image fron Docker Hub:

```bash
wget -O - --user $DOCKER_USER --password $DOCKER_TOKEN https://registry.hub.docker.com/v2/repositories/$DOCKER_USER/base-front/tags | grep $FRONT_IMG_TAG
```

If that doesn't return anything, then we dont have that image with that tag in our Docker Hub and we can proceed to building it as usual. We'll have to use `docker login` and `docker logout` commands. In the second step, we can proceed to pulling the image `<username>/base-front:<hash>` and tagging it simply `base-front` so that the `Dockerfile` multistage build works fine.

Anothing we can add at the end is to push the final resulting `nginx` container to our Docker Hub (for example `<username>/front-app:latest`).
