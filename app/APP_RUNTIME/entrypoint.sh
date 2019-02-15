#!/bin/sh

java -javaagent:/opt/ca/springbootApp/wily/Agent.jar -Dcom.wily.introscope.agentProfile=/opt/ca/springbootApp/wily/core/config/IntroscopeAgent.profile -Dintroscope.agent.defaultProcessName=SpringbootProcess -Dintroscope.agent.hostName=DevOpsHost -Dintroscope.agent.agentName=InventoryTrackingService  -jar /opt/ca/springbootApp/InventoryTrackingService.jar 
