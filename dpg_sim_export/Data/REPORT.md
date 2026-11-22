# Courtyard Vote

Courtyard Vote is an English-language DPG Simulator scenario for SDG 11, Sustainable Cities and Communities. It starts with 1,800 in budget and uses map region 5, which is available in the scenario selection scene. The scenario is ID 7 and includes 36 projects (P72–P107) and 12 events (E58–E69).

## Why this topic

In a city in Kazakhstan, drivers want parking, parents want a playground, and older residents want benches, shade and somewhere quiet to sit. The homeowners' association chair wants a timely decision, the district office (akimat) wants evidence for its report, and a nearby developer needs parking for a new building. The team builds a voting process people can check even if their preferred proposal loses.

Courtyard Vote is open-source software that an OSI or KSK can install for free. The code, voting rules, documentation and anonymised results are open for reuse. Other associations can adapt the tool to their rules, district offices and civic groups can use it to organise consultations, and researchers can study the anonymised results for participatory budgeting. Open rules and accessible participation support SDG 11 by giving residents a way to help shape their shared space.

## Scenario design

| Phase | What the team works through |
| --- | --- |
| Research | Collect views across the courtyard and learn how homeowners' votes are run. |
| Prototyping | Test ballot designs, quorum rules and ways to present the results. |
| Team recruitment | Find technical and community support people can trust. |
| MVP | Make the vote accessible and handle a sponsor's request to put parking first. |
| Market validation | Pilot the tool and decide how to handle 40 unverified paper ballots. |
| Development | Work on verification and accessibility, and decide what voting data to share. |
| DPG status application | Choose a licence, prepare registry evidence and handle a proposal that arrives mid-vote. |
| Release | Balance launch work with the first request for an outside installation. |
| Operation | Maintain the tool and respond to a disputed count. |

Each event gives the player two actions with a benefit and a cost. For example, a live tally can draw more voters and can also sway late voters. A tally revealed at closing gives people more room to decide independently, at the cost of some participation.

E63 is the pilot's turning point. Just before the vote closes, the OSI chair brings 40 paper ballots for parking, many from eligible owners who rent out their flats. If the team counts them under the existing paper ballot rules, it can close the vote on time, but parents quit the pilot and the team loses one market insight. Requiring every owner to confirm their vote by SMS or eGov code makes the count more trustworthy. Owners who live elsewhere remain eligible. Building the check costs 200 and delays the vote.

## Implementation and event logic

There are four projects and at least one event in each phase. An event must be listed in `ScenarioEvents` and match the current phase. Eight events use fixed days from the start of a project, so the decision comes up at the same point regardless of the project's length. Four use days before the end, so deadlines and late requests land close to completion. The offsets fit all four choices in the relevant phases, and pairs of events in the same phase have distinct trigger days for every project.

Each choice changes one budget or insight value. Payments and funding use money. Insights represent what the team gains or loses about the product, development, adoption or team. Most insight changes are one point, and E68 awards two market insights for the first installation outside the pilots. The button colours follow the specified Good and Bad statuses. Delays, privacy and other consequences the engine cannot track are described in the tooltips.

The condition trigger fields are empty because the engine checks scenario membership, phase and day. Events are written to work after either choice in earlier events. The two pilots are already part of the scenario setting, so their events can occur whichever project the player selects.

The official shared project table, `Data/Projects.csv`, is the intended balance baseline. P0 maps to P72, P1 maps to P73, and so on through P35 to P107. Each project keeps the original time cost, money cost and insights in all four columns. The new titles and descriptions tie those projects to the courtyard vote while preserving the base game's difficulty curve.

The assignment requires submissions to leave existing files untouched. Courtyard Vote therefore supplies its CSV rows in separate files and keeps its parameters in a new scenario JSON file. Scenario ID 7, P72–P107 and E58–E69 leave a gap after the official IDs for other contributions.

## Files

All paths below are relative to `dpg_sim_export/Data`.

| File | Contents |
| --- | --- |
| `Scenarios/Scenario_CourtyardVote.txt` | SDG, starting budget, map region and project and event references |
| `en/Scenarios_CourtyardVote.csv` | Scenario ID, title, description and parameter filename |
| `Projects_CourtyardVote.csv` | Costs and insight values for all 36 projects |
| `en/Projects_CourtyardVote.csv` | English project titles and descriptions |
| `Events_CourtyardVote.csv` | Timing and outcomes for all 12 events |
| `en/Events_CourtyardVote.csv` | English event descriptions, choices and outcome tooltips |
| `REPORT.md` | Design, implementation and contribution notes |

## How to integrate

For an English playtest, use a copy of `dpg_sim_export/Data`. The web loader reads the shared filenames. Keep each shared header and append the rows below it from the corresponding Courtyard Vote file. Keep `Scenarios/Scenario_CourtyardVote.txt` in the copy's `Scenarios` folder.

| New CSV | Shared CSV |
| --- | --- |
| `en/Scenarios_CourtyardVote.csv` | `en/Scenarios.csv` |
| `Projects_CourtyardVote.csv` | `Projects.csv` |
| `en/Projects_CourtyardVote.csv` | `en/Projects.csv` |
| `Events_CourtyardVote.csv` | `Events.csv` |
| `en/Events_CourtyardVote.csv` | `en/Events.csv` |

A temporary English playtest copy with these rows appended passed the web loader check. The loader found Courtyard Vote and resolved all 36 project IDs and 12 event IDs with their English text.

## Team members and contributions

- **Miras Kairatuly**: Balance data and English titles and descriptions for all 36 projects (P72 through P107).
- **Aruna Karagulova**: Scenario configuration and English registration, timing, outcomes and English text for all 12 events (E58 through E69), and this report.
