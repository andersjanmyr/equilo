# Equilo

Source code for [equilo.se](https://equilo.se), a Swedish website about
project management, coaching and yoga.

The site is built with [Hugo](https://gohugo.io/), a static site generator.
That means the site is just a set of text files (Markdown) that Hugo turns into
HTML. There is no database and no server-side code.

This guide assumes no prior experience with Hugo, Git or the command line.
It covers both macOS and Windows.

## How the site works

```
content/            The text of every page (Markdown files). Edit these.
  homepage/         The boxes shown on the start page
  pages/            One file per page (Projektledning, Yoga, Kontakt, ...)
data/               Contact details and social media links (YAML/JSON)
static/images/      Pictures used on the site
hugo.toml           Site settings and the main menu
themes/             The visual design (hugo-hero-theme). Rarely needs editing.
docs/               The generated website. Do not edit by hand (see Deploying).
.github/workflows/  The automation that builds and publishes the site
```

When you push changes to the `master` branch on GitHub, a GitHub Action runs
Hugo, writes the result to the `docs/` folder and commits it. GitHub Pages
then serves the `docs/` folder as equilo.se.

## 1. Install the tools

You need three things: Git, Hugo (the extended edition) and a text editor.

### macOS

1. Install [Homebrew](https://brew.sh/) if you do not have it. Open the
   Terminal app and paste the command shown on the Homebrew front page.
2. Install Git and Hugo:

   ```bash
   brew install git hugo
   ```

   Homebrew installs the extended edition of Hugo, which this site needs.

### Windows

1. Install [Git for Windows](https://git-scm.com/download/win). Accept the
   default options. This also gives you a program called "Git Bash", which is
   a terminal that understands the same commands as macOS.
2. Install Hugo with winget. Open PowerShell and run:

   ```powershell
   winget install Hugo.Hugo.Extended
   ```

   Make sure you pick the **Extended** edition. The theme uses SCSS, which the
   standard edition cannot process.
3. Close and reopen your terminal so it picks up the new programs.

### Both platforms

Install a text editor. [Visual Studio Code](https://code.visualstudio.com/)
is free and works well on both macOS and Windows.

Check that everything is installed by running these in a terminal
(Terminal on macOS, Git Bash or PowerShell on Windows):

```bash
git --version
hugo version
```

The Hugo output should include the word `extended`, for example
`hugo v0.166.0+extended`. The site is built with Hugo 0.166 in production, so
use that version or newer.

## 2. Get the code

In a terminal, go to the folder where you want to keep the project and clone
the repository:

```bash
cd ~/projects
git clone https://github.com/andersjanmyr/equilo.git
cd equilo
```

On Windows, `~/projects` works in Git Bash. In PowerShell use a path such as
`C:\Users\YourName\projects` instead. Create the folder first if it does not
exist.

## 3. Run the site locally

From inside the `equilo` folder, start Hugo's development server:

```bash
hugo server
```

Open <http://localhost:1313> in your browser. You should see the site.

Leave the terminal window open. Every time you save a file, Hugo rebuilds the
site and the browser refreshes by itself. Press `Ctrl+C` in the terminal to
stop the server.

To also see pages that are marked as drafts, run `hugo server -D` instead.

## 4. Make changes

### Edit the text on a page

The pages live in `content/pages/`. Each file is a Markdown file with a
settings block at the top (between the `---` lines) and the page text below.

```markdown
---
title: 'Yoga'
heroHeading: 'Yoga'
heroSubHeading: 'A short line shown under the heading'
heroBackground: 'images/service1.jpg'
---

The page text goes here. Blank lines separate paragraphs.
```

Edit the text, save, and check the result in the browser.

### Edit the start page

The boxes on the start page are the files in `content/homepage/`. The `weight`
setting controls the order. Lower numbers come first.

### Change the menu

The main menu is defined at the bottom of `hugo.toml`. Each `[[menu.main]]`
block is one menu item. `weight` controls the order.

### Change contact details or social links

Edit `data/contact.yaml` and `data/social.yaml`. Leave a value empty
(`""`) to hide that link.

### Add a picture

Put the image file in `static/images/` and refer to it as `images/filename.jpg`
in the page settings, or in the page text as:

```markdown
![Description of the image](/images/filename.jpg)
```

Keep images reasonably small (under about 500 KB) so the site stays fast.

### Add a new page

1. Copy an existing file in `content/pages/`, for example `yoga.md`, and give
   it a new name such as `new-page.md`. The file name becomes the address,
   so this example is reachable at `/new-page/`.
2. Change the `title` and text.
3. Add a `[[menu.main]]` block in `hugo.toml` if the page should appear in the
   menu.

## 5. Publish your changes

Publishing is done with Git. The commands are the same on macOS and Windows.

1. See which files you have changed:

   ```bash
   git status
   ```

2. Stage and commit the changes with a short message describing what you did:

   ```bash
   git add content/pages/yoga.md
   git commit -m "Update the yoga page"
   ```

   Use `git add .` to stage every changed file at once.

3. Send the commit to GitHub:

   ```bash
   git push
   ```

A few minutes after you push, GitHub builds the site and the change is live
at equilo.se. You can follow the build under the "Actions" tab of the
repository on GitHub.

Before you start a new round of changes, fetch what others have pushed:

```bash
git pull
```

## Deploying

You never need to build the site yourself. The GitHub Action in
`.github/workflows/deploy.yml` runs `hugo` on every push to `master`, commits
the output in `docs/` with the message "Generate site", and pushes it back.
The CNAME file in `static/` points GitHub Pages to the equilo.se domain.

Because the action commits to the repository, remember to `git pull` after a
deploy so your local copy includes the generated files.

If you do run `hugo` locally it will also write to `docs/`. That is harmless,
but there is no need to commit those files. The action regenerates them anyway.

## Troubleshooting

**`hugo: command not found`**
Hugo is not installed or your terminal has not been restarted since the
install. Close the terminal, open a new one and try again.

**The build fails with an error about SCSS, Sass or "extended"**
You have the standard edition of Hugo. Reinstall the extended edition as
described in step 1.

**`git push` is rejected**
Someone else has pushed, or the GitHub Action has committed generated files.
Run `git pull`, then `git push` again.

**The site looks right locally but not on equilo.se**
Check the Actions tab on GitHub for a failed build. If the build succeeded,
try a hard refresh in the browser (`Cmd+Shift+R` on macOS, `Ctrl+Shift+R` on
Windows) to bypass the cache.

**Changes in `docs/` show up in `git status`**
You ran `hugo` locally. You can leave these files out of your commit, or
discard them with `git checkout docs/`.

## Further reading

- [Hugo documentation](https://gohugo.io/documentation/)
- [Markdown guide](https://www.markdownguide.org/basic-syntax/)
- [Git basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- The theme's own documentation is in `themes/hugo-hero-theme/README.md`
