window.godotFunctions = {};
window.externalator = {
	addGodotFunction: (n,f) => {
		window.godotFunctions[n] = f;
	}
}

function fetchMainConfig() 
{
	fetch("./Data/MainConfig.txt")
		.then(response => response.text())
		.then
		((data) => 
			{
				//console.log("JS: " + data);
				godotFunctions.SendMainConfig(data);
			}
		)
}

function getScenarios() 
{
	fetch("./Data/ScenarioList.txt")
		.then(response => response.json())
		.then
		((data) => 
			{
				for (let index = 0; index < data.ScenarioFiles.length; ++index) 
				{
					//console.log(files[index]);
					fetchScenario("./Data/"+data.ScenarioFiles[index]);
				}
			}
		)
	/*$.getJSON("./Data/Scenarios/", files => {
		for (let index = 0; index < files.length; ++index) 
		{
			//console.log(files[index]);
			fetchScenario("./Data/Scenarios/"+files[index]);
		}
	});*/
}

function fetchScenario(path) 
{
	fetch(path)
		.then(response => response.text())
		.then
		((data) => 
			{
				//console.log("JS: " + data);
				godotFunctions.SendScenarios(data);
			}
		)
}

function fetchTrans() {
	fetch("./Data/Translations.csv")
		.then(response => response.text())
		.then
		((data) => 
			{
				godotFunctions.SendTrans(JSON.stringify(CSVToArray(data, ",")));
				//console.log(JSON.stringify(CSVToArray(data, ",")));
			}
		)
}

function fetchProjects() {
	fetch("./Data/EN/Projects.csv")
		.then(response => response.text())
		.then
		((data) => 
			{
				godotFunctions.SendProjects(JSON.stringify(CSVToArray(data, ",")));
				//console.log(JSON.stringify(CSVToArray(data, ",")));
			}
		)
}

function fetchEvents() {
	fetch("./Data/EN/Events.csv")
		.then(response => response.text())
		.then
		((data) => 
			{
				godotFunctions.SendEvents(JSON.stringify(CSVToArray(data, ",")));
				//console.log(JSON.stringify(CSVToArray(data, ",")));
			}
		)
}

function CSVToArray(strData, strDelimiter) 
{
	var column = 0;
	// Check to see if the delimiter is defined. If not,
	// then default to comma.
	strDelimiter = (strDelimiter || ",");

	// Create a regular expression to parse the CSV values.
	var objPattern = new RegExp
	(
		(
			// Delimiters.
			"(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +

			// Quoted fields.
			"(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +

			// Standard fields.
			"([^\"\\" + strDelimiter + "\\r\\n]*))"
		),
		"gi"
	);

	// Create an array to hold our data. Give the array
	// a default empty first row.
	var arrData = [[]];

	var dict = {};
	var lines = {};
	lines["Lines"] = [];
	// Create an array to hold our individual pattern
	// matching groups.
	var arrMatches = null;

	// Keep looping over the regular expression matches
	// until we can no longer find a match.
	while (arrMatches = objPattern.exec(strData)) 
	{
		// Get the delimiter that was found.
		var strMatchedDelimiter = arrMatches[1];

		// Check to see if the given delimiter has a length
		// (is not the start of string) and if it matches
		// field delimiter. If id does not, then we know
		// that this delimiter is a row delimiter.
		if (
			strMatchedDelimiter.length &&
			strMatchedDelimiter !== strDelimiter
		) {

			// Since we have reached a new row of data,
			// add an empty row to our data array.
			arrData.push([]);

			lines["Lines"].push(dict);
			dict = {};
			column = 0;
		}

		var strMatchedValue;

		// Now that we have our delimiter out of the way,
		// let's check to see which kind of value we
		// captured (quoted or unquoted).
		if (arrMatches[2]) {
			// We found a quoted value. When we capture
			// this value, unescape any double quotes.
			strMatchedValue = arrMatches[2].replace(
				new RegExp("\"\"", "g"),
				"\""
			);
		} else {
			// We found a non-quoted value.
			strMatchedValue = arrMatches[3];
		}

		// Now that we have our value string, let's add
		// it to the data array.
		arrData[arrData.length - 1].push(strMatchedValue);

		dict[column] = strMatchedValue;
		column++;
	}

	// Return the parsed data.
	//return (arrData);
	return (lines);
}

function fetchImage(path) {
	fetch(path)
		.then(response => response.arrayBuffer())
		.then
		((data) => 
			{
				godotFunctions.SendImage(data);
			}
		)
}

function getURLparam(name) 
{
	const queryString = window.location.search;
	const urlParams = new URLSearchParams(queryString);
	godotFunctions.SetLanguage(urlParams.get(name));
}
