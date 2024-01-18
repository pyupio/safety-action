# Using Safety as a GitHub Action

Safety can be integrated into your existing GitHub CI pipeline as an action. Just add the following as a step in your workflow YAML file after setting your `SAFETY_API_KEY` secret on GitHub under Settings -> Secrets -> Actions:

```yaml
      - uses: pyupio/safety-action@v1
        with:
          api-key: ${{ secrets.SAFETY_API_KEY }}
```

(Don't have an API Key? You can sign up for one with [https://safetycli.com/resources/plans](https://safetycli.com/resources/plans).)

This will run Safety scan and It'll fail your CI pipeline if any vulnerable packages are found.

If you have something more complicated such as a monorepo; or once you're finished testing, read the [Documentation](https://docs.safetycli.com/) for more details on configuring Safety as an action.
