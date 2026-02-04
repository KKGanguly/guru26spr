
---

## Homework (1 Week): CSV Processor

**Your Lee McMahon moment**: Build tools for CSV analysis.

Ship something tiny. Let your classmates use it. Iterate.

### Requirements (All Students)

Create three files:

#### `csv.rc`

```sh
#!/bin/bash

# Count rows and columns
count() {
  local rows=$(tail -n +2 "$1" | wc -l)
  local cols=$(head -1 "$1" | tr ',' '\n' | wc -l)
  echo "Rows: $rows, Cols: $cols"
}

# Summarize numeric column
summarize() {
  local file=$1
  local col=$2
  gawk -F, -v c=$col '
    NR>1 { sum+=$c; n++ }
    END { printf "Mean: %.2f, Sum: %.2f\n", sum/n, sum }
  ' "$file"
}

# Show specific columns
showcol() {
  local file=$1
  shift
  cut -d, -f"$*" "$file" | column -t -s,
}
```

┌─ Reading Guide ────────────────────────────────┐
│ tail -n +2   →  Skip first line (header)       │
│ tr ',' '\n'  →  Replace commas with newlines   │
│ gawk -F,     →  Use comma as field separator   │
│ shift        →  Remove $1, shift args down     │
│ column -t    →  Format as aligned table        │
└────────────────────────────────────────────────┘

#### `Makefile`

```makefile
B := $(shell tput setaf 4)
G := $(shell tput setaf 2)
X := $(shell tput sgr0)

.PHONY: help
help:  ## Show this help
	@gawk 'BEGIN {FS = ":.*?## "} \
	       /^[a-zA-Z_-]+:.*?## / \
	       {printf "$(B)%-12s$(X) %s\n", $$1, $$2}' \
	       $(MAKEFILE_LIST)

setup:  ## Create data/ directory
	@mkdir -p data reports

view:  ## Display CSV nicely
	@column -t -s, data/*.csv

report:  ## Generate summary for all CSVs
	@for f in data/*.csv; do \
	  echo "=== $$f ===" > reports/$$(basename $$f .csv).txt; \
	  bash csv.rc count "$$f" >> reports/$$(basename $$f .csv).txt; \
	  bash csv.rc summarize "$$f" 2 >> reports/$$(basename $$f .csv).txt; \
	done
	@echo "$(G)Reports generated$(X)"

clean:  ## Remove reports
	@rm -rf reports/*.txt
```

#### `README.md`

```markdown
# CSV Tools

## Usage

```sh
make help      # Show all commands
make setup     # Create directories
make view      # Display CSVs
make report    # Generate summaries
```

## Functions

```sh
source csv.rc
count data/sales.csv
summarize data/sales.csv 2
showcol data/sales.csv 1,3
```
```

### Test It

```sh
# Create sample data
mkdir -p data
cat > data/sales.csv << EOF
month,revenue,costs
Jan,1000,600
Feb,1500,700
Mar,1200,650
EOF

# Run commands
make setup
make view
make report
cat reports/sales.txt
```

Expected output in `reports/sales.txt`:
```
=== data/sales.csv ===
Rows: 3, Cols: 3
Mean: 1233.33, Sum: 3700.00
```

### Deliverables

1. `csv.rc` with `count()`, `summarize()`, `showcol()`
2. `Makefile` with working `help` target
3. `README.md` showing usage
4. Sample `data/*.csv` and generated `reports/*.txt`

**Ship it to a classmate. Get feedback. Iterate.**

---

### Graduate Extension (+40%)

Add these to your submission:

#### 1. Parallel Processing

```makefile
report-parallel:  ## Generate reports in parallel
	@ls data/*.csv | xargs -P 4 -I {} bash -c \
	  'f={}; o=reports/$$(basename $$f .csv).txt; \
	   echo "=== $$f ===" > $$o; \
	   bash csv.rc count "$$f" >> $$o'
```

#### 2. Validation

```makefile
validate:  ## Check CSV format
	@for f in data/*.csv; do \
	  awk -F, 'NR==1 {n=NF} NF!=n {print "Bad: " FILENAME; exit 1}' $$f; \
	done && echo "$(G)All CSVs valid$(X)"
```

#### 3. Dynamic Column Selection

Modify `summarize()` to accept column name, not just number:

```sh
summarize() {
  local file=$1
  local colname=$2
  gawk -F, -v col="$colname" '
    NR==1 { for(i=1;i<=NF;i++) if($i==col) c=i }
    NR>1 { sum+=$c; n++ }
    END { printf "Mean: %.2f, Sum: %.2f\n", sum/n, sum }
  ' "$file"
}
```

Usage:
```sh
summarize data/sales.csv revenue
```

#### 4. Error Handling

```sh
count() {
  if [[ ! -f "$1" ]]; then
    echo "Error: File not found: $1" >&2
    return 1
  fi
  local rows=$(tail -n +2 "$1" | wc -l)
  local cols=$(head -1 "$1" | tr ',' '\n' | wc -l)
  echo "Rows: $rows, Cols: $cols"
}
```

#### 5. Multi-Tool Pipeline

Show shell as glue:

```makefile
analyze:  ## Multi-language analysis
	@echo "$(B)Python:$(X) Extract rows"
	@python3 -c "import csv; print(list(csv.reader(open('data/sales.csv'))))"
	@echo "$(B)AWK:$(X) Compute totals"
	@awk -F, 'NR>1 {sum+=$$2} END {print "Total:", sum}' data/sales.csv
	@echo "$(B)Ruby:$(X) Pretty print"
	@ruby -rcsv -e 'CSV.foreach(ARGV[0]) {|r| puts r.join(" | ")}' data/sales.csv
```

---

## Grading Rubric

| Item                          | Points |
|-------------------------------|--------|
| `make help` works             | 20     |
| `csv.rc` functions work       | 30     |
| Reports generated correctly   | 30     |
| Code is clean, documented     | 20     |
| **Grad Extension (optional)** | +40    |

Submit: `<lastname>_csv.zip` containing all files.

---

## Key Takeaways

1. **Shell = glue, not compute**
2. **Make = orchestration, not execution**
3. **Decentralized tools** > monolithic systems
4. **Exit codes** > exceptions in shell
5. **Small tools, fast iteration** > big plans

**Like grep: small tools, real users, quick iterations.**

Questions? Read the source. It's only 50 lines.
`
