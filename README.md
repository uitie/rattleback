# Rattleback

A [Rattleback](https://en.wikipedia.org/wiki/Rattleback) is a geometric shape that will only spin in a single direction.  Any attempt to spin it in a direction other then the intended direction results in it becoming unstable until it spins in the correct direction.

This is an apt comparison to the ecosystem of security tools.  Some IaC is developed, which when spun up is inundated with security alerts making the DevOps' life unstable until the IaC is corrected and the fix applied.  This repository is an attempt to capture known bad configurations that should generate alerts.

## Directory layout

In order to make the best use of this repo the idea is for the IaC to be applied directly from this repository.

- `<provider>` - The infrastructure provider.
    - `<tool>` - The layout starts with the tool needed to apply the IaC (i.e., `terraform`).
        - `<test case>` - The test case.  The name should be hyphen delimited, and descriptive of the issue being created.

Each level should have a README.md that describes what is being done, and any pre-conditions (aside from the account) that are needed.

## Local Usage

This repo is meant to be run from within the dev-container, which contains all the tools needed.

### Sensitive info

Where possible we mount the correct local auth files like `~/.gcloud/` so that any local auth can be used on the container.  We also ignore the `./.env` file and `*.tfvars` so that you can use those - if needed - to house sensitive infomation.

## Resources

### *Goat

[Bridgecrew](https://github.com/bridgecrewio) used to actively maintain a series of "Goat" repos which housed invalid configurations that their tool `checkov` checked for. While the tool is still being maintained the "Goat" repos are not.

One major issue with the "Goat" repos is that because they were designed to be used by a static code tools they are not written in a realistic way.  This means that while all the code can be scanned, it often cannot be applied, and therefore not all remediations can actually be tested.
