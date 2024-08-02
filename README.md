# Emacs mode to edit [paradox](http://wikis.paradoxplaza.com/) mod files. Adapted for lsp-mode and cwtools.

Forked base package def from `Drup/paradox`. Requires a local lsp server binary from `cwtools/cwtools-vscode`.

# Installation (debian) 
## cwtools
1. install dotnet package signing key
(see https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian )

``` sh
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```

2. install requirements with `sudo apt install dotnet-sdk-8.0 mono-complete`
3. download the cwtools vscode extension `git clone https://github.com/cwtools/cwtools-vscode.git`
4. update the dependency `MSBuild.StructuredLogger`

``` sh
diff --git a/paket.dependencies b/paket.dependencies
index 3607817..e88509b 100644
--- a/paket.dependencies
+++ b/paket.dependencies
@@ -49,4 +49,4 @@ group build
     nuget Fake.Core.ReleaseNotes
     nuget Fake.Api.GitHub
     nuget FSharp.Collections.ParallelSeq
-    nuget MSBuild.StructuredLogger >= 2.1.784
+    nuget MSBuild.StructuredLogger >= 2.2.243

```

5. Build the lsp server `./build.sh BuildServer`
## emacs package (doom)
packages.el:

``` emacs-lisp
(package! pdx :recipe (:host github :repo "maltelau/pdx.el"))
```
config.el:

``` emacs-lisp
(use-package! pdx
  :hook (pdx-mode . lsp)
  :mode ("/Europa Universalis IV/.*\\.txt\\'" . pdx-mode))
```



# TODO
- [x] adapt major mode
- [ ] check that we're using all capabilities of cwtools
- [ ] install instructions and packaging
