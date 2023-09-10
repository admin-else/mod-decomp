import os

def process_file(filepath, mappings):
    print(f"Processing {filepath}")
    if not filepath.endswith(".java"):
        return

    with open(filepath, "r") as f:
        raw = f.read()

    for mapping in mappings:
        raw = raw.replace(mapping[0], mapping[1])

    path = os.path.dirname(filepath)
    os.makedirs(path, exist_ok=True)

    try:
        raw = raw.split("*/\n", 1)[1]
    except IndexError:
        pass

    with open(filepath, "w") as f:
        f.write(raw)

def main():
    with open("mappings.tiny") as f:
        raw = f.read()

    mappings = []
    for line in raw.split("\n"):
        line = line.split("\t")
        if len(line) <= 1 or "_" not in line[-2] or line[-1] == line[-2]:
            continue
        if "class_" in line[-2]:
            mappings.append((
                line[-2].replace("/", "."),
                line[-1].replace("/", ".")
            ))
            mappings.append((
                line[-2].split("/")[-1],
                line[-1].split("/")[-1]
            ))
        else:
            mappings.append((line[-2], line[-1].replace("/", ".")))

    valid_mappings = []
    for mapping in mappings:
        try:
            num = int(mapping[0].split("_")[1])
            valid_mappings.append((num, mapping))
        except (ValueError, IndexError):
            pass

    valid_mappings.sort(key=lambda x: x[0], reverse=True)
    sorted_mappings = [v[1] for v in valid_mappings]

    for root, dirs, files in os.walk("decomp"):
        for filename in files:
            filepath = os.path.join(root, filename)
            process_file(filepath, sorted_mappings)

if __name__ == "__main__":
    main()
