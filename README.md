# Demo for running a windows jenkins slave in a windows container

This example slave image reuses the msbuild image from https://github.com/StefanScherer/dockerfiles-windows/tree/master/msbuild

The slave contains Java, git and msbuild installed.

## Usage

1. Build the image:

```
docker build --build-arg MASTER_URL=<your_jenkins_master_url> -t myslave .
```

2. Create an agent node on your master. Make sure TCP port for JNLP agents is enabled [details [here] (https://stackoverflow.com/questions/38724448/creating-a-jenkins-slave-via-java-web-start/38740924#38740924)] and anonymous users can create an agent [details [here](https://stackoverflow.com/questions/36502609/how-to-allow-slaves-to-connect-to-jenkins-master-without-secret-jnlp-option)] 

3.Run the slave:

```
docker run -d --name slave1 myslave java -jar C:\slave.jar -jnlpUrl %MASTER_URL%/computer/<your_agent_name>/slave-agent.jnlp -workDir "c:\jenkins\
```
