<p align="center">
  <img src="logo.png" alt="logo" width="20%"/>
</p>
<h1 align="center">
  Fork News
</h1>
<h3 align="center">
  Keep your fork up to date
</h3>
<p align="center">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/VitorNoVictor/fork-news">
  <img alt="GitHub" src="https://img.shields.io/github/license/VitorNoVictor/fork-news">
  <img src="https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg" alt="Contributor Covenant Badge">
</p>

<p align="center">
  Fork News is a Github Action that opens a PR on your fork whenever there's a change on the upstream repository. 
</p>

## Installation

1. Add the file `fork-news.yml` to the `.github/workflows` folder. To create a new folder in a repository using the GitHub interface click on "Add file" and then “Create new file”. Type your new folder’s name in the area where you would write the file name, and at the end of the file name type a `/` to initilize it as a folder. After this you can create a new file in the folder.
2. Copy and paste the following content to your `fork-news.yml`. This will check for updates on a weekly basis, for more options change the cron schedule expression based on your needs. [Crontab guru](https://crontab.guru/) can be very helpful for that:

```yaml
name: Fork News
on:
  schedule:
    - cron: '0 10 * * 1' # Checks for updates every Monday at 10:00 AM
jobs:
  fork-news:
    runs-on: ubuntu-latest
    name: Syncing with parent repository
    steps:
      - id: fork-news-sync
        uses: vitornovictor/fork-news@v1.0.0
        with:
          from-branch: master
          to-branch: master
          access-token: ${{ secrets.FORK_NEWS_TOKEN }}
```

3. Create a [Github access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) with the `repo` scope and add it as a [secret to your repository](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository). e.g. `FORK_NEWS_TOKEN`.
4. Wait for the latest updates!

## Usage

Check the [`action.yml`](https://github.com/VitorNoVictor/fork-news/blob/main/action.yml) for more parameters to configure Fork News. 

### Email Notifications

It's possible to configure GitHub to send email notifications for PRs created by your own user. Go to __Settings > Notifications__ and under __Email notification preferences__ enable the option __Include your own updates__.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
