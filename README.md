# JMeter Playground

![jMeter]
(/readme_meta/jmeter_logo.png)

# Use Case

In order to learn jMeter, we prepared a use case:

  1. Environment Setup
  
    [1.1 Windows](#1.1)

    [1.2 MacOs](#1.2)
    
    [1.3 Linux](#1.3)
    
    [1.4 Docker container](#1.4)

  2. jMeter Test Plan Elements

    [2.1 Thread Group](#2.1)
    
    [2.2 Variables](#2.2)
    
    [2.3 While Controller](#2.3)
    
    [2.4 Counter](#2.4)
    
    [2.5 Http Requests](#2.5)
    
    [2.6 View Results Tree](#2.6)

  3. jMeter Test Script
  
    [3.1 jMeter Script Guide](#3.1)

    [3.2 jMeter PowerPoint Presentation](#3.2)

  4. Core Concepts
  
    [4.1 OSI Layers](#4.1)

    [4.1 DNS](#4.1)
    
---

## 1. Environment Setup

There are a few differences in configuration based on your operating system. 


### 1.1 Windows Setup <a name="1.1"></a>

For the windows platform we have TWO WAYS of configuring the environment. We will first take the more simple approach, install windows apps and libraries via the Chocolatey package manager. 

#### I. SETUP WITH PACKAGE MANAGER - Chocolatey (quick and easy setup)
---
```
https://chocolatey.org/
```
Go to chocolatey page, download and install the kit.

After chocolatey has been setup, open a terminal and run the commands:

```choco install jdk8```
The command will install JDK 8 and setup the Java and the Java_Home environment variables

```choco install jmeter```
The command will setup jMeter on the machine.

You should now have a working windows environment for implementing some jMeter scripts. You can double check the installation of the JDK by running:
```java -version```

#### II. SETUP MANUALLY (the long road setup)
---
Depending on the Windows OS version you might be required to install the dependencies manually.

You will need to download the java JDK resource:
```
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```

You will need to download the jMeter binaries:
```
https://jmeter.apache.org/download_jmeter.cgi
```

Once you have downloaded the installation kit, run and go through the Java JDK installation. You will then need to add the JDK path to the Environment variables. This is needed due to jMeter relying on Java to run, so it needs to be aware where the JDK is located.

To Edit the <b>Environment Variables </b> For this right click My Computer, go to Properties. Open the Advanced System Settings.
In the Advanced Tab click on the Environment Variables. Under the Systems Variables section add the following.
Go to your Program Files and then Java folder and find the JDK you have just setup. Copy the path.

I. Create a new variable named <b>JAVA_HOME</b> and the value should be the jdk path on your system (e.g. C:\Program Files\Java\jdk1.8)

II. Create a second variable named <b>JAVA</b> and the value should be:
```
%JAVA_HOME%\bin
```
III. Add the JAVA variable to the <b>PATH</b> variable. Add the value to the existing values of the PATH.
```
;%JAVA%;
```

paste this at the end of the PATH variable present in the System variables section. 

!!DON’T CLEAR THE PATH VARIABLE CONTENT. IT WILL BREAK YOUR SYSTEM.!!

---

Once you have completed these steps, your jMeter should be running with no issues.


### 1.2 MacOS Setup <a name="1.2"></a>

Like with Windows, we can either use a package manager to install the needed applications or we can do it manually.

#### I. Setup via Homebrew

```
https://brew.sh/
```
Installation instructions can be found on the brew website, but we will provide quick reference code snippets. So the next command will actually install homebrew, you can find the same command on their website.
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Once you have installed homebrew, you will need to add versions repositories, so we setup a stable version of Java.
```
brew tap caskroom/versions
```
You should now be able to install Java JDK 8 by running:
```
brew cask install java8
```
Now you just need to install jMeter and all is done:
```
brew install jmeter --with-plugins
```
You can now open jMeter by running:
```
open /usr/local/bin/jmeter
```


### 1.3 Linux Setup <a name="1.3"></a>

Setup guide is done with Ubuntu/Debian based linux distributions.

#### OpenJDK

Linux systems will usually have an openJDK installed, so this step might be skipped. 
You will need to run the following commands in sequence.
```
sudo apt update
```
Will update the repositories list.
```
sudo apt install openjdk-8-jdk
```
It will install open JDK on your machine

```
sudo apt install jmeter
```

#### Oracle JDK

Alternatively, you can install the oracle JDK
```
add-apt-repository ppa:webupd8team/java
```
It will add repository for oracle packages

```
apt update
```
Will update the list of dependencies on your computer

```
apt install oracle-java8-installer
```
Will install oracle JDK 8


#### jMeter setup

We will be grabbing the binary of the jMeter extract and install it.

```
wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-5.1.1.tgz
```
will download the jMeter kit

```
tar -zxvf apache-jmeter-5.1.1.tgz
```
will extract the jmeter achive

```
cd apache-jmeter-5.1.1/bin/
```
move the shell to the jmeter runner

```
chmod +x jmeter
```
provide execution right to jMeter. Note that this may vary based on your system security restrictions.

```
./jmeter
```
will run the jMeter application

---

### 1.3 Container Setup <a name="1.4"></a>

If you dont want to pollute your OS you can alternatively setup Docker on your machine and prepare an Image that has java and jMeter setup on it. We can then run that image as a container and work on a clean environment.

Root image documentation: https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/


You should be able to create a Dockerfile with the following content.
```
FROM dorowu/ubuntu-desktop-lxde-vnc

COPY . /app
WORKDIR /app

RUN apt-get update \
    && apt-get install openjdk-8-jdk -y \
    && apt-get install wget -y \
    && wget -c http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-5.1.1.tgz \
    && tar -xf apache-jmeter-5.1.1.tgz \
    && alias jmeter5='apache-jmeter-5.1.1/bin/jmeter'

ENTRYPOINT["jmeter5"]
```

The Dockerfile will be setting up the JDK8 and the jMeter on the image. 
Once that is done, you can build your image and run it.

```
docker build -t jmeterImage .
```
Create docker image based on our Dockerfile

```
docker run -p 6080:80 -v /dev/shm:/dev/shm jmeterImage
```
Run docker container. If the container is up and running you can access it via a browser by navigating to:

```
http://127.0.0.1:6080/
```
Note that you have a clipboard tool (on the browser VNC window) on the middle left of your screen.

---


#2. jMeter Test Plan Elements

There are a few elements in the test script we should get familiar with before starting. Please have a look at the jMeter documentation for any further clarifications.

Documentation: https://jmeter.apache.org/usermanual/test_plan.html


## 2.1 Thread Group <a name="2.1"></a>

The Thread Group controls the flow of the script. Each element will be executed in sequence from top to bottom, thus running the testing scenario. There are options for controlling the number of concurrent users, essentially how many instances of the thread should be created. The Ramp up period can also be adjusted (in how much time should x threads be created) and scheduling options. 

![Thread]
(/readme_meta/thread_view.png)

For the purpose of this exercise we will leave the options as they are, but it is important to note that this is the element we will be using for script run orchestration.

Documentation: https://jmeter.apache.org/usermanual/build-web-test-plan.html

 
## 2.2 Variables <a name="2.1"></a>

Variables can be defined, referenced and used across all jMeter elements. With certain controllers we can define variables, as we can see in the Counter Element, we use the 'counter' word to define our variable.

![Variables]
(/readme_meta/counter_view.png)

If we would want to use the variable we can reference it so:

```
${counterName}
```
  
The defined variables can be then referenced as we can also see in the Http Request element. The URL uses a variable:
```
ServerName
```

![Http Request]
(/readme_meta/http_view.png)

Documentation: https://jmeter.apache.org/usermanual/test_plan.html#using_variables


## 2.3 While Controller <a name="2.1"></a>
 
With the while controller we will handle all the subsequent link requests we will find in the pages we open. The basic assumption we will be making is that the number of explored links and the number of found links is different. If this condition is met then it means we have navigated through all the links we have found.

![While]
(/readme_meta/while_view.png)

We will create a variable called <b>breakWhile</b> and we will initialize it with false.

![While]
(/readme_meta/while_view_2.png)

Later, in the element where we form our list of links we will also check and compare the counter (number of visited links) with the myList (list of all the links found) and set the <b>breakWhile</b> to true if they match.
 
Documentation: https://jmeter.apache.org/usermanual/test_plan.html#config_elements

Documentation: https://jmeter.apache.org/usermanual/component_reference.html#While_Controller


## 2.4 Counter <a name="2.1"></a>
    
The counter element does exactly what it says. It will count from a defined starting value and you can also set the step of the counter (how much to increment each time). We will be suing the counter variable reference in other controllers there the script logic requires it.

![Counter]
(/readme_meta/counter_view.png)

Documentation: https://jmeter.apache.org/usermanual/component_reference.html#Counter


## 2.5 Http Requests <a name="2.1"></a>
    
The Http Request element is one of the most commonly used elements in jMeter. The element itself is a template of an HTTP request. We populate the template with our intended request specification. 

![Http]
(/readme_meta/http_view.png)

We can add Header elements to it and Authentication elements. We can also add pre-processors (pre-request executed) and post-processors (post request executions) elements that will handle any processing needed for our request. 

Documentation: https://jmeter.apache.org/usermanual/component_reference.html#HTTP_Request


## 2.6 View Results Tree <a name="2.1"></a>
    
The View Results Tree is a Debugging element that we can use to inspect executed requests. The component itself has 3 main views. 

The Sampler view, that shows the duration of the request, size and other collected metrics

The Request view, shows the details the Http request has been populated with before sending it over the wire.

The Response view, shows the details received (like response body, cookies set and so on) from the machine we are tring to communicate with.

![View Results Tree]
(/readme_meta/viewResultsTree_view.png)

Documentation: https://jmeter.apache.org/usermanual/component_reference.html#View_Results_Tree

---
# 3. jMeter Script


As part of the workshop we will be focusing on building a web crawler. 

A Web crawler, sometimes called a spider or spiderbot and often shortened to crawler, is an Internet bot that systematically browses the World Wide Web, typically for the purpose of Web indexing (web spidering).

So for our use case, we will be creating a script that gets a starting URL and will start crawling through all the links it can find.

Source: https://en.wikipedia.org/wiki/Web_crawler

---

## 3.1 jMeter Script Guide <a name="3.1"></a>

You can find the Video Tutorial guide setting up the test script here:

[![jMeter Script Creation Tutorial](/readme_meta/thumb_youtube.png)]
(https://www.youtube.com/embed/b8qQGMo93hk)

Alternatively, if you get stuck, you can look up the jMeter script provided in the repository. 

<a href="/support_materials/perPlay.jmx"> JMX File
<img src="/readme_meta/icon_script.png" align="center" width="100">
</a>

---
## 3.2 jMeter PowerPoint Presentation <a name="3.2"></a>

The details captured in this Readme documentation, were created in scope of the jMeter presentation that you can find here: 

<a href="https://docs.google.com/presentation/d/1z-gkLUyt__NAKthW9YAP5lpX9CoCHa-oJMRBS_62f9E/edit?usp=sharing"> PPT Presentation
<img src="/readme_meta/pres_logo.png" align="center" width="100">
</a>


