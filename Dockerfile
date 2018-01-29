FROM microsoft/windowsservercore:10.0.14393.2007

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV chocolateyUseWindowsCompression false
ARG MASTER_URL
ENV MASTER_URL=${MASTER_URL}

RUN iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco feature disable --name showDownloadProgress

RUN choco install git -y

ENV JAVA_HOME c:\\Java\\jre1.8.0_91
RUN wget 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=210185' -Outfile 'C:\jreinstaller.exe' ; \
    Start-Process -filepath C:\jreinstaller.exe -passthru -wait -argumentlist "/s,INSTALLDIR=c:\Java\jre1.8.0_91" ; \
    [Environment]::SetEnvironmentVariable(\"PATH\", $env:PATH + \";$env:JAVA_HOME\bin\", [EnvironmentVariableTarget]::Machine); \
    del C:\jreinstaller.exe


RUN (New-Object System.Net.WebClient).DownloadFile('http://download.microsoft.com/download/5/f/7/5f7acaeb-8363-451f-9425-68a90f98b238/visualcppbuildtools_full.exe', 'visualcppbuildtools_full.exe') ; \
    Start-Process .\visualcppbuildtools_full.exe -ArgumentList '/NoRestart /S' -Wait ; \
    rm visualcppbuildtools_full.exe

COPY entrypoint.bat entrypoint.bat

SHELL ["cmd.exe", "/s", "/c", "C:\\entrypoint.bat"]

ADD ${MASTER_URL}/jnlpJars/slave.jar C:\\slave.jar

ENTRYPOINT ["C:\\entrypoint.bat"]
CMD ["cmd"]
