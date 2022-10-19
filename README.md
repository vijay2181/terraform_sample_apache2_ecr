Lower Environment Depolyment Notes Automation
---------------------------------------

This document outlines how to produce deployment Notes for all Lower Environments, These steps are designed for brevity and repeatability.

### Please note the following things before you start working on this.

Copy the below Sample YAML content to services.yml file and modify According to Requirement and Order of Service Catalouge

```

---
services:
    ahr: 
      version: 1.2
      variables: 
          NS_FILTER: "TEST1 TEST2 TEST3"
          RLE_SERVICE: "activity history rest"
          RLL_SERVICE: "activity history rest1"
      delete:
          OTEL_ENABLED
      deployment: "Rolling"
    crud:
      version: 1.3
      variables: 
          RLE_SERVICE: "CRUD"
      delete:
      deployment: "Restart"

    ahep:
      version: 1.3
      variables: 
          RLE_SERVICE: "AHEP"
      delete:
      deployment: "Restart"

    etl:
      version: 1.40
      variables: 
          JWT_PWD: "ETL"
      delete:
      deployment: "Restart"

    aep:
      version: 1.555
      variables: 
          JWT_PWD: "AEP"
      delete:
      deployment: "Rolling"

    ui:
      version: 1.666
      variables: 
          JWT_PWD: "UI"
      delete:
      deployment: "Restart"

jobs:  
     AuroraExtract:
       version: 1.6
       variables:
       delete:

     li:
       version: 1.2
       variables:
       delete:

     vi:
       version: 1.2
       variables:
       delete:

     PointsExpiryWarning:
       version: 1.4
       variables:
           VIJAY: "KUMAR"
       delete:

 ```

 NOTE: we need to Export Target Environment Variables before Executing the Script

 ```
export AWS_REGION=us-west-2
export RCX_BACKEND=RCX-SEI
export RCX_TENANT=Dev
export AWS_PROFILE=sei

```

```
python3 /home/rcxdev/rcx-devops/infrastructure/scripts/deployment-notes/deployment-notes.py
```
