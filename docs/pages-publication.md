# Pages preview and publication

Part 12 adds the shared workflow `.github/workflows/documentation-pages.yml` and
an optional [consumer caller](../integration/preview-documentation-pages.yml).
The caller is a small second workflow in the source repository. It watches the
reviewed documentation branch and can also be run manually. Its checked-in
`publish: false` setting produces a site preview artifact only.

The Pages workflow checks out the **exact consumer commit that triggered it**
and the pinned generator commit. It does not regenerate documentation. Before
building, it verifies that the map and every generated file are committed and
unchanged, the ownership manifest agrees with the map, and the snapshot names
the same source repository and a full source commit. It then builds that
committed documentation with strict MkDocs validation. The preview artifact
contains the rendered site and a review note identifying the documentation,
documented source and generator commits. It can be inspected without enabling
GitHub Pages.

To adopt the preview, copy the caller to
`.github/workflows/preview-documentation-pages.yml`, replace both generator SHA
placeholders with the same reviewed full commit, and set `docs-branch` to the
branch that will receive the generated-documentation PR. Keep `publish: false`.
After the PR is reviewed and its generated files are committed to that branch,
the caller builds a preview from those committed files. A draft PR or the
earlier generation preview never becomes a published site by itself.

Production activation is a separate reviewed change: configure the repository's
Pages source as **GitHub Actions**, protect the `github-pages` environment for
the allowed publishing branch, grant the caller `pages: write` and
`id-token: write` as well as `contents: read`, and change `publish` to `true`.
The shared workflow packages a Pages artifact and runs `actions/deploy-pages`
only with that explicit input. A protected environment can require approval
before the deployment job starts. No repository has been configured or
published by this Part 12 change. See GitHub's [custom Pages workflow
guidance](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site)
and [deployment environment
rules](https://docs.github.com/en/actions/concepts/workflows-and-actions/deployment-environments).

The site is rebuilt for each preview from committed Markdown, JSON templates
and the repository-owned map. A source push can still create a draft docs PR
through the separate generation workflow; it does not alter the public site.
