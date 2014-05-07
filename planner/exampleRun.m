clear all
import realAgent
load test


ag = realAgent(5001,self.locations(1));
pause(30)
ag = ag.updateSensors;
ag.goal.location = self.locations(20);

ag = ag.sendCommand;

pause(120)

ag = ag.updateSensors;

ag.goal.location = self.locations(28);

ag = ag.sendCommand;

pause(30)

ag = ag.updateSensors;

ag = ag.sendCommand;

pause(30)

ag = ag.updateSensors;

ag = ag.sendCommand;

pause(30)

ag = ag.updateSensors;

ag = ag.sendCommand;

pause(30)

ag = ag.updateSensors;

ag = ag.sendCommand;

pause(30)

ag = ag.updateSensors;

ag = ag.sendCommand;

pause(30)

ag.destroy;
