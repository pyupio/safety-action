# Using Safety as a GitHub Action

Support for JavaScript dependency scanning in Safety CLI 3 is being rolled out, first to specific customers and then to the larger Safety community. Please read the following [guide](https://docs.safetycli.com/safety-cli-javascript/safety-cli-3/safety-cli-3-with-javascript-support) to learn more about the current features and limitations. 

Specifically, running this Action in your workflow requires:

* That your Safety CLI policy file is version 3.1 - you can check this by opening the file. If you are using an older policy file read our [guide](https://docs.safetycli.com/safety-cli-javascript/safety-cli-3/safety-cli-3-with-javascript-support) for upgrading to 3.1
* For JavaScript package vulnerability scans, enable JavaScript scanning in your 3.1 version policy file (it is disabled by default)
* Setting the `SAFETY_API_KEY` secret in GitHub your project Settings -> Secrets -> Actions. All accounts (including free forever) give you access to an API key

Safety can be integrated into your existing GitHub CI pipeline as an action. Just add the following as a step in your workflow YAML file after setting your `SAFETY_API_KEY` secret on GitHub under Settings -> Secrets -> Actions:

```yaml
      - uses: pyupio/safety-action/multi-ecosystem@main
        with:
          api-key: ${{ secrets.SAFETY_API_KEY }}
```

(Don't have an API Key? You can sign up for one with [https://safetycli.com/resources/plans](https://safetycli.com/resources/plans).)

This will run Safety scan and It'll fail your CI pipeline if any vulnerable packages are found.

If you have something more complicated such as a monorepo; or once you're finished testing, read the [Documentation](https://docs.safetycli.com/) for more details on configuring Safety CLI as an action, and specifically [configuring Safety](https://docs.safetycli.com/safety-docs/administration/safety-policy-files).
