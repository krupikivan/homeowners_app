from flask import Flask, request, jsonify
import sys

app = Flask(__name__)

@app.route("/")
def index():
    return "Running Flask App!"

def get_fit_score(goals, scores):
    # Calculate the score value
    return sum(goals[key] * scores.get(key, 0) for key in goals)


def organize_buyers_into_neightborhoods(home_buyers, neighborhood):
    buyers_distributed = {k: [] for k in neighborhood.keys()}
    length = len(home_buyers) // len(neighborhood)
    for k, v in home_buyers.items():
        new_prefs = {pref: 0 for pref in v["preferences"]}
        for pref in v["preferences"]:
            new_prefs[pref] += get_fit_score(v["goals"], neighborhood[pref])
        home_buyers[k]["preferences"] = new_prefs
    # Sort the buyers by their E key
    sorted_buyers = sorted(
        home_buyers.items(),
        key=lambda x: next(iter(x[1]["preferences"].values())),
        reverse=True,
    )
    fixed_buyers = [(buyer[0], buyer[1]["preferences"]) for buyer in sorted_buyers]
    while len(fixed_buyers) > 0:
        buyer_name, buyer_prefs = fixed_buyers[0]
        pref_1 = list(buyer_prefs.keys())[0]
        if len(buyers_distributed[pref_1]) < length:
            buyers_distributed[pref_1].append(f"{buyer_name}({buyer_prefs[pref_1]})")
            del fixed_buyers[0]
            continue
        else:
            # Check if there is another buyer with pref greater than the current buyer
            temp_buyer = fixed_buyers[0]
            for prefs in buyer_prefs.keys():
                if len(buyers_distributed[prefs]) < length:
                    for i in range(1, len(fixed_buyers)):
                        buyer_check = fixed_buyers[i][1]
                    if (
                        prefs == list(buyer_check.keys())[1]
                        and list(buyer_check.values())[1]
                        > list(temp_buyer[1].values())[1]
                    ):
                        temp_buyer = fixed_buyers[i]
                    if temp_buyer == fixed_buyers[0]:
                        if len(buyers_distributed[prefs]) < length:
                            buyers_distributed[prefs].append(
                                f"{temp_buyer[0]}({temp_buyer[1][prefs]})"
                            )
                            del fixed_buyers[0]
                            temp_buyer = fixed_buyers[0]

    for prefs in buyer_prefs.keys():
        buyers_distributed[prefs] = sorted(
            buyers_distributed[prefs],
            key=lambda x: int(x.split("(")[1].rstrip(")")),
            reverse=True,
        )
    return buyers_distributed

@app.route("/execute", methods=["POST"])
def execute():
    input = request.json["input_file"]
    neighborhood = {}
    home_buyers = {}
    with open(input, "r") as input_file:
        for line in input_file:
            data = line.strip().split(" ")
            if data[0] == "N":
                neighborhood_name = data[1]
                neighborhood_scores = {}
                for score in data[2:]:
                    key, value = score.split(":")
                    neighborhood_scores[key] = int(value)
                neighborhood[neighborhood_name] = {
                    k: int(v) for k, v in (item.split(":") for item in data[2:])
                }

            else:
                home_buyers[data[1]] = {
                    "goals": {
                        k: int(v) for k, v in (item.split(":") for item in data[2:5])
                    },
                    "preferences": data[5].split(">"),
                }
    buyers_organized = organize_buyers_into_neightborhoods(home_buyers, neighborhood)

    with open('output.txt', "w") as output_file:
        for name, data in buyers_organized.items():
            output_file.write(f"{name}: ")
            for item in data:
                output_file.write(item + " ")
            output_file.write("\n")
    response = {
        "output_file": "output.txt",
        'data': buyers_organized
    }
    return jsonify(response)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
