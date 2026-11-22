# Water Turns

Two villages take turns drawing water from one irrigation canal. The gate book records when a gate opens. The grower at the far end needs to know when water will reach the field. This gap gives the player a concrete problem to investigate in the first week and a way to judge the pilot later. The scenario belongs to the water region (6) and addresses SDG 6 through community participation in water management.

## What the player builds

Water Turns is an open-source irrigation roster that a cooperative can run and another canal can adapt. A grower should be able to check a turn on a shared phone or a printed sheet. A keeper should be able to explain which revision is current and who agreed to a swap. The public toolkit can ship with fictional assignments while each village keeps its live roster locally.

## Implementation and design

The English scenario list loads `Scenario_WaterTurns.txt`. It starts the player with 1,800 DPGs and sets four project choices in each of the nine existing phases. The 36 project records use the prefix `P_WT_` and the nine events use `E_WT_`. The shared project and event CSVs contain the mechanics. Their English counterparts supply the titles, descriptions, decisions and outcomes.

Projects take 28 to 56 days and cost 25 to 75 DPGs. For example, posting a read-only roster for one gate takes 28 days and costs 25. Building a swap slip takes 56 days and costs 75, and earns more product and development insights. The longer project also exposes the team to more payroll cycles. Starting funds match the existing Water Footprint scenario.

| Phase | Event and decision | Trigger |
| --- | --- | --- |
| Research | **An hour of what?** Walk to the last field with a grower or borrow clocks to measure the delay. | Project day 7 |
| Prototyping | **Two Fridays** Number competing editions or listen to how callers identify a turn. | Project day 7 |
| Team recruitment | **The spare key** Train a relief keeper or accept a loan phone for the pilot. | Project day 7 |
| MVP | **A swap in pencil** Show a half-signed swap as pending or keep displaying the agreed slot. | Project day 7 |
| Market validation | **A perfect week?** Check apparently perfect delivery records through field visits or a call hour. | 7 days before project completion |
| Development | **Two keepers offline** Test conflicting edits or agree on a process to settle them. | Project day 7 |
| DPG status application | **Names in the sample** Publish a fictional test week or a blank form that another canal can try. | 7 days before project completion |
| Release | **Market day moves** Replace the posted sheets or broadcast the revision on local radio. | Project day 7 |
| Operation | **Next season's keeper** Rehearse a handover or collect funds for the next season. | 7 days before project completion |

Each event requires the active scenario, the matching phase and the specified project day. The three end-relative events give the player time to gather pilot evidence, prepare the public release or conclude a season. In a 28-day project these reviews happen on day 21. In a 56-day project they happen on day 49.

Both responses to each event have a practical benefit. After the offline conflict, replaying the edits gives two maintainers a reproducible failure to fix (+3 development insights). A joint review gives the keepers an agreed handover procedure (+2 team insights). The player chooses which capability to strengthen.

## How to play the scenario locally

From the repository root, run `python -m http.server 8000 --bind 127.0.0.1 --directory dpg_sim_export` and open `http://127.0.0.1:8000/?lang=en`. Press **Start**, dismiss the map prompt and select the water region at the bottom right. Choose **Water Turns**, start the scenario and open **Project**. Pick a research project and let seven project days pass to reach **An hour of what?** Choose a response and confirm its outcome to resume the clock.

## Verification

A browser playthrough of the local English web export reached the score screen with 11,644 points and 727 DPGs remaining. All nine events appeared. The run took the first response in odd-numbered phases and the second in even-numbered phases. A separate check using the shipped CSV parser resolved all 36 project choices and all 18 event outcomes, and verified that each event falls within the duration of every project in its phase.

## Contribution and AI use

Individual submission by GitHub user `kadyrbaev555` – Kadyrbayev Akzhol. OpenAI GPT-6.2 Astra was used to brainstorm scenario ideas, including the irrigation-roster concept.