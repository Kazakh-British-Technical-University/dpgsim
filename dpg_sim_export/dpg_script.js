window.godotFunctions = {};
window.externalator = {
	addGodotFunction: (n,f) => {
		window.godotFunctions[n] = f;
	}
}

let lang = getURLparam("lang");
if (!lang) {
	lang = "en";
}

function getURLparam(name) 
{
	const queryString = window.location.search;
	const urlParams = new URLSearchParams(queryString);
	return urlParams.get(name);
}

function changeLanguage(newLang)
{
	lang = newLang;
}

function fetchLanguages()
{
	let data
	fetch("./Data/Languages.csv", {cache: "reload"})
		.then(response => response.text())
		.then((data) => 
			godotFunctions.SendLanguages(JSON.stringify(CSVToArray(data, ",")))
		)
}

function fetchMainConfig() 
{
	fetch("./Data/MainConfig.txt", {cache: "reload"})
		.then(response => response.text())
		.then
		((data) => 
			{
				//console.log("JS: " + data);
				godotFunctions.SendMainConfig(data);
			}
		)
}

async function fetchScenarios() {
	let data
	let response = await fetch("./Data/" + lang + "/Scenarios.csv", {cache: "reload"});
	if (response.ok) {
		data = await response.text();
		let obj = CSVToArray(data, ",");
		for (const item of obj.Lines)
		{
			if (item[0] != "ID") 
			{
				let path = "./Data/Scenarios/" + item[3];
				fetch(path, {cache: "reload"})
				.then(response => response.json())
				.then
				((file) => 
					{
						file.Title = item[1];
						file.Description = item[2];
						//console.log("JS: " + JSON.stringify(file));
						godotFunctions.SendScenario(JSON.stringify(file));
					}
				)
			}
		}
	} else {
		console.log("File missing: Scenarios.csv");
	}
}
async function fetchScenario(path) 
{
	fetch(path, {cache: "reload"})
		.then(response => response.text())
		.then
		((data) => 
			{
				console.log("JS: " + data);
				//godotFunctions.SendScenarios(data);
			}
		)
}

function fetchCredits() 
{
	let path = "./Data/" + lang + "/Credits.txt";
	fetch(path, {cache: "reload"})
		.then(response => response.text())
		.then
		((data) => 
			{
				//console.log("JS: " + data);
				godotFunctions.SendCredits(data);
			}
		)
}

async function fetchLocalizedData(filename) {
	let path = "./Data/" + lang + "/" + filename + ".csv";
	let response = await fetch(path, {cache: "reload"});
	if (response.ok) {
		let data = await response.text();
		switch (filename) {
			case "Projects":
				godotFunctions.SendProjects(JSON.stringify(CSVToArray(data, ",")), true);
				break;
			case "Events":
				godotFunctions.SendEvents(JSON.stringify(CSVToArray(data, ",")), true);
				break;
			case "Actions":
				godotFunctions.SendActions(JSON.stringify(CSVToArray(data, ",")), true);
				break;
			case "System":
				godotFunctions.SendTrans(JSON.stringify(CSVToArray(data, ",")));
				break;
			case "Team":
				godotFunctions.SendTeam(JSON.stringify(CSVToArray(data, ",")));
				break;
		}
	} else {
		console.log("File missing: " + path);
	}
}

async function fetchProjects() {
	let data
	let response = await fetch("./Data/Projects.csv", {cache: "reload"});
	if (response.ok) {
		data = await response.text();
		godotFunctions.SendProjects(JSON.stringify(CSVToArray(data, ",")), false);
	} else {
		console.log("File missing: ./Data/Projects.csv");
	}
}

async function fetchEvents() {
	let data
	let response = await fetch("./Data/Events.csv", {cache: "reload"});
	if (response.ok) {
		data = await response.text();
		godotFunctions.SendEvents(JSON.stringify(CSVToArray(data, ",")), false);
	} else {
		console.log("File missing: ./Data/Events.csv");
	}
}

async function fetchActions() {
	let data
	let response = await fetch("./Data/Actions.csv", {cache: "reload"});
	if (response.ok) {
		data = await response.text();
		godotFunctions.SendActions(JSON.stringify(CSVToArray(data, ",")), false);
	} else {
		console.log("File missing: ./Data/Actions.csv");
	}
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
	fetch(path, {cache: "reload"})
		.then(response => response.arrayBuffer())
		.then
		((data) => 
			{
				godotFunctions.SendImage(data);
			}
		)
}
