within Modelica_DeviceDrivers.Blocks.Examples;
model TestSerialPackager_SharedMemoryExternalTrigger
  "Example for combining externally triggered SharedMemory and SerialPackager blocks"
extends Modelica.Icons.Example;
  Packaging.SerialPackager.Packager
                     packager
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Packaging.SerialPackager.AddReal
                    addReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression[3](y=sin(time)*{1,2,3})
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Packaging.SerialPackager.AddInteger
                       addInteger(nu=1)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.IntegerExpression integerExpression(y=integer(10*sin(
        time)))
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Communication.SharedMemoryWrite sharedMemoryWrite(enableExternalTrigger=true)
                                                    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-68})));
  Packaging.SerialPackager.GetReal
                    getReal(n=3, nu=1)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Packaging.SerialPackager.GetInteger
                       getInteger
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Communication.SharedMemoryRead sharedMemoryRead(enableExternalTrigger=true)
                                                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,50})));
  Modelica.Blocks.Sources.SampleTrigger sampleTrigger(period=0.1, startTime=0)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={0,-90})));
equation
  connect(integerExpression.y, addInteger.u[1]) annotation (Line(
      points={{-59,-30},{-42,-30}},
      color={255,127,0}));
  connect(realExpression.y, addReal.u) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127}));
  connect(packager.pkgOut, addReal.pkgIn) annotation (Line(
      points={{-30,39.2},{-30,20.8}}));
  connect(addReal.pkgOut[1], addInteger.pkgIn) annotation (Line(
      points={{-30,-0.8},{-30,-19.2}}));
  connect(addInteger.pkgOut[1], sharedMemoryWrite.pkgIn) annotation (Line(
      points={{-30,-40.8},{-30,-57.2}}));
  connect(sharedMemoryRead.pkgOut, getReal.pkgIn) annotation (Line(
      points={{50,39.2},{50,0.8}}));
  connect(getReal.pkgOut[1], getInteger.pkgIn) annotation (Line(
      points={{50,-20.8},{50,-39.2}}));
  connect(sampleTrigger.y, sharedMemoryWrite.conditionalExternalTrigger)
    annotation (Line(
      points={{0,-79},{0,-68},{-18,-68}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(sampleTrigger.y, sharedMemoryRead.conditionalExternalTrigger)
    annotation (Line(
      points={{0,-79},{0,50},{38,50}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=5.0),
    Documentation(info="<html>
<p>
The <code>sharedMemoryWrite</code> block writes to the memory partition with <code>memoryID = \"sharedMemory\"</code>. The <code>sharedMemoryRead</code> block reads from that partition.
</p>
<p>
<b>Note:</b> There is no causality between the <code>sharedMemoryWrite</code> block and the <code>sharedMemoryRead</code> block. Therefore the execution order of the blocks is not determined. This indeterminism may also show up in the plots.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end TestSerialPackager_SharedMemoryExternalTrigger;
