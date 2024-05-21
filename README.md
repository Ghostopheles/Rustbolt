# World of Warcraft Addon Template

This repository is used as a template for creating World of Warcraft addons. Includes a `.pkgmeta` file, and a Github action for the [BigWigs packager](https://github.com/BigWigsMods/packager).

### Usage

> [!IMPORTANT]
> If you're creating a repository using this template, you'll need to change all mentions of `CHANGEME` to best fit your addon.

#### Packaging

- Under repository settings -> Actions, change "Workflow permissions" to "Read and write permissions"
- Under repository settings -> Secrets and variables, create repository secrets for `CF_API_KEY` and `WAGO_API_TOKEN`
    - If you don't want to automatically publish your addon to Curseforge or Wago Addons, you can skip this step and remove the environment variables from [the packaging workflow](.github/workflows/release.yml).
    - Additionally, you'll want to remove the `X-{site}-ID` TOC directives in your [TOC file](MyAddon.toc).
- In your [TOC file](MyAddon.toc), change the two `X-{site}-ID` directives to point to your Curseforge/Wago project ID.

> [!NOTE]
> By default, the packager will package and publish your addon every time you create a tag. To create alpha or beta releases, simply include `alpha` or `beta` somewhere in the tag name.

And last but not least, probably edit this README to be a bit more personalized for your use-case. For more information on how to use the packager, see the [BigWigs packager](https://github.com/BigWigsMods/packager) repo.