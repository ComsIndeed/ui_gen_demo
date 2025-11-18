# GitHub Actions Workflows

## Release Workflow

This workflow automatically creates releases when the version in `pubspec.yaml` changes.

### What it does:

1. **Detects version changes** - Monitors `pubspec.yaml` for version updates
2. **Builds for multiple platforms**:
   - Android (APK and App Bundle)
   - Windows (portable executable)
   - Web (for GitHub Pages and Firebase)
3. **Deploys web version** to GitHub Pages
4. **Creates GitHub Release** with:
   - Changelog from `CHANGELOG.yaml`
   - Download links for all platforms
   - Automatic version tagging

### Setup Instructions:

#### 1. Enable GitHub Pages
1. Go to your repository Settings > Pages
2. Set Source to "Deploy from a branch"
3. Select branch: `gh-pages` and folder: `/ (root)`
4. Save

#### 2. Firebase Hosting (Optional)
To enable Firebase deployment:

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Initialize Firebase in your project:
   ```bash
   firebase init hosting
   ```
   - Select your Firebase project (or create new)
   - Set public directory to: `build/web`
   - Configure as single-page app: Yes
   - Don't overwrite `index.html`

3. Get Firebase token:
   ```bash
   firebase login:ci
   ```

4. Add token to GitHub secrets:
   - Go to repository Settings > Secrets and variables > Actions
   - Create new secret: `FIREBASE_TOKEN`
   - Paste the token from step 3

5. Update the workflow:
   - Edit `.github/workflows/release.yml`
   - Uncomment the `deploy-firebase` job
   - Replace `your-firebase-project-id` with your actual project ID

#### 3. Updating the Changelog

Before bumping the version in `pubspec.yaml`, update `CHANGELOG.yaml`:

```yaml
versions:
  - version: 0.2.0  # New version
    date: 2025-11-18
    changes:
      - Added new feature X
      - Fixed bug Y
      - Improved performance of Z
  - version: 0.1.0  # Previous versions below
    date: 2025-11-18
    changes:
      - Initial release
```

#### 4. Creating a Release

1. Update `CHANGELOG.yaml` with new version info
2. Bump version in `pubspec.yaml`
3. Commit and push to main:
   ```bash
   git add CHANGELOG.yaml pubspec.yaml
   git commit -m "Bump version to 0.2.0"
   git push origin main
   ```
4. The workflow will automatically:
   - Build for all platforms
   - Deploy to GitHub Pages
   - Create a GitHub release with artifacts

### Notes:

- The workflow only triggers when `pubspec.yaml` is modified on the main branch
- All builds must succeed before creating the release
- Release artifacts are automatically named with version numbers
- GitHub Pages URL format: `https://USERNAME.github.io/REPO_NAME/`
