# Dashy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/codegram/dashy)

[![CI](https://github.com/codegram/dashy/actions/workflows/ci.yml/badge.svg)](https://github.com/codegram/dashy/actions/workflows/ci.yml) [![Docs](https://github.com/codegram/dashy/actions/workflows/docs.yml/badge.svg)](https://codegram.github.io/dashy)

## Adding real data

1. Get yourself a custom Personal Access Token from your GitHub account.
2. Start your locale console using `GITHUB_TOKEN=<your token> iex -S mix`
3. Run this piece of code:

```elixir
repo_name = "decidim/decidim"
Dashy.Fetcher.update_workflows(repo_name)
Dashy.Fetcher.update_workflow_runs(repo_name)
Dashy.Fetcher.update_all_workflow_run_jobs(repo_name)
```