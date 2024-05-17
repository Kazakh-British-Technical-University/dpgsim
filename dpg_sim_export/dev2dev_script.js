var config = {};
config.userId = "xkhannx";
config.trackingAvailability = true;
config.logLevel = "Error";
config.applicationVersion = "1";
window.devtodev.initialize("ad5b80a1-18f5-0bf3-9bd0-f628f733db8e", config);

function SendPassEvent(json) 
{
	console.log(json);
	var data = JSON.parse(json);
	console.log(data.name);
	window.devtodev.customEvent("Stage", 
	{
			"Scenario name" : data.name,
			"Language" : data.lang,
			"Stage": data.stage,
			"Sound on": data.sound
	});
}

function SendStatsEvent(json) 
{
	console.log(json);
	var data = JSON.parse(json);
	console.log(data.time);
	window.devtodev.customEvent("Stats", 
	{
			"Scenario name" : data.name,
			"Assembly time" : data.time,
			"Assembly mistakes" : data.mistakes,
			"Question tries": data.tries
	});
}