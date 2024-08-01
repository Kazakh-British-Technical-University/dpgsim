# [DPG Simulator](https://gamelab-kbtu.itch.io/dpg-simulator)
DPG Simulator is a tycoon game that gives players control over a small company willing to make Digital Public Good.

In the physical world, we already have different public goods - things that are accessible to anyone and are beneficial to society, like docs, roads, and parks. Digital Public Goods come in the form of software, data sets, AI models, or content, that is free and open-source and contribute to sustainable development goals.

Balance strategies, finances, size of the team, and development process to not become bankrupt and release your product to help those in need.

# Start locally
The game build and data is found in <b>dpg_sim_export</b> folder. To run it you will need to deploy this folder to a web-server of your choice.

To deploy it on your machine you can use:
* Visual Studio Code with [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) extension
* [http-server](https://www.npmjs.com/package/http-server) npm package
* Tools like [XAMPP](https://www.apachefriends.org/)

# Contribution
DPG Simulator itself is designed as a DPG. You can contribute by fixing bugs and addressing issues, adding localizations for other languages, and adding custom scenarios (comming soon).

In order to fix any issues with internal game files, you can open the project located at <b>dpg_sim_game/project.godot</b> in Godot. This project uses [Godot version 3.5.3](https://godotengine.org/download/archive/3.5.3-stable/)

Before starting the contribution, be sure to check Issues page. If needed, create a new issue, discuss it with the community and then make a pull request.

## Localization
All localization files are located under <b>dpg_sim_export/Data/[YourLanguage]</b> and appear as .csv or .txt files. List of available languages is located at <b>dpg_sim_export/Data/Languages.txt</b>.

To add a new language duplicate "EN" folder and rename it as a code for new language ([Language codes](https://meta.wikimedia.org/wiki/Template:List_of_language_names_ordered_by_code)). In every file translate everything that is within quotation marks to a new language. Then add a new entry to <b>Languages.txt</b> file.
* Name : Local name of the language
* Path : Name of the created folder
* IconIndex : index of flag associated with language. You need to open <b>dpg_sim_game/Sprites/UI/countryFlags.png</b> and calculate the index of the flag. Starting from 0 left to right and up to down. (eg.: UK is 82, Russia is 200)

## Custom scenarios (coming soon)

# Screenshots
<img src="https://raw.githubusercontent.com/Kazakh-British-Technical-University/dpgsim/main/screenshots/dpg-sim-1.png" width="512"/>
<img src="https://raw.githubusercontent.com/Kazakh-British-Technical-University/dpgsim/main/screenshots/dpg-sim-2.png" width="512"/>
<img src="https://raw.githubusercontent.com/Kazakh-British-Technical-University/dpgsim/main/screenshots/dpg-sim-3.png" width="512"/>
<img src="https://raw.githubusercontent.com/Kazakh-British-Technical-University/dpgsim/main/screenshots/dpg-sim-4.png" width="512"/>
