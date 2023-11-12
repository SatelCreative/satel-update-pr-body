# Satel Update a Pull Request's Body


This centralized GitHub action updates the description of a Pull request with redoc and coverage links as well as badges 

### Usage

```yml 
  update-pr-body: 
    needs: [poetry-redoc, generate-badges]
    timeout-minutes: 10
    if: ${{ github.ref != 'refs/heads/main' }}
    # myposter-de/update-pr-description action doesn't run on a self-hosted runner
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    env:
      REDOC_LINKS: ${{ needs.poetry-redoc.outputs.REDOC_LINKS }}
      COVERAGE_LINKS: ${{ needs.poetry-redoc.outputs.COVERAGE_LINKS }}
      BADGE: ${{ needs.generate-badges.outputs.BADGE }}
      MAIN_BADGE: https://<PORTAL_LINK>/openapi/<repo-name>/${{ inputs.app-name }}-main.svg 
      MAIN_COVERAGE: https://<PORTAL_LINK>/openapi/coverage.html?repo=<repo-name>&branch=main&app=${{ inputs.app-name }}
    steps:
        - name: PR body action
          uses: SatelCreative/satel-update-pr-body@feature/custom-pr-body-action
          with:       
            app-name: ${{ inputs.app-name }}
            redoc-links: $REDOC_LINKS
            coverage-links: $COVERAGE_LINKS
            badge: $BADGE
            main-coverage: $MAIN_COVERAGE
            main-badge: $MAIN_BADGE
            github-token: ${{ secrets.GITHUB_TOKEN }}
   
```