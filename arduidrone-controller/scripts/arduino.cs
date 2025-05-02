using Godot;
using System;
using System.IO.Ports;

public partial class arduino : Node
{
	SerialPort serialPort;
	
	public override void _Ready()
	{
		serialPort = new SerialPort("COM4", 115200);
		serialPort.Open();
	}
	
	public override void _Process(double delta)
	{
		if(!serialPort.IsOpen) return;
		string serialMessage = serialPort.ReadExisting();
		if(serialMessage != "") GD.Print(serialMessage);
	}
}
