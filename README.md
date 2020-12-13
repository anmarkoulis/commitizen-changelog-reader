# commitizen-changelog-reader

Read changelog entries for a specific version in changelog files created
by [commitizen](https://commitizen-tools.github.io/commitizen/).

## Description

This action can be used in order to create a release in Github for a repository
and add in the release notes the relevant entries for the release that are
found in the Changelog. The changelog format that is currently supported is the
one that is created
by [commitizen-action](https://github.com/commitizen-tools/commitizen-action).

An indicative changelog created by the action is the following:

```txt
## v0.2.0 (2020-12-12)

### Feat

- **users**: support deletion of users using the DELETE api/users endpoint

### Fix

- **users**: fix nickname field in GET api/users endpoint returning the nickname without an empty character.

## v0.1.1 (2020-11-05)


### Fix

- **about**: fix error message not properly showing up its minor component.

## v0.1.0 (2020-08-12)

### Feat

- **about**: add about endpoint with proper version

### Fix

- **messages**: fix error messages in GET api/users/endpoint 
```

## Usage

An example usage of the action is the following:

## Sample Workflow

```yaml
name: Bump version

on:
  push:
    branches:
      - master

jobs:
  release:
    if: startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@main
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          fetch-depth: 0
      - name: Setup Python
        uses: actions/setup-python@v2.1.4
        with:
          python-version: 3.8.6
          architecture: x64
      - name: Get version from tag
        id: tag_name
        run: |
          echo ::set-output name=current_version::${GITHUB_REF#refs/tags/v}
        shell: bash
      - name: Get notes
        id: generate_notes
        uses: anmarkoulis/commitizen-changelog-reader@master
        with:
          tag_name: ${{ github.ref }}
          changelog: CHANGELOG.md
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          prerelease: false
          draft: false
          body: ${{join(fromJson(steps.generate_notes.outputs.notes).notes, '')}}
```

## Input Variables

| Name                 | Description                                                                                                                                                | Default     |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `tag_name`           | Name of the tag whose release notes we are looking for                                                                                                     | -           |
| `changelog`          | Path to changelog file                                                                                                                                     | -       |

## Output Variables

| Name                 | Description                                                                                                                                                | Default     |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `notes`              | Serialized dictionary as string containing the `notes` key which hosts the list of lines that hold data for the aforementioned tag                         | -           |
