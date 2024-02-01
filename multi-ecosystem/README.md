# Using Safety as a GitHub Action

Support for JavaScript dependency scanning in Safety CLI 3 is being rolled out, first to specific customers and then to the larger Safety community. Please read the following [guide](https://docs.safetycli.com/safety-cli-javascript/safety-cli-3/safety-cli-3-with-javascript-support) to know more about the current features and limitations. 

Safety can be integrated into your existing GitHub CI pipeline as an action. Just add the following as a step in your workflow YAML file after setting your `SAFETY_API_KEY` secret on GitHub under Settings -> Secrets -> Actions:

```yaml
      - uses: pyupio/safety-action/multi-ecosystem@main
        with:
          api-key: ${{ secrets.SAFETY_API_KEY }}
```

(Don't have an API Key? You can sign up for one with [https://safetycli.com/resources/plans](https://safetycli.com/resources/plans).)

This will run Safety scan and It'll fail your CI pipeline if any vulnerable packages are found.

If you have something more complicated such as a monorepo; or once you're finished testing, read the [Documentation](https://docs.safetycli.com/) for more details on configuring Safety as an action.
