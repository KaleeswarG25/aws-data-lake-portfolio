"""Generate a small synthetic dataset for the pipeline."""
import csv, random, uuid
from datetime import datetime, timedelta
from pathlib import Path

OUT = Path("data/sample.csv")
OUT.parent.mkdir(exist_ok=True)

rows = 1000
customers = [f"cust_{i:03d}" for i in range(1, 51)]
base = datetime(2024, 1, 1)

with OUT.open("w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["id", "event_ts", "customer", "amount", "product"])
    for i in range(rows):
        ts = base + timedelta(minutes=random.randint(0, 60 * 24 * 7))
        amount = round(random.uniform(5, 500), 2)
        product = random.choice(["A", "B", "C", "D"])
        # inject ~5% nulls to exercise cleaning logic
        if random.random() < 0.05:
            amount = ""
        if random.random() < 0.03:
            ts = ""
        w.writerow([str(uuid.uuid4()), ts.isoformat() if ts else "", random.choice(customers), amount, product])

print(f"Wrote {rows} rows -> {OUT}")