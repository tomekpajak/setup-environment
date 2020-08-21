# Setup a new environment
My approach to setup a new environment using: chocolatey and boxstarter.
You can choose which script you want to use by looking into the folder `environments`.

First of all, you need to change the execution policy for running powershell scripts by running as admin in powershell console command:
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

Next, you have to choose which environment script you want to use and run setup environment script by
   1. run in cmd:
        ```
        START http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/tomekpajak/setup-environment/master/environments/Home.ps1
        ```
        or
 
   2. clone git repository and run as admin batch script:
        ```
        git clone git@github.com:tomekpajak/setup-environment.git
        Setup-Environment.bat Home
        ```