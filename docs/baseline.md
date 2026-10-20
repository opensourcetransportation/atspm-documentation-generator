# Pinned public ATSPM baseline

The regression fixture uses commit `82bc9983533671a00d92532289c438e54a5f60e5`
from [`opensourcetransportation/atspm`](https://github.com/opensourcetransportation/atspm).
That public commit contains the source definitions used by the six-page ATSPM
map. Its timestamp is `2026-09-29T10:54:25-06:00`.

The map, expected Markdown, ownership manifest, and metadata live in
`tests/baselines/atspm`. They are test fixtures, not documentation published to
the ATSPM repository. The baseline has six service pages, 16 named configuration
bindings, 91 log messages, and eight explicitly allowed duplicate event IDs.
The expected source links point to the public repository at the pinned commit.

The generator compares new output with the frozen service and log pages. The
index, manifest, configuration snapshot, change report, and downloadable
templates have separate checks for the additions made since the baseline.
Do not refresh expected pages merely to silence a failure; review the source or
generator change first.

To reproduce the check, use a clean checkout of the pinned public commit:

```powershell
git clone https://github.com/opensourcetransportation/atspm.git _source/public-atspm
git -C _source/public-atspm checkout 82bc9983533671a00d92532289c438e54a5f60e5
dotnet build GenerateDocuments.sln --configuration Release
python scripts/check_baseline.py --source-root _source/public-atspm
python scripts/validate_repository.py
```

The current ATSPM `main` branch can have a different configuration contract.
When adopting the generator there, review and update its repository-owned map
against the branch being documented. The pinned baseline protects generator
compatibility; it does not assert that today's `main` needs no map changes.
